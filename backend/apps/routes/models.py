from decimal import Decimal
from math import radians, cos, sin, asin, sqrt

from django.db import models
from django.core.validators import MinValueValidator

from apps.core.models import TimeStampedModel


class FixedRoute(TimeStampedModel):
    """
    Pre-defined popular routes with fixed base prices.
    Uses geolocation matching with radius tolerance.

    Example routes:
    - Cagliari Airport → Villasimius: €80 (55 km)
    - Cagliari Airport → Costa Smeralda: €450 (305 km)
    - Olbia Airport → Porto Cervo: €65 (30 km)
    """

    class LocationType(models.TextChoices):
        AIRPORT = 'airport', 'Airport'
        CITY_CENTER = 'city_center', 'City Center'
        HOTEL_ZONE = 'hotel_zone', 'Hotel Zone'
        RESORT = 'resort', 'Resort'
        EXACT_ADDRESS = 'exact_address', 'Exact Address'

    route_name = models.CharField(max_length=255, verbose_name='Route Name')

    # Pickup Location
    pickup_address = models.CharField(max_length=500, verbose_name='Pickup Address')
    pickup_lat = models.DecimalField(
        max_digits=10, decimal_places=8,
        verbose_name='Pickup Latitude'
    )
    pickup_lng = models.DecimalField(
        max_digits=11, decimal_places=8,
        verbose_name='Pickup Longitude'
    )
    pickup_type = models.CharField(
        max_length=20,
        choices=LocationType.choices,
        default=LocationType.CITY_CENTER,
        verbose_name='Pickup Type'
    )
    pickup_radius_km = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=2.00,
        verbose_name='Pickup Radius (km)',
        help_text='Tolerance radius for matching'
    )

    # Dropoff Location
    dropoff_address = models.CharField(max_length=500, verbose_name='Dropoff Address')
    dropoff_lat = models.DecimalField(
        max_digits=10, decimal_places=8,
        verbose_name='Dropoff Latitude'
    )
    dropoff_lng = models.DecimalField(
        max_digits=11, decimal_places=8,
        verbose_name='Dropoff Longitude'
    )
    dropoff_type = models.CharField(
        max_length=20,
        choices=LocationType.choices,
        default=LocationType.CITY_CENTER,
        verbose_name='Dropoff Type'
    )
    dropoff_radius_km = models.DecimalField(
        max_digits=5, decimal_places=2,
        default=2.00,
        verbose_name='Dropoff Radius (km)',
        help_text='Tolerance radius for matching'
    )

    # Pricing
    base_price = models.DecimalField(
        max_digits=10, decimal_places=2,
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Base Price (EUR)'
    )
    currency = models.CharField(max_length=3, default='EUR', verbose_name='Currency')
    distance_km = models.DecimalField(
        max_digits=10, decimal_places=2,
        null=True, blank=True,
        verbose_name='Distance (km)',
        help_text='Pre-calculated route distance'
    )

    # Status
    is_active = models.BooleanField(default=True, verbose_name='Active')
    notes = models.TextField(blank=True, verbose_name='Internal Notes')

    class Meta:
        verbose_name = 'Fixed Route'
        verbose_name_plural = 'Fixed Routes'
        ordering = ['route_name']

    def __str__(self):
        return f"{self.route_name} - €{self.base_price}"

    @staticmethod
    def haversine_distance(lat1, lng1, lat2, lng2):
        """
        Calculate the great-circle distance between two points on Earth.
        Returns distance in kilometers.
        """
        lat1, lng1, lat2, lng2 = map(float, [lat1, lng1, lat2, lng2])
        lat1, lng1, lat2, lng2 = map(radians, [lat1, lng1, lat2, lng2])

        dlat = lat2 - lat1
        dlng = lng2 - lng1

        a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlng / 2) ** 2
        c = 2 * asin(sqrt(a))
        r = 6371  # Earth radius in kilometers

        return c * r

    @classmethod
    def find_matching_route(cls, pickup_lat, pickup_lng, dropoff_lat, dropoff_lng):
        """
        Find a fixed route that matches the given coordinates.
        Both pickup and dropoff must be within their respective radius tolerance.
        """
        for route in cls.objects.filter(is_active=True):
            pickup_distance = cls.haversine_distance(
                pickup_lat, pickup_lng,
                route.pickup_lat, route.pickup_lng
            )
            dropoff_distance = cls.haversine_distance(
                dropoff_lat, dropoff_lng,
                route.dropoff_lat, route.dropoff_lng
            )

            if (pickup_distance <= float(route.pickup_radius_km) and
                    dropoff_distance <= float(route.dropoff_radius_km)):
                return route

        return None


class DistancePricingRule(TimeStampedModel):
    """
    Pricing rules for distance-based calculation when no fixed route matches.

    Example tiers:
    - Short trips (0-30km): Base €40 + €2.00/km
    - Medium trips (30-100km): Base €50 + €1.50/km
    - Long trips (100-200km): Base €60 + €1.20/km
    - Extra long (200+km): Base €80 + €1.00/km
    """

    rule_name = models.CharField(max_length=255, verbose_name='Rule Name')
    base_rate = models.DecimalField(
        max_digits=10, decimal_places=2,
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Base Rate (EUR)',
        help_text='Minimum charge for this tier'
    )
    price_per_km = models.DecimalField(
        max_digits=10, decimal_places=2,
        validators=[MinValueValidator(Decimal('0.01'))],
        verbose_name='Price per km (EUR)'
    )
    price_per_minute = models.DecimalField(
        max_digits=10, decimal_places=2,
        default=0,
        verbose_name='Price per minute (EUR)',
        help_text='Optional: for traffic-based pricing'
    )
    min_distance_km = models.PositiveIntegerField(
        default=0,
        verbose_name='Minimum Distance (km)'
    )
    max_distance_km = models.PositiveIntegerField(
        default=9999,
        verbose_name='Maximum Distance (km)',
        help_text='Use 9999 for unlimited'
    )
    is_active = models.BooleanField(default=True, verbose_name='Active')
    priority = models.PositiveIntegerField(
        default=0,
        verbose_name='Priority',
        help_text='Lower number = higher priority'
    )

    class Meta:
        verbose_name = 'Distance Pricing Rule'
        verbose_name_plural = 'Distance Pricing Rules'
        ordering = ['priority', 'min_distance_km']

    def __str__(self):
        return f"{self.rule_name}: €{self.base_rate} + €{self.price_per_km}/km ({self.min_distance_km}-{self.max_distance_km}km)"

    @classmethod
    def get_rule_for_distance(cls, distance_km):
        """Get the applicable pricing rule for a given distance."""
        return cls.objects.filter(
            is_active=True,
            min_distance_km__lte=distance_km,
            max_distance_km__gte=distance_km
        ).order_by('priority').first()

    def calculate_price(self, distance_km, duration_minutes=0):
        """Calculate price for given distance and optional duration."""
        price = self.base_rate + (Decimal(str(distance_km)) * self.price_per_km)
        if self.price_per_minute and duration_minutes:
            price += Decimal(str(duration_minutes)) * self.price_per_minute
        return price
