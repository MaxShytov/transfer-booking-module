from django.contrib.auth import get_user_model
from rest_framework import serializers

from apps.bookings.models import Booking
from apps.accounts.models import DriverProfile
from apps.vehicles.models import VehicleClass

User = get_user_model()


class DriverInfoSerializer(serializers.ModelSerializer):
    """Serializer for driver information (nested in booking)."""

    full_name = serializers.ReadOnlyField()
    vehicle_plate = serializers.CharField(source='driver_profile.vehicle_plate', read_only=True)
    vehicle_model = serializers.CharField(source='driver_profile.vehicle_model', read_only=True)
    vehicle_color = serializers.CharField(source='driver_profile.vehicle_color', read_only=True)
    is_available = serializers.BooleanField(source='driver_profile.is_available', read_only=True)

    class Meta:
        model = User
        fields = [
            'id',
            'email',
            'first_name',
            'last_name',
            'full_name',
            'phone',
            'vehicle_plate',
            'vehicle_model',
            'vehicle_color',
            'is_available',
        ]


class DriverListSerializer(serializers.ModelSerializer):
    """Serializer for driver list with profile info."""

    full_name = serializers.ReadOnlyField()
    vehicle_plate = serializers.SerializerMethodField()
    vehicle_model = serializers.SerializerMethodField()
    vehicle_color = serializers.SerializerMethodField()
    vehicle_class_name = serializers.SerializerMethodField()
    is_available = serializers.SerializerMethodField()
    active_bookings_count = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id',
            'email',
            'first_name',
            'last_name',
            'full_name',
            'phone',
            'vehicle_plate',
            'vehicle_model',
            'vehicle_color',
            'vehicle_class_name',
            'is_available',
            'active_bookings_count',
        ]

    def get_vehicle_plate(self, obj):
        profile = getattr(obj, 'driver_profile', None)
        return profile.vehicle_plate if profile else None

    def get_vehicle_model(self, obj):
        profile = getattr(obj, 'driver_profile', None)
        return profile.vehicle_model if profile else None

    def get_vehicle_color(self, obj):
        profile = getattr(obj, 'driver_profile', None)
        return profile.vehicle_color if profile else None

    def get_vehicle_class_name(self, obj):
        profile = getattr(obj, 'driver_profile', None)
        if profile and profile.vehicle_class:
            return profile.vehicle_class.class_name
        return None

    def get_is_available(self, obj):
        profile = getattr(obj, 'driver_profile', None)
        return profile.is_available if profile else False

    def get_active_bookings_count(self, obj):
        return obj.assigned_bookings.filter(
            status__in=['pending', 'confirmed', 'in_progress']
        ).count()


class DispatcherBookingListSerializer(serializers.ModelSerializer):
    """Serializer for booking list in dispatcher dashboard."""

    vehicle_class_name = serializers.CharField(
        source='selected_vehicle_class.class_name',
        read_only=True
    )
    assigned_driver_name = serializers.CharField(
        source='assigned_driver.full_name',
        read_only=True
    )
    assigned_driver_phone = serializers.CharField(
        source='assigned_driver.phone',
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
            'num_passengers',
            'num_large_luggage',
            'num_small_luggage',
            'vehicle_class_name',
            'final_price',
            'currency',
            'status',
            'payment_status',
            'customer_name',
            'customer_phone',
            'customer_email',
            'assigned_driver',
            'assigned_driver_name',
            'assigned_driver_phone',
            'dispatcher_notes',
            'created_at',
        ]
        read_only_fields = fields


class DispatcherBookingDetailSerializer(serializers.ModelSerializer):
    """Serializer for booking detail view in dispatcher dashboard."""

    vehicle_class_name = serializers.CharField(
        source='selected_vehicle_class.class_name',
        read_only=True
    )
    vehicle_class_image = serializers.ImageField(
        source='selected_vehicle_class.image',
        read_only=True
    )
    assigned_driver_info = DriverInfoSerializer(
        source='assigned_driver',
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
            'pickup_notes',
            'dropoff_address',
            'dropoff_lat',
            'dropoff_lng',
            'dropoff_notes',
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
            'children_ages',
            # Vehicle
            'vehicle_class_name',
            'vehicle_class_image',
            # Flight & requests
            'flight_number',
            'special_requests',
            # Pricing
            'pricing_type',
            'distance_km',
            'duration_minutes',
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
            'payment_method',
            # Driver assignment
            'assigned_driver',
            'assigned_driver_info',
            # Internal
            'internal_notes',
            'dispatcher_notes',
            'cancellation_reason',
            # Timestamps
            'created_at',
            'updated_at',
            'confirmed_at',
            'completed_at',
            'cancelled_at',
        ]
        read_only_fields = fields


