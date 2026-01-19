from django.contrib import admin

from .models import FixedRoute, DistancePricingRule


@admin.register(FixedRoute)
class FixedRouteAdmin(admin.ModelAdmin):
    """
    Fixed Routes Management.

    Popular routes with pre-defined prices. System matches customer coordinates
    using Haversine distance within radius tolerance.

    If customer's pickup AND dropoff are within radius → Fixed route price is used.
    Otherwise → Distance-based pricing is applied.
    """
    list_display = (
        'route_name',
        'base_price',
        'distance_km',
        'pickup_type',
        'dropoff_type',
        'is_active',
    )
    list_filter = ('is_active', 'pickup_type', 'dropoff_type')
    search_fields = ('route_name', 'pickup_address', 'dropoff_address')
    list_editable = ('base_price', 'is_active')
    ordering = ('route_name',)

    fieldsets = (
        (None, {
            'fields': ('route_name',),
            'description': (
                '<strong>Fixed Route Configuration</strong><br>'
                'Define popular routes with fixed base prices.<br>'
                'Example: Cagliari Airport → Villasimius = €80'
            ),
        }),
        ('Pickup Location', {
            'fields': (
                'pickup_address',
                ('pickup_lat', 'pickup_lng'),
                ('pickup_type', 'pickup_radius_km'),
            ),
            'description': (
                '<strong>Pickup Point with Geomatching</strong><br>'
                'Radius defines tolerance for matching customer location.<br>'
                'Recommended: Airport = 5km, City Center = 2km, Resort = 5km'
            ),
        }),
        ('Dropoff Location', {
            'fields': (
                'dropoff_address',
                ('dropoff_lat', 'dropoff_lng'),
                ('dropoff_type', 'dropoff_radius_km'),
            ),
            'description': (
                '<strong>Dropoff Point with Geomatching</strong><br>'
                'Both pickup AND dropoff must match for fixed pricing.'
            ),
        }),
        ('Pricing', {
            'fields': ('base_price', 'currency', 'distance_km'),
            'description': (
                '<strong>Route Pricing</strong><br>'
                'Base price BEFORE any multipliers (season, vehicle, etc.).<br>'
                'Distance is for reference only.'
            ),
        }),
        ('Status', {
            'fields': ('is_active', 'notes'),
            'description': 'Inactive routes are not matched during booking.',
        }),
    )


@admin.register(DistancePricingRule)
class DistancePricingRuleAdmin(admin.ModelAdmin):
    """
    Distance-Based Pricing Rules.

    Fallback pricing when no fixed route matches.
    Formula: Price = Base Rate + (Distance × Price per km)

    Rules are selected by distance range with priority ordering.
    """
    list_display = (
        'rule_name',
        'base_rate',
        'price_per_km',
        'min_distance_km',
        'max_distance_km',
        'priority',
        'is_active',
    )
    list_filter = ('is_active',)
    list_editable = ('base_rate', 'price_per_km', 'priority', 'is_active')
    ordering = ('priority', 'min_distance_km')

    fieldsets = (
        (None, {
            'fields': ('rule_name', 'priority'),
            'description': (
                '<strong>Distance Pricing Rule</strong><br>'
                'Used when customer route does not match any fixed route.<br>'
                'Lower priority number = higher precedence.'
            ),
        }),
        ('Distance Range', {
            'fields': ('min_distance_km', 'max_distance_km'),
            'description': (
                '<strong>Applicable Distance Range</strong><br>'
                'Example: 0-30km = Short trips, 31-100km = Medium trips<br>'
                'Use 9999 for max_distance to cover unlimited range.'
            ),
        }),
        ('Pricing Formula', {
            'fields': ('base_rate', 'price_per_km', 'price_per_minute'),
            'description': (
                '<strong>Price Calculation</strong><br>'
                'Formula: Base Rate + (Distance × Price per km)<br>'
                'Example: €40 + (25km × €2.00) = €90'
            ),
        }),
        ('Status', {
            'fields': ('is_active',),
        }),
    )
