from decimal import Decimal

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import SeasonalMultiplier, PassengerMultiplier, TimeMultiplier, ExtraFee, RoundTripDiscount
from .serializers import (
    SeasonalMultiplierSerializer,
    PassengerMultiplierSerializer,
    TimeMultiplierSerializer,
    ExtraFeeSerializer,
    PriceCalculateRequestSerializer,
    PriceCalculateResponseSerializer,
)
from apps.vehicles.models import VehicleClass, VehicleClassRequirement
from apps.routes.models import FixedRoute, DistancePricingRule


class SeasonalMultiplierViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for SeasonalMultiplier.

    GET /api/v1/pricing/seasonal-multipliers/ - List all active seasonal multipliers
    GET /api/v1/pricing/seasonal-multipliers/{id}/ - Get multiplier details
    """
    queryset = SeasonalMultiplier.objects.filter(is_active=True)
    serializer_class = SeasonalMultiplierSerializer
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


class TimeMultiplierViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for TimeMultiplier.

    GET /api/v1/pricing/time-multipliers/ - List all active time multipliers
    GET /api/v1/pricing/time-multipliers/{id}/ - Get multiplier details
    """
    queryset = TimeMultiplier.objects.filter(is_active=True)
    serializer_class = TimeMultiplierSerializer
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


class ExtraFeeViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for ExtraFee.

    GET /api/v1/pricing/extra-fees/ - List all active extra fees
    GET /api/v1/pricing/extra-fees/{id}/ - Get fee details
    """
    queryset = ExtraFee.objects.filter(is_active=True)
    serializer_class = ExtraFeeSerializer
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


class PriceCalculateView(APIView):
    """
    Calculate price for a transfer booking.

    POST /api/v1/pricing/calculate/
    """
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = PriceCalculateRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # 1. Determine route and base price
        pickup_lat = data['pickup_lat']
        pickup_lng = data['pickup_lng']
        dropoff_lat = data['dropoff_lat']
        dropoff_lng = data['dropoff_lng']

        # Calculate straight-line distance
        distance_km = Decimal(str(round(
            FixedRoute.haversine_distance(
                pickup_lat, pickup_lng,
                dropoff_lat, dropoff_lng
            ), 2
        )))

        # Try to match a fixed route
        matched_route = FixedRoute.find_matching_route(
            pickup_lat, pickup_lng,
            dropoff_lat, dropoff_lng
        )

        if matched_route:
            route_type = 'fixed_route'
            route_name = matched_route.route_name
            base_price = matched_route.base_price
            distance_km = matched_route.distance_km or distance_km
        else:
            route_type = 'distance_based'
            route_name = None
            distance_rule = DistancePricingRule.get_rule_for_distance(float(distance_km))
            if distance_rule:
                base_price = distance_rule.calculate_price(float(distance_km))
            else:
                base_price = Decimal('40.00') + (distance_km * Decimal('1.50'))

        # 2. Determine vehicle class
        num_passengers = data['num_passengers']
        num_children = data.get('num_children', 0)
        num_large_luggage = data.get('num_large_luggage', 0)
        vehicle_class_id = data.get('vehicle_class_id')

        # Total passengers includes children for capacity check
        total_passengers = num_passengers + num_children

        # Get minimum required tier (based on total passengers)
        min_tier = VehicleClassRequirement.get_minimum_tier(total_passengers, num_large_luggage)

        if vehicle_class_id:
            vehicle_class = VehicleClass.objects.filter(
                id=vehicle_class_id,
                is_active=True
            ).first()
            # Validate tier is sufficient
            if vehicle_class and vehicle_class.tier_level < min_tier:
                return Response({
                    'success': False,
                    'message': f'Selected vehicle tier ({vehicle_class.tier_level}) is below minimum required ({min_tier})'
                }, status=status.HTTP_400_BAD_REQUEST)
        else:
            # Auto-select minimum tier vehicle
            vehicle_class = VehicleClass.objects.filter(
                is_active=True,
                tier_level__gte=min_tier,
                max_passengers__gte=total_passengers,
                max_large_luggage__gte=num_large_luggage
            ).order_by('tier_level', 'display_order').first()

        if not vehicle_class:
            return Response({
                'success': False,
                'message': 'No suitable vehicle class found for the given requirements'
            }, status=status.HTTP_400_BAD_REQUEST)

        vehicle_multiplier = vehicle_class.price_multiplier
        vehicle_multiplier_label = vehicle_class.class_name

        # 3. Get seasonal multiplier
        service_date = data['service_date']
        seasonal = SeasonalMultiplier.get_multiplier_for_date(service_date)
        seasonal_multiplier = seasonal.multiplier if seasonal else Decimal('1.00')
        seasonal_multiplier_label = seasonal.season_name if seasonal else 'Standard'

        # 4. Get passenger multiplier (based on adults only)
        passenger_mult = PassengerMultiplier.get_multiplier_for_vehicle_and_passengers(
            vehicle_class, num_passengers
        )
        passenger_multiplier = passenger_mult.multiplier if passenger_mult else Decimal('1.00')
        # Build passenger label
        if num_children > 0:
            passenger_multiplier_label = f'{num_passengers} adults, {num_children} children'
        else:
            passenger_multiplier_label = f'{num_passengers} passengers'
        if passenger_mult and passenger_mult.description:
            passenger_multiplier_label = passenger_mult.description

        # 5. Get time multiplier
        pickup_time = data['pickup_time']
        time_mult = TimeMultiplier.get_multiplier_for_time(pickup_time, service_date)
        time_multiplier = time_mult.multiplier if time_mult else Decimal('1.00')
        time_multiplier_label = time_mult.time_name if time_mult else 'Standard Hours'

        # 6. Calculate one-way subtotal
        one_way_subtotal = base_price * vehicle_multiplier * seasonal_multiplier * passenger_multiplier * time_multiplier
        one_way_subtotal = one_way_subtotal.quantize(Decimal('0.01'))

        # 7. Handle round trip
        is_round_trip = data.get('is_round_trip', False)
        return_date = data.get('return_date')
        return_time = data.get('return_time')
        round_trip_multiplier = None
        round_trip_discount_label = None

        if is_round_trip:
            # Get round trip discount
            round_trip_discount = RoundTripDiscount.get_active_discount()
            if round_trip_discount:
                round_trip_multiplier = round_trip_discount.multiplier
                discount_pct = int((1 - round_trip_discount.multiplier) * 100)
                round_trip_discount_label = f'{discount_pct}% Round Trip Discount'
            else:
                round_trip_multiplier = Decimal('1.00')
                round_trip_discount_label = 'Round Trip (no discount)'

            # For round trip: subtotal = 2 × one_way × discount
            subtotal = (one_way_subtotal * 2 * round_trip_multiplier).quantize(Decimal('0.01'))
        else:
            subtotal = one_way_subtotal

        # 8. Calculate extra fees
        extra_fees_data = data.get('extra_fees', [])
        applied_fees = []
        extra_fees_total = Decimal('0.00')

        for fee_item in extra_fees_data:
            fee = ExtraFee.objects.filter(
                fee_code=fee_item['fee_code'],
                is_active=True
            ).first()
            if fee:
                quantity = fee_item.get('quantity', 1)
                total_amount = fee.calculate_fee(quantity=quantity, base_price=subtotal)
                applied_fees.append({
                    'fee_code': fee.fee_code,
                    'fee_name': fee.fee_name,
                    'fee_type': fee.fee_type,
                    'quantity': quantity,
                    'unit_amount': fee.amount,
                    'total_amount': total_amount,
                })
                extra_fees_total += total_amount

        # 9. Calculate final price
        final_price = subtotal + extra_fees_total

        # 10. Determine breakdown visibility (staff/admin can see details)
        show_breakdown = False
        if request.user.is_authenticated:
            show_breakdown = request.user.is_staff or request.user.role in ['admin', 'manager']

        # Prepare response
        response_data = {
            'route_type': route_type,
            'route_name': route_name,
            'distance_km': distance_km,
            'base_price': base_price,
            'vehicle_class': vehicle_class,
            'vehicle_multiplier': vehicle_multiplier,
            'vehicle_multiplier_label': vehicle_multiplier_label,
            'seasonal_multiplier': seasonal_multiplier,
            'seasonal_multiplier_label': seasonal_multiplier_label,
            'passenger_multiplier': passenger_multiplier,
            'passenger_multiplier_label': passenger_multiplier_label,
            'time_multiplier': time_multiplier,
            'time_multiplier_label': time_multiplier_label,
            'subtotal': subtotal,
            'is_round_trip': is_round_trip,
            'round_trip_multiplier': round_trip_multiplier,
            'round_trip_discount_label': round_trip_discount_label,
            'return_date': return_date,
            'return_time': return_time,
            'extra_fees': applied_fees,
            'extra_fees_total': extra_fees_total,
            'final_price': final_price,
            'currency': 'EUR',
            'show_breakdown': show_breakdown,
        }

        response_serializer = PriceCalculateResponseSerializer(response_data)
        return Response({
            'success': True,
            'data': response_serializer.data
        })
