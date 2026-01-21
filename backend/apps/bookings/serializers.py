from decimal import Decimal
from rest_framework import serializers

from .models import Booking
from apps.vehicles.models import VehicleClass


class ExtraFeeItemSerializer(serializers.Serializer):
    """Serializer for extra fee item in booking request."""

    fee_code = serializers.CharField()
    fee_name = serializers.CharField()
    fee_type = serializers.CharField()
    quantity = serializers.IntegerField(min_value=1, default=1)
    unit_amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2)


class CreateBookingRequestSerializer(serializers.Serializer):
    """Serializer for booking creation request."""

    # Route info
    pickup_address = serializers.CharField(max_length=500)
    pickup_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    pickup_lng = serializers.DecimalField(max_digits=11, decimal_places=8)
    dropoff_address = serializers.CharField(max_length=500)
    dropoff_lat = serializers.DecimalField(max_digits=10, decimal_places=8)
    dropoff_lng = serializers.DecimalField(max_digits=11, decimal_places=8)

    # Datetime
    service_date = serializers.DateField()
    pickup_time = serializers.TimeField()

    # Round trip
    is_round_trip = serializers.BooleanField(default=False)
    return_date = serializers.DateField(required=False, allow_null=True)
    return_time = serializers.TimeField(required=False, allow_null=True)

    # Passengers & luggage
    num_passengers = serializers.IntegerField(min_value=1)
    num_children = serializers.IntegerField(min_value=0, default=0)
    num_large_luggage = serializers.IntegerField(min_value=0, default=0)
    num_small_luggage = serializers.IntegerField(min_value=0, default=0)

    # Vehicle
    vehicle_class_id = serializers.IntegerField()

    # Pricing (from price calculation)
    pricing_type = serializers.CharField()
    route_name = serializers.CharField(required=False, allow_null=True, allow_blank=True)
    distance_km = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, allow_null=True)
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2)
    vehicle_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    passenger_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    seasonal_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    time_multiplier = serializers.DecimalField(max_digits=5, decimal_places=2)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2)
    extra_fees = ExtraFeeItemSerializer(many=True, required=False, default=list)
    extra_fees_total = serializers.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))
    final_price = serializers.DecimalField(max_digits=10, decimal_places=2)

    # Customer info
    customer_first_name = serializers.CharField(max_length=100)
    customer_last_name = serializers.CharField(max_length=100)
    customer_phone = serializers.CharField(max_length=30)
    customer_email = serializers.EmailField()

    # Optional trip details
    flight_number = serializers.CharField(max_length=20, required=False, allow_blank=True, default='')
    return_flight_number = serializers.CharField(max_length=20, required=False, allow_blank=True, default='')
    special_requests = serializers.CharField(required=False, allow_blank=True, default='')

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

        # Validate vehicle class exists
        try:
            VehicleClass.objects.get(id=attrs['vehicle_class_id'], is_active=True)
        except VehicleClass.DoesNotExist:
            raise serializers.ValidationError({
                'vehicle_class_id': 'Invalid vehicle class.'
            })

        return attrs


class BookingListSerializer(serializers.ModelSerializer):
    """Serializer for booking list (compact view)."""

    vehicle_class_name = serializers.CharField(
        source='selected_vehicle_class.class_name',
        read_only=True
    )

    class Meta:
        model = Booking
        fields = [
            'id',
            'booking_reference',
            'pickup_address',
            'dropoff_address',
            'service_date',
            'pickup_time',
            'is_round_trip',
            'return_date',
            'return_time',
            'vehicle_class_name',
            'final_price',
            'currency',
            'status',
            'payment_status',
            'created_at',
        ]
        read_only_fields = fields


class BookingResponseSerializer(serializers.ModelSerializer):
    """Serializer for booking response (create response)."""

    vehicle_class_name = serializers.CharField(
        source='selected_vehicle_class.class_name',
        read_only=True
    )

    class Meta:
        model = Booking
        fields = [
            'id',
            'booking_reference',
            'pickup_address',
            'dropoff_address',
            'service_date',
            'pickup_time',
            'num_passengers',
            'num_large_luggage',
            'num_small_luggage',
            'vehicle_class_name',
            'flight_number',
            'special_requests',
            'final_price',
            'currency',
            'status',
            'payment_status',
            'customer_name',
            'customer_email',
            'customer_phone',
            'created_at',
        ]
        read_only_fields = fields


class BookingDetailSerializer(serializers.ModelSerializer):
    """Serializer for booking detail view (full data)."""

    vehicle_class_name = serializers.CharField(
        source='selected_vehicle_class.class_name',
        read_only=True
    )
    vehicle_class_image = serializers.ImageField(
        source='selected_vehicle_class.image',
        read_only=True
    )

    class Meta:
        model = Booking
        fields = [
            'id',
            'booking_reference',
            # Route
            'pickup_address',
            'pickup_lat',
            'pickup_lng',
            'dropoff_address',
            'dropoff_lat',
            'dropoff_lng',
            'service_date',
            'pickup_time',
            # Round trip
            'is_round_trip',
            'return_date',
            'return_time',
            'return_flight_number',
            # Passengers
            'num_passengers',
            'num_large_luggage',
            'num_small_luggage',
            'has_children',
            # Vehicle
            'vehicle_class_name',
            'vehicle_class_image',
            # Flight & requests
            'flight_number',
            'special_requests',
            # Pricing
            'pricing_type',
            'distance_km',
            'base_price',
            'vehicle_class_multiplier',
            'passenger_multiplier',
            'seasonal_multiplier',
            'time_multiplier',
            'subtotal',
            'extra_fees_json',
            'extra_fees_total',
            'final_price',
            'currency',
            # Customer
            'customer_name',
            'customer_email',
            'customer_phone',
            # Status
            'status',
            'payment_status',
            # Timestamps
            'created_at',
            'confirmed_at',
            'completed_at',
        ]
        read_only_fields = fields
