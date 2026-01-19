from decimal import Decimal
from datetime import date, time

from django.db import models
from django.core.validators import MinValueValidator

from apps.core.models import TimeStampedModel


class SeasonalMultiplier(TimeStampedModel):
    """
    Seasonal pricing adjustments.

    Examples:
    - High Summer (June 15 - Sept 15): 1.30 (peak tourist season)
    - Shoulder Season (Apr 1 - June 14): 1.15
    - Low Season (Nov 1 - March 31): 1.00 (base pricing)
    - Ferragosto (Aug 10-20): 1.40 (Italian holiday peak)
    """

    season_name = models.CharField(max_length=100, verbose_name='Season Name')
    start_date = models.DateField(verbose_name='Start Date')
    end_date = models.DateField(verbose_name='End Date')
    multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Multiplier',
        help_text='1.00 = base price, 1.30 = +30%'
    )
    is_active = models.BooleanField(default=True, verbose_name='Active')
    year_recurring = models.BooleanField(
        default=True,
        verbose_name='Year Recurring',
        help_text='If true, repeats every year (ignores year in dates)'
    )
    priority = models.PositiveIntegerField(
        default=0,
        verbose_name='Priority',
        help_text='Lower = higher priority (for overlapping seasons)'
    )
    description = models.TextField(blank=True, verbose_name='Description')

    class Meta:
        verbose_name = 'Seasonal Multiplier'
        verbose_name_plural = 'Seasonal Multipliers'
        ordering = ['priority', 'start_date']

    def __str__(self):
        return f"{self.season_name}: ×{self.multiplier}"

    def is_date_in_season(self, check_date):
        """Check if a date falls within this season."""
        if self.year_recurring:
            # Compare only month and day
            check_md = (check_date.month, check_date.day)
            start_md = (self.start_date.month, self.start_date.day)
            end_md = (self.end_date.month, self.end_date.day)

            if start_md <= end_md:
                return start_md <= check_md <= end_md
            else:
                # Season crosses year boundary (e.g., Dec 20 - Jan 5)
                return check_md >= start_md or check_md <= end_md
        else:
            return self.start_date <= check_date <= self.end_date

    @classmethod
    def get_multiplier_for_date(cls, check_date):
        """Get the applicable seasonal multiplier for a date."""
        for season in cls.objects.filter(is_active=True).order_by('priority'):
            if season.is_date_in_season(check_date):
                return season
        return None


class PassengerMultiplier(TimeStampedModel):
    """
    Pricing multiplier based on number of passengers per vehicle class.

    The multiplier depends on how "full" the vehicle is:
    - Sedan (max 3): 1-3 pax = base rate
    - Minivan (max 7): 1-5 pax = base, 6-7 pax = +10%
    - Large Minibus (max 16): 1-10 pax = base, 11-16 pax = +15%

    This is separate from the vehicle class multiplier itself.
    """

    vehicle_class = models.ForeignKey(
        'vehicles.VehicleClass',
        on_delete=models.CASCADE,
        related_name='passenger_multipliers',
        verbose_name='Vehicle Class'
    )
    min_passengers = models.PositiveIntegerField(verbose_name='Min Passengers')
    max_passengers = models.PositiveIntegerField(verbose_name='Max Passengers')
    multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Multiplier'
    )
    description = models.CharField(max_length=255, blank=True, verbose_name='Description')
    is_active = models.BooleanField(default=True, verbose_name='Active')
    display_order = models.PositiveIntegerField(default=0, verbose_name='Display Order')

    class Meta:
        verbose_name = 'Passenger Multiplier'
        verbose_name_plural = 'Passenger Multipliers'
        ordering = ['vehicle_class', 'min_passengers']

    def __str__(self):
        return f"{self.vehicle_class.class_name}: {self.min_passengers}-{self.max_passengers} pax → ×{self.multiplier}"

    @classmethod
    def get_multiplier_for_vehicle_and_passengers(cls, vehicle_class, num_passengers):
        """Get the applicable multiplier for given vehicle class and passenger count."""
        return cls.objects.filter(
            is_active=True,
            vehicle_class=vehicle_class,
            min_passengers__lte=num_passengers,
            max_passengers__gte=num_passengers
        ).first()


