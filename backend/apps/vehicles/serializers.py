from rest_framework import serializers

from .models import VehicleClass, VehicleClassRequirement


class VehicleClassSerializer(serializers.ModelSerializer):
    """Serializer for VehicleClass model."""

    class Meta:
        model = VehicleClass
        fields = [
            'id',
            'class_name',
            'class_code',
            'tier_level',
            'price_multiplier',
            'max_passengers',
            'max_large_luggage',
            'max_small_luggage',
            'description',
            'example_vehicles',
            'icon_url',
            'display_order',
        ]


class VehicleClassRequirementSerializer(serializers.ModelSerializer):
    """Serializer for VehicleClassRequirement model."""

    required_for_display = serializers.CharField(
        source='get_required_for_display',
        read_only=True
    )

    class Meta:
        model = VehicleClassRequirement
        fields = [
            'id',
            'min_value',
            'max_value',
            'min_vehicle_tier',
            'required_for',
            'required_for_display',
            'is_strict',
            'validation_message',
        ]


class MinimumTierRequestSerializer(serializers.Serializer):
    """Serializer for checking minimum tier requirement."""

    num_passengers = serializers.IntegerField(min_value=1, required=True)
    num_large_luggage = serializers.IntegerField(min_value=0, default=0)


class MinimumTierResponseSerializer(serializers.Serializer):
    """Serializer for minimum tier response."""

    min_tier = serializers.IntegerField()
    passenger_tier = serializers.IntegerField()
    luggage_tier = serializers.IntegerField()
    available_classes = VehicleClassSerializer(many=True)