class BookingStatusUpdateSerializer(serializers.Serializer):
    """Serializer for updating booking status."""

    status = serializers.ChoiceField(choices=Booking.Status.choices)
    cancellation_reason = serializers.CharField(required=False, allow_blank=True)

    def validate(self, attrs):
        if attrs.get('status') == 'cancelled' and not attrs.get('cancellation_reason'):
            raise serializers.ValidationError({
                'cancellation_reason': 'Cancellation reason is required when cancelling a booking.'
            })
        return attrs


class BookingDriverAssignSerializer(serializers.Serializer):
    """Serializer for assigning driver to booking."""

    driver_id = serializers.IntegerField(required=False, allow_null=True)

    def validate_driver_id(self, value):
        if value is not None:
            try:
                driver = User.objects.get(id=value, role='driver', is_active=True)
            except User.DoesNotExist:
                raise serializers.ValidationError('Driver not found or inactive.')
        return value


class BookingPaymentStatusUpdateSerializer(serializers.Serializer):
    """Serializer for updating payment status."""

    payment_status = serializers.ChoiceField(choices=Booking.PaymentStatus.choices)


class BookingNotesUpdateSerializer(serializers.Serializer):
    """Serializer for updating dispatcher notes."""

    dispatcher_notes = serializers.CharField(required=False, allow_blank=True)
    internal_notes = serializers.CharField(required=False, allow_blank=True)


class DispatcherBookingUpdateSerializer(serializers.ModelSerializer):
    """Serializer for updating booking by dispatcher."""

    class Meta:
        model = Booking
        fields = [
            # Route
            'pickup_address',
            'pickup_lat',
            'pickup_lng',
            'pickup_notes',
            'dropoff_address',
            'dropoff_lat',
            'dropoff_lng',
            'dropoff_notes',
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
            'children_ages',
            # Vehicle
            'selected_vehicle_class',
            # Flight & requests
            'flight_number',
            'special_requests',
            # Customer
            'customer_name',
            'customer_email',
            'customer_phone',
            # Status
            'status',
            'payment_status',
            'payment_method',
            # Driver assignment
            'assigned_driver',
            # Internal
            'internal_notes',
            'dispatcher_notes',
            'cancellation_reason',
        ]


class DispatcherBookingCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating booking by dispatcher (manual booking)."""

    vehicle_class_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = Booking
        fields = [
            # Route
            'pickup_address',
            'pickup_lat',
            'pickup_lng',
            'pickup_notes',
            'dropoff_address',
            'dropoff_lat',
            'dropoff_lng',
            'dropoff_notes',
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
            'children_ages',
            # Vehicle
            'vehicle_class_id',
            # Flight & requests
            'flight_number',
            'special_requests',
            # Pricing
            'pricing_type',
            'base_price',
            'final_price',
            # Customer
            'customer_name',
            'customer_email',
            'customer_phone',
            # Status
            'status',
            'payment_status',
            'payment_method',
            # Driver assignment
            'assigned_driver',
            # Internal
            'internal_notes',
            'dispatcher_notes',
        ]

    def validate_vehicle_class_id(self, value):
        try:
            VehicleClass.objects.get(id=value, is_active=True)
        except VehicleClass.DoesNotExist:
            raise serializers.ValidationError('Invalid vehicle class.')
        return value

    def create(self, validated_data):
        vehicle_class_id = validated_data.pop('vehicle_class_id')
        vehicle_class = VehicleClass.objects.get(id=vehicle_class_id)

        # Set defaults for pricing fields if not provided
        validated_data['selected_vehicle_class'] = vehicle_class
        validated_data['vehicle_class_multiplier'] = vehicle_class.price_multiplier
        validated_data.setdefault('seasonal_multiplier', 1)
        validated_data.setdefault('passenger_multiplier', 1)
        validated_data.setdefault('time_multiplier', 1)
        validated_data.setdefault('pricing_type', 'distance_based')

        # Calculate subtotal
        base_price = validated_data.get('base_price', validated_data.get('final_price', 0))
        validated_data['subtotal'] = base_price * validated_data['vehicle_class_multiplier']

        if 'final_price' not in validated_data:
            validated_data['final_price'] = validated_data['subtotal']

        return super().create(validated_data)


class DispatcherStatsSerializer(serializers.Serializer):
    """Serializer for dispatcher dashboard statistics."""

    today_transfers = serializers.IntegerField()
    today_revenue = serializers.DecimalField(max_digits=10, decimal_places=2)
    pending_count = serializers.IntegerField()
    confirmed_count = serializers.IntegerField()
    in_progress_count = serializers.IntegerField()
    completed_count = serializers.IntegerField()
    cancelled_count = serializers.IntegerField()
    unassigned_count = serializers.IntegerField()
    unpaid_count = serializers.IntegerField()
    drivers_available = serializers.IntegerField()
    drivers_total = serializers.IntegerField()
