from rest_framework import serializers

from .models import FixedRoute, DistancePricingRule


class FixedRouteSerializer(serializers.ModelSerializer):
    """Serializer for FixedRoute model."""

    pickup_type_display = serializers.CharField(
        source='get_pickup_type_display',
        read_only=True
    )
    dropoff_type_display = serializers.CharField(
        source='get_dropoff_type_display',
        read_only=True
    )

    class Meta:
        model = FixedRoute
        fields = [
            'id',
            'route_name',
            'pickup_address',
            'pickup_lat',
            'pickup_lng',
            'pickup_type',
            'pickup_type_display',
            'pickup_radius_km',
            'dropoff_address',
            'dropoff_lat',
            'dropoff_lng',
            'dropoff_type',
            'dropoff_type_display',
            'dropoff_radius_km',
            'base_price',
            'currency',
            'distance_km',
        ]


class DistancePricingRuleSerializer(serializers.ModelSerializer):
    """Serializer for DistancePricingRule model."""

    class Meta:
        model = DistancePricingRule
        fields = [
            'id',
            'rule_name',
            'base_rate',
            'price_per_km',
            'price_per_minute',
            'min_distance_km',
            'max_distance_km',
            'priority',
        ]


class RouteMatchRequestSerializer(serializers.Serializer):
    """Serializer for route matching request."""

    pickup_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    pickup_lng = serializers.DecimalField(max_digits=11, decimal_places=8)
    dropoff_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    dropoff_lng = serializers.DecimalField(max_digits=11, decimal_places=8)


class RouteMatchResponseSerializer(serializers.Serializer):
    """Serializer for route matching response."""

    matched = serializers.BooleanField()
    route_type = serializers.CharField()
    route = FixedRouteSerializer(allow_null=True)
    distance_km = serializers.DecimalField(max_digits=10, decimal_places=2)
    distance_rule = DistancePricingRuleSerializer(allow_null=True)
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2)
