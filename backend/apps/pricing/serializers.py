from decimal import Decimal
from rest_framework import serializers

from .models import SeasonalMultiplier, PassengerMultiplier, TimeMultiplier, ExtraFee, RoundTripDiscount
from apps.vehicles.serializers import VehicleClassSerializer


class RoundTripDiscountSerializer(serializers.ModelSerializer):
    """Serializer for RoundTripDiscount model."""

    discount_percent = serializers.SerializerMethodField()

    class Meta:
        model = RoundTripDiscount
        fields = [
            'id',
            'name',
            'multiplier',
            'discount_percent',
            'description',
        ]

    def get_discount_percent(self, obj):
        return int((1 - obj.multiplier) * 100)


class SeasonalMultiplierSerializer(serializers.ModelSerializer):
    """Serializer for SeasonalMultiplier model."""

    class Meta:
        model = SeasonalMultiplier
        fields = [
            'id',
            'season_name',
            'start_date',
            'end_date',
            'multiplier',
            'year_recurring',
            'priority',
            'description',
        ]


class PassengerMultiplierSerializer(serializers.ModelSerializer):
    """Serializer for PassengerMultiplier model."""

    vehicle_class_name = serializers.CharField(
        source='vehicle_class.class_name',
        read_only=True
    )

    class Meta:
        model = PassengerMultiplier
        fields = [
            'id',
            'vehicle_class',
            'vehicle_class_name',
            'min_passengers',
            'max_passengers',
            'multiplier',
            'description',
        ]


class TimeMultiplierSerializer(serializers.ModelSerializer):
    """Serializer for TimeMultiplier model."""

    class Meta:
        model = TimeMultiplier
        fields = [
            'id',
            'time_name',
            'start_time',
            'end_time',
            'multiplier',
            'applies_to_weekdays',
            'applies_to_weekends',
            'description',
        ]


class ExtraFeeSerializer(serializers.ModelSerializer):
    """Serializer for ExtraFee model."""

    fee_type_display = serializers.CharField(
        source='get_fee_type_display',
        read_only=True
    )

    class Meta:
        model = ExtraFee
        fields = [
            'id',
            'fee_name',
            'fee_code',
            'fee_type',
            'fee_type_display',
            'amount',
            'is_optional',
            'display_order',
            'description',
        ]


class ExtraFeeItemSerializer(serializers.Serializer):
    """Serializer for extra fee item in calculate request."""

    fee_code = serializers.CharField()
    quantity = serializers.IntegerField(min_value=1, default=1)


class PriceCalculateRequestSerializer(serializers.Serializer):
    """Serializer for price calculation request."""

    # Route info
    pickup_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    pickup_lng = serializers.DecimalField(max_digits=11, decimal_places=8)
    dropoff_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    dropoff_lng = serializers.DecimalField(max_digits=11, decimal_places=8)

    # Datetime
    service_date = serializers.DateField()
    pickup_time = serializers.TimeField()

    # Round trip option
    is_round_trip = serializers.BooleanField(default=False)
    return_date = serializers.DateField(required=False, allow_null=True)
    return_time = serializers.TimeField(required=False, allow_null=True)

    # Passengers
    num_passengers = serializers.IntegerField(min_value=1)
    num_children = serializers.IntegerField(min_value=0, default=0)
    num_large_luggage = serializers.IntegerField(min_value=0, default=0)
    num_small_luggage = serializers.IntegerField(min_value=0, default=0)

    # Vehicle selection
    vehicle_class_id = serializers.IntegerField(required=False, allow_null=True)

    # Extra fees
    extra_fees = ExtraFeeItemSerializer(many=True, required=False, default=list)

    def validate(self, attrs):
        if attrs.get('is_round_trip'):
            if not attrs.get('return_date'):
                raise serializers.ValidationError({
                    'return_date': 'Return date is required for round trip.'
                })
            if not attrs.get('return_time'):
                raise serializers.ValidationError({
                    'return_time': 'Return time is required for round trip.'
                })
        return attrs


class AppliedExtraFeeSerializer(serializers.Serializer):
    """Serializer for applied extra fee in response."""

    fee_code = serializers.CharField()
    fee_name = serializers.CharField()
    fee_type = serializers.CharField()
    quantity = serializers.IntegerField()
    unit_amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2)


class PriceCalculateResponseSerializer(serializers.Serializer):
    """Serializer for price calculation response."""

    # Route info
    route_type = serializers.CharField()
    route_name = serializers.CharField(allow_null=True)
    distance_km = serializers.DecimalField(max_digits=10, decimal_places=2)

    # Base price
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2)

    # Multipliers
    vehicle_class = VehicleClassSerializer(allow_null=True)
    vehicle_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    vehicle_multiplier_label = serializers.CharField()

    seasonal_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    seasonal_multiplier_label = serializers.CharField()

    passenger_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    passenger_multiplier_label = serializers.CharField()

    time_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    time_multiplier_label = serializers.CharField()

    # Subtotal (base × all multipliers)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2)

    # Round trip
    is_round_trip = serializers.BooleanField()
    round_trip_multiplier = serializers.DecimalField(
        max_digits=5, decimal_places=2, allow_null=True
    )
    round_trip_discount_label = serializers.CharField(allow_null=True)
    return_date = serializers.DateField(allow_null=True)
    return_time = serializers.TimeField(allow_null=True)

    # Extra fees
    extra_fees = AppliedExtraFeeSerializer(many=True)
    extra_fees_total = serializers.DecimalField(max_digits=10, decimal_places=2)

    # Final
    final_price = serializers.DecimalField(max_digits=10, decimal_places=2)
    currency = serializers.CharField()

    # Breakdown visibility (for role-based display)
    show_breakdown = serializers.BooleanField()
