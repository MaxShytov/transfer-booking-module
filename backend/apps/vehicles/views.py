from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response

from .models import VehicleClass, VehicleClassRequirement
from .serializers import (
    VehicleClassSerializer,
    VehicleClassRequirementSerializer,
    MinimumTierRequestSerializer,
    MinimumTierResponseSerializer,
)


class VehicleClassViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for VehicleClass.

    GET /api/v1/vehicles/classes/ - List all active vehicle classes
    GET /api/v1/vehicles/classes/{id}/ - Get vehicle class details
    POST /api/v1/vehicles/classes/available/ - Get available classes for passengers/luggage
    """
    queryset = VehicleClass.objects.filter(is_active=True)
    serializer_class = VehicleClassSerializer
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

    @action(detail=False, methods=['post'])
    def available(self, request):
        """
        Get available vehicle classes for given passengers and luggage.

        POST /api/v1/vehicles/classes/available/
        {
            "num_passengers": 5,
            "num_large_luggage": 3
        }
        """
        serializer = MinimumTierRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        num_passengers = serializer.validated_data['num_passengers']
        num_large_luggage = serializer.validated_data.get('num_large_luggage', 0)

        # Get minimum tier requirements
        passenger_tier = VehicleClassRequirement.get_minimum_tier_for_passengers(num_passengers)
        luggage_tier = VehicleClassRequirement.get_minimum_tier_for_luggage(num_large_luggage)
        min_tier = max(passenger_tier, luggage_tier)

        # Get available vehicle classes (tier >= min_tier AND capacity >= passengers)
        available_classes = VehicleClass.objects.filter(
            is_active=True,
            tier_level__gte=min_tier,
            max_passengers__gte=num_passengers,
            max_large_luggage__gte=num_large_luggage
        ).order_by('tier_level', 'display_order')

        response_serializer = MinimumTierResponseSerializer({
            'min_tier': min_tier,
            'passenger_tier': passenger_tier,
            'luggage_tier': luggage_tier,
            'available_classes': available_classes
        })

        return Response({
            'success': True,
            'data': response_serializer.data
        })


class VehicleClassRequirementViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for VehicleClassRequirement.

    GET /api/v1/vehicles/requirements/ - List all requirements
    GET /api/v1/vehicles/requirements/{id}/ - Get requirement details
    """
    queryset = VehicleClassRequirement.objects.all()
    serializer_class = VehicleClassRequirementSerializer
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
