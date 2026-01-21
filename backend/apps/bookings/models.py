import uuid
from decimal import Decimal

from django.db import models
from django.conf import settings
from django.core.validators import MinValueValidator

from apps.core.models import TimeStampedModel
from apps.vehicles.models import VehicleClass
from apps.routes.models import FixedRoute


def generate_booking_reference():
    """Generate unique booking reference like SAT-2026-XXXX."""
    from datetime import datetime
    import random
    year = datetime.now().year
    num = random.randint(1000, 9999)
    return f"SAT-{year}-{num:04d}"


class Booking(TimeStampedModel):
    """
    Main booking model storing all booking data and pricing calculations.
    """

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        CONFIRMED = 'confirmed', 'Confirmed'
        IN_PROGRESS = 'in_progress', 'In Progress'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'

    class PaymentStatus(models.TextChoices):
        UNPAID = 'unpaid', 'Unpaid'
        DEPOSIT_PAID = 'deposit_paid', 'Deposit Paid'
        FULLY_PAID = 'fully_paid', 'Fully Paid'
        REFUNDED = 'refunded', 'Refunded'

    class PricingType(models.TextChoices):
        FIXED_ROUTE = 'fixed_route', 'Fixed Route'
        DISTANCE_BASED = 'distance_based', 'Distance Based'

    # Booking Reference
    booking_reference = models.CharField(
        max_length=50,
        unique=True,
        default=generate_booking_reference,
        verbose_name='Booking Reference'
    )

    # Route Information
    pickup_address = models.CharField(max_length=500, verbose_name='Pickup Address')
    pickup_lat = models.DecimalField(
        max_digits=10, decimal_places=8,
        null=True, blank=True,
        verbose_name='Pickup Latitude'
    )
    pickup_lng = models.DecimalField(
        max_digits=11, decimal_places=8,
        null=True, blank=True,
        verbose_name='Pickup Longitude'
    )
    pickup_notes = models.TextField(blank=True, verbose_name='Pickup Notes')

    dropoff_address = models.CharField(max_length=500, verbose_name='Dropoff Address')
    dropoff_lat = models.DecimalField(
        max_digits=10, decimal_places=8,
        null=True, blank=True,
        verbose_name='Dropoff Latitude'
    )
    dropoff_lng = models.DecimalField(
        max_digits=11, decimal_places=8,
        null=True, blank=True,
        verbose_name='Dropoff Longitude'
    )
    dropoff_notes = models.TextField(blank=True, verbose_name='Dropoff Notes')

    service_date = models.DateField(verbose_name='Service Date')
    pickup_time = models.TimeField(verbose_name='Pickup Time')

    # Round Trip
    is_round_trip = models.BooleanField(default=False, verbose_name='Is Round Trip')
    return_date = models.DateField(null=True, blank=True, verbose_name='Return Date')
    return_time = models.TimeField(null=True, blank=True, verbose_name='Return Time')
    return_flight_number = models.CharField(
        max_length=20, blank=True,
        verbose_name='Return Flight Number'
    )

    # Passenger & Luggage
    num_passengers = models.PositiveIntegerField(verbose_name='Number of Passengers')
    num_large_luggage = models.PositiveIntegerField(default=0, verbose_name='Large Luggage')
    num_small_luggage = models.PositiveIntegerField(default=0, verbose_name='Small Luggage')
    has_children = models.BooleanField(default=False, verbose_name='Has Children')
    children_ages = models.JSONField(
        default=list, blank=True,
        verbose_name='Children Ages',
        help_text='List of children ages'
    )

    # Vehicle Selection
    selected_vehicle_class = models.ForeignKey(
        VehicleClass,
        on_delete=models.PROTECT,
        related_name='bookings_selected',
        verbose_name='Selected Vehicle Class'
    )
    actual_vehicle_class = models.ForeignKey(
        VehicleClass,
        on_delete=models.PROTECT,
        related_name='bookings_actual',
        null=True, blank=True,
        verbose_name='Actual Vehicle Class',
        help_text='May differ if upgraded'
    )
    vehicle_upgrade_reason = models.TextField(
        blank=True,
        verbose_name='Upgrade Reason'
    )

    # Flight Info
    flight_number = models.CharField(
        max_length=20, blank=True,
        verbose_name='Flight Number'
    )
    special_requests = models.TextField(blank=True, verbose_name='Special Requests')

    # Pricing
    pricing_type = models.CharField(
        max_length=20,
        choices=PricingType.choices,
        verbose_name='Pricing Type'
    )
    fixed_route = models.ForeignKey(
        FixedRoute,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='bookings',
        verbose_name='Fixed Route'
    )
    distance_km = models.DecimalField(
        max_digits=10, decimal_places=2,
        null=True, blank=True,
        verbose_name='Distance (km)'
    )
    duration_minutes = models.PositiveIntegerField(
        null=True, blank=True,
        verbose_name='Duration (minutes)'
    )

    # Pricing Breakdown
    base_price = models.DecimalField(
        max_digits=10, decimal_places=2,
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Base Price'
    )
    seasonal_multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        verbose_name='Seasonal Multiplier'
    )
    vehicle_class_multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        verbose_name='Vehicle Class Multiplier'
    )
    passenger_multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        verbose_name='Passenger Multiplier'
    )
    time_multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        verbose_name='Time Multiplier'
    )

    # Totals
    subtotal = models.DecimalField(
        max_digits=10, decimal_places=2,
        verbose_name='Subtotal'
    )
    extra_fees_json = models.JSONField(
        default=list, blank=True,
        verbose_name='Extra Fees',
        help_text='JSON array of applied fees'
    )
    extra_fees_total = models.DecimalField(
        max_digits=10, decimal_places=2,
        default=Decimal('0.00'),
        verbose_name='Extra Fees Total'
    )
    final_price = models.DecimalField(
        max_digits=10, decimal_places=2,
        verbose_name='Final Price'
    )
    currency = models.CharField(max_length=3, default='EUR', verbose_name='Currency')

    # Customer Information
    customer_name = models.CharField(max_length=255, verbose_name='Customer Name')
    customer_phone = models.CharField(max_length=30, verbose_name='Customer Phone')
    customer_email = models.EmailField(verbose_name='Customer Email')
    customer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='bookings',
        verbose_name='Customer Account'
    )

    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING,
        verbose_name='Status'
    )
    payment_status = models.CharField(
        max_length=20,
        choices=PaymentStatus.choices,
        default=PaymentStatus.UNPAID,
        verbose_name='Payment Status'
    )
    payment_method = models.CharField(
        max_length=50, blank=True,
        verbose_name='Payment Method'
    )
    payment_intent_id = models.CharField(
        max_length=255, blank=True,
        verbose_name='Payment Intent ID'
    )

    # Internal
    internal_notes = models.TextField(blank=True, verbose_name='Internal Notes')
    confirmed_at = models.DateTimeField(null=True, blank=True, verbose_name='Confirmed At')
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name='Completed At')

    class Meta:
        verbose_name = 'Booking'
        verbose_name_plural = 'Bookings'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.booking_reference} - {self.customer_name}"

    def save(self, *args, **kwargs):
        # Ensure unique booking reference
        if not self.booking_reference:
            self.booking_reference = generate_booking_reference()
            while Booking.objects.filter(booking_reference=self.booking_reference).exists():
                self.booking_reference = generate_booking_reference()
        super().save(*args, **kwargs)

    def calculate_subtotal(self):
        """Calculate subtotal with all multipliers."""
        return (
            self.base_price *
            self.seasonal_multiplier *
            self.vehicle_class_multiplier *
            self.passenger_multiplier *
            self.time_multiplier
        )

    def calculate_final_price(self):
        """Calculate final price including extra fees."""
        return self.subtotal + self.extra_fees_total
