from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

from apps.core.models import TimeStampedModel


class VehicleClass(TimeStampedModel):
    """
    Vehicle classes with pricing multipliers.

    Tier levels (1-7):
    - Tier 1: Economy Sedan (base price)
    - Tier 2: Business Sedan (+30%)
    - Tier 3: Luxury Sedan (+80%)
    - Tier 4: Minivan (+40%)
    - Tier 5: Luxury Minivan (+120%)
    - Tier 6: Minibus (+150%)
    - Tier 7: Large Minibus (+250%)
    """

    class_name = models.CharField(max_length=100, verbose_name='Class Name')
    class_code = models.CharField(max_length=50, unique=True, verbose_name='Class Code')
    tier_level = models.PositiveIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(10)],
        verbose_name='Tier Level',
        help_text='1 = lowest (Economy), higher = premium'
    )
    price_multiplier = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=1.00,
        validators=[MinValueValidator(0.01)],
        verbose_name='Price Multiplier',
        help_text='1.00 = base price, 1.30 = +30%'
    )
    max_passengers = models.PositiveIntegerField(verbose_name='Max Passengers')
    max_large_luggage = models.PositiveIntegerField(verbose_name='Max Large Luggage')
    max_small_luggage = models.PositiveIntegerField(verbose_name='Max Small Luggage')
    description = models.TextField(blank=True, verbose_name='Description')
    example_vehicles = models.CharField(
        max_length=255,
        blank=True,
        verbose_name='Example Vehicles',
        help_text='e.g., "Mercedes E-Class, BMW 5 Series"'
    )
    icon_url = models.URLField(blank=True, verbose_name='Icon URL')
    is_active = models.BooleanField(default=True, verbose_name='Active')
    display_order = models.PositiveIntegerField(default=0, verbose_name='Display Order')

    class Meta:
        verbose_name = 'Vehicle Class'
        verbose_name_plural = 'Vehicle Classes'
        ordering = ['tier_level', 'display_order']

    def __str__(self):
        return f"{self.class_name} (Tier {self.tier_level})"


class VehicleClassRequirement(TimeStampedModel):
    """
    Minimum vehicle tier requirements based on passengers or luggage.

    Example:
    - 5-7 passengers → Min Tier 4 (Minivan required)
    - 3-5 large bags → Min Tier 4 (Minivan for space)
    """

    class RequirementType(models.TextChoices):
        PASSENGERS = 'passengers', 'Passengers'
        LUGGAGE = 'luggage', 'Luggage'
        BOTH = 'both', 'Both'

    min_value = models.PositiveIntegerField(verbose_name='Minimum Value')
    max_value = models.PositiveIntegerField(verbose_name='Maximum Value')
    min_vehicle_tier = models.PositiveIntegerField(
        verbose_name='Minimum Vehicle Tier',
        help_text='Minimum tier required for this range'
    )
    required_for = models.CharField(
        max_length=20,
        choices=RequirementType.choices,
        default=RequirementType.PASSENGERS,
        verbose_name='Requirement Type'
    )
    is_strict = models.BooleanField(
        default=True,
        verbose_name='Strict Requirement',
        help_text='If true, cannot be downgraded'
    )
    validation_message = models.CharField(
        max_length=255,
        blank=True,
        verbose_name='Validation Message',
        help_text='Message shown when requirement not met'
    )

    class Meta:
        verbose_name = 'Vehicle Requirement'
        verbose_name_plural = 'Vehicle Requirements'
        ordering = ['required_for', 'min_value']

    def __str__(self):
        return f"{self.get_required_for_display()}: {self.min_value}-{self.max_value} → Tier {self.min_vehicle_tier}"

    @classmethod
    def get_minimum_tier_for_passengers(cls, num_passengers):
        """Get minimum required vehicle tier for given number of passengers."""
        requirement = cls.objects.filter(
            required_for=cls.RequirementType.PASSENGERS,
            min_value__lte=num_passengers,
            max_value__gte=num_passengers
        ).first()
        return requirement.min_vehicle_tier if requirement else 1

    @classmethod
    def get_minimum_tier_for_luggage(cls, num_large_luggage):
        """Get minimum required vehicle tier for given number of large luggage."""
        requirement = cls.objects.filter(
            required_for=cls.RequirementType.LUGGAGE,
            min_value__lte=num_large_luggage,
            max_value__gte=num_large_luggage
        ).first()
        return requirement.min_vehicle_tier if requirement else 1

    @classmethod
    def get_minimum_tier(cls, num_passengers, num_large_luggage):
        """
        Get the highest minimum tier required based on passengers AND luggage.
        Returns the more restrictive of the two requirements.
        """
        passenger_tier = cls.get_minimum_tier_for_passengers(num_passengers)
        luggage_tier = cls.get_minimum_tier_for_luggage(num_large_luggage)
        return max(passenger_tier, luggage_tier)