class TimeMultiplier(TimeStampedModel):
    """
    Time-of-day pricing adjustments.

    Examples:
    - Late Night (22:00-06:00): 1.20
    - Early Morning (04:00-06:00): 1.25
    - Standard Hours (06:00-22:00): 1.00
    """

    time_name = models.CharField(max_length=100, verbose_name='Time Period Name')
    start_time = models.TimeField(verbose_name='Start Time')
    end_time = models.TimeField(verbose_name='End Time')
    multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('1.00'),
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Multiplier'
    )
    applies_to_weekdays = models.BooleanField(default=True, verbose_name='Weekdays')
    applies_to_weekends = models.BooleanField(default=True, verbose_name='Weekends')
    is_active = models.BooleanField(default=True, verbose_name='Active')
    description = models.TextField(blank=True, verbose_name='Description')

    class Meta:
        verbose_name = 'Time Multiplier'
        verbose_name_plural = 'Time Multipliers'
        ordering = ['start_time']

    def __str__(self):
        return f"{self.time_name}: ×{self.multiplier}"

    def is_time_in_range(self, check_time, check_date=None):
        """Check if a time falls within this time period."""
        # Check weekend/weekday applicability
        if check_date:
            is_weekend = check_date.weekday() >= 5
            if is_weekend and not self.applies_to_weekends:
                return False
            if not is_weekend and not self.applies_to_weekdays:
                return False

        if self.start_time <= self.end_time:
            return self.start_time <= check_time <= self.end_time
        else:
            # Time range crosses midnight (e.g., 22:00 - 06:00)
            return check_time >= self.start_time or check_time <= self.end_time

    @classmethod
    def get_multiplier_for_time(cls, check_time, check_date=None):
        """Get the applicable time multiplier."""
        for tm in cls.objects.filter(is_active=True):
            if tm.is_time_in_range(check_time, check_date):
                return tm
        return None


class ExtraFee(TimeStampedModel):
    """
    Additional charges for special services.

    Examples:
    - Child Seat (0-4 years): €10 flat
    - Booster Seat (4-12 years): €5 flat
    - Extra Large Luggage: €15 per item
    - Pet Transport (small): €20 flat
    - Waiting Time: €30 per hour
    """

    class FeeType(models.TextChoices):
        PER_ITEM = 'per_item', 'Per Item'
        FLAT = 'flat', 'Flat Fee'
        PERCENTAGE = 'percentage', 'Percentage'

    fee_name = models.CharField(max_length=100, verbose_name='Fee Name')
    fee_code = models.CharField(max_length=50, unique=True, verbose_name='Fee Code')
    fee_type = models.CharField(
        max_length=20,
        choices=FeeType.choices,
        default=FeeType.FLAT,
        verbose_name='Fee Type'
    )
    amount = models.DecimalField(
        max_digits=10, decimal_places=2,
        validators=[MinValueValidator(Decimal('0.00'))],
        verbose_name='Amount',
        help_text='Amount in EUR (or percentage if fee_type=percentage)'
    )
    is_optional = models.BooleanField(
        default=True,
        verbose_name='Optional',
        help_text='User can opt-in/out'
    )
    is_active = models.BooleanField(default=True, verbose_name='Active')
    display_order = models.PositiveIntegerField(default=0, verbose_name='Display Order')
    description = models.TextField(blank=True, verbose_name='Description')
    applies_when = models.TextField(
        blank=True,
        verbose_name='Applies When',
        help_text='Conditions for automatic application (JSON or description)'
    )

    class Meta:
        verbose_name = 'Extra Fee'
        verbose_name_plural = 'Extra Fees'
        ordering = ['display_order', 'fee_name']

    def __str__(self):
        if self.fee_type == self.FeeType.PERCENTAGE:
            return f"{self.fee_name}: {self.amount}%"
        elif self.fee_type == self.FeeType.PER_ITEM:
            return f"{self.fee_name}: €{self.amount}/item"
        return f"{self.fee_name}: €{self.amount}"

    def calculate_fee(self, quantity=1, base_price=None):
        """Calculate the fee amount."""
        if self.fee_type == self.FeeType.PER_ITEM:
            return self.amount * quantity
        elif self.fee_type == self.FeeType.PERCENTAGE and base_price:
            return (self.amount / 100) * base_price
        return self.amount


class RoundTripDiscount(TimeStampedModel):
    """
    Discount for round-trip bookings (туда-обратно).

    When a customer books both directions, they get a discount
    on the total price (e.g., 10% off = multiplier 0.90).
    """

    name = models.CharField(
        max_length=100,
        default='Round Trip Discount',
        verbose_name='Discount Name'
    )
    multiplier = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=Decimal('0.90'),
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Multiplier',
        help_text='0.90 = 10% discount, 0.85 = 15% discount'
    )
    is_active = models.BooleanField(default=True, verbose_name='Active')
    description = models.TextField(
        blank=True,
        verbose_name='Description',
        help_text='Shown to customers'
    )

    class Meta:
        verbose_name = 'Round Trip Discount'
        verbose_name_plural = 'Round Trip Discounts'

    def __str__(self):
        discount_pct = (1 - self.multiplier) * 100
        return f"{self.name}: {discount_pct:.0f}% off"

    @classmethod
    def get_active_discount(cls):
        """Get the active round trip discount."""
        return cls.objects.filter(is_active=True).first()
