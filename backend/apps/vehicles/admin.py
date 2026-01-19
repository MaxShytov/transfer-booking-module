from django.contrib import admin

from .models import VehicleClass, VehicleClassRequirement
from apps.pricing.models import PassengerMultiplier


class PassengerMultiplierInline(admin.TabularInline):
    """
    Inline editor for passenger multipliers within VehicleClass.

    Define price adjustments based on how "full" the vehicle is.
    """
    model = PassengerMultiplier
    extra = 1
    fields = ('min_passengers', 'max_passengers', 'multiplier', 'description', 'is_active')
    ordering = ('min_passengers',)


@admin.register(VehicleClass)
class VehicleClassAdmin(admin.ModelAdmin):
    """
    Vehicle Classes Management.

    Defines vehicle types with pricing multipliers. Customers select their
    preferred class. Upgrade is allowed, downgrade is forbidden based on
    passenger/luggage requirements.
    """
    list_display = (
        'class_name',
        'class_code',
        'tier_level',
        'price_multiplier',
        'max_passengers',
        'max_large_luggage',
        'is_active',
        'display_order',
    )
    list_filter = ('is_active', 'tier_level')
    search_fields = ('class_name', 'class_code', 'example_vehicles')
    ordering = ('tier_level', 'display_order')
    list_editable = ('price_multiplier', 'is_active', 'display_order')
    inlines = [PassengerMultiplierInline]

    fieldsets = (
        (None, {
            'fields': ('class_name', 'class_code', 'tier_level'),
            'description': (
                '<strong>Vehicle Class Configuration</strong><br>'
                'Each class has a tier level (1-7). Higher tier = more premium vehicle.<br>'
                'Tier 1: Economy → Tier 7: Large Minibus'
            ),
        }),
        ('Pricing', {
            'fields': ('price_multiplier',),
            'description': (
                '<strong>Price Multiplier</strong><br>'
                '1.00 = base price, 1.30 = +30%, 2.50 = +150%<br>'
                'Final price = Base Route Price × Vehicle Multiplier × Passenger Multiplier × Other Multipliers'
            ),
        }),
        ('Capacity', {
            'fields': ('max_passengers', 'max_large_luggage', 'max_small_luggage'),
            'description': (
                '<strong>Maximum Capacity</strong><br>'
                'System validates that selected class can accommodate passengers and luggage.'
            ),
        }),
        ('Display', {
            'fields': ('description', 'example_vehicles', 'icon_url', 'display_order'),
            'description': 'Information shown to customers in booking form.',
        }),
        ('Status', {
            'fields': ('is_active',),
            'description': 'Inactive classes are hidden from booking form.',
        }),
    )


@admin.register(VehicleClassRequirement)
class VehicleClassRequirementAdmin(admin.ModelAdmin):
    """
    Vehicle Tier Requirements.

    Defines minimum vehicle tier based on passengers or luggage count.
    System uses the HIGHER requirement between passengers and luggage.

    Example: 5-7 passengers → Minimum Tier 4 (Minivan required)
    """
    list_display = (
        'required_for',
        'min_value',
        'max_value',
        'min_vehicle_tier',
        'is_strict',
    )
    list_filter = ('required_for', 'is_strict')
    ordering = ('required_for', 'min_value')

    fieldsets = (
        (None, {
            'fields': ('required_for', 'min_value', 'max_value', 'min_vehicle_tier'),
            'description': (
                '<strong>Requirement Configuration</strong><br>'
                'Define ranges: e.g., 5-7 passengers require minimum Tier 4 (Minivan).<br>'
                'System takes the HIGHER requirement between passengers and luggage.'
            ),
        }),
        ('Validation', {
            'fields': ('is_strict', 'validation_message'),
            'description': (
                '<strong>Validation Rules</strong><br>'
                'Strict = customer cannot downgrade below this tier.<br>'
                'Validation message is shown when requirement is not met.'
            ),
        }),
    )
