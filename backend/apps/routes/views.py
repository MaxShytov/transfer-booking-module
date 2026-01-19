from decimal import Decimal

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny
from rest_framework.response import Response

from .models import FixedRoute, DistancePricingRule
from .serializers import (
    FixedRouteSerializer,
    DistancePricingRuleSerializer,
    RouteMatchRequestSerializer,
    RouteMatchResponseSerializer,
)


class FixedRouteViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for FixedRoute.

    GET /api/v1/routes/fixed/ - List all active fixed routes
    GET /api/v1/routes/fixed/{id}/ - Get route details
    POST /api/v1/routes/fixed/match/ - Find matching route by coordinates
    """
    queryset = FixedRoute.objects.filter(is_active=True)
    serializer_class = FixedRouteSerializer
    permission_classes = [AllowAny]

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response({
            'success': True,
            'data': serializer.data
        })

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response({
            'success': True,
            'data': serializer.data
        })

    @action(detail=False, methods=['get'])
    def locations(self, request):
        """
        Get unique pickup/dropoff locations from all fixed routes.

        GET /api/v1/routes/fixed/locations/

        Returns list of unique addresses with coordinates for autocomplete.
        """
        routes = self.get_queryset()

        # Collect unique locations
        locations_dict = {}

        for route in routes:
            # Add pickup location
            pickup_key = route.pickup_address
            if pickup_key not in locations_dict:
                locations_dict[pickup_key] = {
                    'address': route.pickup_address,
                    'lat': float(route.pickup_lat),
                    'lng': float(route.pickup_lng),
                    'type': route.pickup_type,
                    'type_display': route.get_pickup_type_display(),
                }

            # Add dropoff location
            dropoff_key = route.dropoff_address
            if dropoff_key not in locations_dict:
                locations_dict[dropoff_key] = {
                    'address': route.dropoff_address,
                    'lat': float(route.dropoff_lat),
                    'lng': float(route.dropoff_lng),
                    'type': route.dropoff_type,
                    'type_display': route.get_dropoff_type_display(),
                }

        # Sort by address
        locations = sorted(locations_dict.values(), key=lambda x: x['address'])

        return Response({
            'success': True,
            'data': locations
        })

    @action(detail=False, methods=['post'])
    def match(self, request):
        """
        Find a matching fixed route for given coordinates.

        POST /api/v1/routes/fixed/match/
        {
            "pickup_lat": 39.2513,
            "pickup_lng": 9.0543,
            "dropoff_lat": 39.1447,
            "dropoff_lng": 9.5218
        }

        Returns:
        - If fixed route matches: route details + base_price
        - If no match: distance-based pricing rule + calculated base_price
        """
        serializer = RouteMatchRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        pickup_lat = serializer.validated_data['pickup_lat']
        pickup_lng = serializer.validated_data['pickup_lng']
        dropoff_lat = serializer.validated_data['dropoff_lat']
        dropoff_lng = serializer.validated_data['dropoff_lng']

        # Calculate straight-line distance
        distance_km = Decimal(str(round(
            FixedRoute.haversine_distance(
                pickup_lat, pickup_lng,
                dropoff_lat, dropoff_lng
            ), 2
        )))

        # Try to find a matching fixed route
        matched_route = FixedRoute.find_matching_route(
            pickup_lat, pickup_lng,
            dropoff_lat, dropoff_lng
        )

        if matched_route:
            response_data = {
                'matched': True,
                'route_type': 'fixed_route',
                'route': matched_route,
                'distance_km': matched_route.distance_km or distance_km,
                'distance_rule': None,
                'base_price': matched_route.base_price
            }
        else:
            # Use distance-based pricing
            distance_rule = DistancePricingRule.get_rule_for_distance(float(distance_km))

            if distance_rule:
                base_price = distance_rule.calculate_price(float(distance_km))
            else:
                # Fallback: basic rate if no rule defined
                base_price = Decimal('40.00') + (distance_km * Decimal('1.50'))

            response_data = {
                'matched': False,
                'route_type': 'distance_based',
                'route': None,
                'distance_km': distance_km,
                'distance_rule': distance_rule,
                'base_price': base_price
            }

        response_serializer = RouteMatchResponseSerializer(response_data)
        return Response({
            'success': True,
            'data': response_serializer.data
        })


class DistancePricingRuleViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for DistancePricingRule.

    GET /api/v1/routes/distance-rules/ - List all active distance pricing rules
    GET /api/v1/routes/distance-rules/{id}/ - Get rule details
    """
    queryset = DistancePricingRule.objects.filter(is_active=True)
    serializer_class = DistancePricingRuleSerializer
    permission_classes = [AllowAny]

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response({
            'success': True,
            'data': serializer.data
        })

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response({
            'success': True,
            'data': serializer.data
        })
