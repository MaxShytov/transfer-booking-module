from django.contrib import admin

from .models import SeasonalMultiplier, PassengerMultiplier, TimeMultiplier, ExtraFee, RoundTripDiscount


@admin.register(SeasonalMultiplier)
class SeasonalMultiplierAdmin(admin.ModelAdmin):
    """
    Seasonal Pricing Multipliers.

    Dynamic pricing based on season. Overlapping seasons use priority
    (lower number = higher priority).

    Examples:
    - High Summer (Jun-Sep): ×1.30
    - Ferragosto (Aug 10-20): ×1.40 (highest priority)
    - Low Season (Nov-Mar): ×1.00
    """
    list_display = (
        'season_name',
        'start_date',
        'end_date',
        'multiplier',
        'year_recurring',
        'priority',
        'is_active',
    )
    list_filter = ('is_active', 'year_recurring')
    list_editable = ('multiplier', 'priority', 'is_active')
    ordering = ('priority', 'start_date')

    fieldsets = (
        (None, {
            'fields': ('season_name', 'priority'),
            'description': (
                '<strong>Seasonal Multiplier</strong><br>'
                'Define pricing adjustments for different seasons.<br>'
                'Lower priority = applied first when seasons overlap.'
            ),
        }),
        ('Period', {
            'fields': ('start_date', 'end_date', 'year_recurring'),
            'description': (
                '<strong>Season Period</strong><br>'
                'Year recurring = repeats every year (ignores year in dates).<br>'
                'Can cross year boundary (e.g., Dec 20 - Jan 5).'
            ),
        }),
        ('Pricing', {
            'fields': ('multiplier',),
            'description': (
                '<strong>Price Multiplier</strong><br>'
                '1.00 = base price, 1.30 = +30%, 1.40 = +40%'
            ),
        }),
        ('Status', {
            'fields': ('is_active', 'description'),
        }),
    )


@admin.register(PassengerMultiplier)
class PassengerMultiplierAdmin(admin.ModelAdmin):
    """
    Passenger Count Multipliers per Vehicle Class.

    Each vehicle class has its own passenger multiplier ranges.
    The multiplier depends on how "full" the vehicle is.

    Example: Minivan (max 7 pax)
    - 1-5 passengers: ×1.00 (comfortable)
    - 6-7 passengers: ×1.10 (full capacity)
    """
    list_display = (
        'vehicle_class',
        'min_passengers',
        'max_passengers',
        'multiplier',
        'description',
        'is_active',
    )
    list_filter = ('is_active', 'vehicle_class')
    list_editable = ('multiplier', 'is_active')
    ordering = ('vehicle_class', 'min_passengers')

    fieldsets = (
        (None, {
            'fields': ('vehicle_class', 'min_passengers', 'max_passengers', 'multiplier'),
            'description': (
                '<strong>Passenger Multiplier per Vehicle Class</strong><br>'
                'Define price adjustments based on vehicle "fullness".<br>'
                'Example: Minivan with 1-5 pax = ×1.00, with 6-7 pax = ×1.10'
            ),
        }),
        ('Display', {
            'fields': ('description', 'display_order', 'is_active'),
        }),
    )


@admin.register(TimeMultiplier)
class TimeMultiplierAdmin(admin.ModelAdmin):
    """
    Time-of-Day Multipliers.

    Premium pricing for inconvenient hours.
    Example: Late night (22:00-06:00) = ×1.20
    """
    list_display = (
        'time_name',
        'start_time',
        'end_time',
        'multiplier',
        'applies_to_weekdays',
        'applies_to_weekends',
        'is_active',
    )
    list_filter = ('is_active', 'applies_to_weekdays', 'applies_to_weekends')
    list_editable = ('multiplier', 'is_active')
    ordering = ('start_time',)

    fieldsets = (
        (None, {
            'fields': ('time_name', 'start_time', 'end_time', 'multiplier'),
            'description': (
                '<strong>Time Period Multiplier</strong><br>'
                'Can cross midnight (e.g., 22:00 - 06:00).<br>'
                'Standard hours usually = ×1.00, night = ×1.20'
            ),
        }),
        ('Applicability', {
            'fields': ('applies_to_weekdays', 'applies_to_weekends'),
            'description': 'Choose when this multiplier applies.',
        }),
        ('Status', {
            'fields': ('is_active', 'description'),
        }),
    )


@admin.register(ExtraFee)
class ExtraFeeAdmin(admin.ModelAdmin):
    """
    Extra Fees / Additional Services.

    Optional or mandatory charges for special services.
    Fee types:
    - Flat: Fixed amount (e.g., Child Seat €10)
    - Per Item: Multiplied by quantity (e.g., Extra Luggage €15/item)
    - Percentage: % of subtotal
    """
    list_display = (
        'fee_name',
        'fee_code',
        'fee_type',
        'amount',
        'is_optional',
        'is_active',
        'display_order',
    )
    list_filter = ('is_active', 'is_optional', 'fee_type')
    search_fields = ('fee_name', 'fee_code')
    list_editable = ('amount', 'is_optional', 'is_active', 'display_order')
    ordering = ('display_order', 'fee_name')

    fieldsets = (
        (None, {
            'fields': ('fee_name', 'fee_code', 'fee_type', 'amount'),
            'description': (
                '<strong>Extra Fee Configuration</strong><br>'
                'Flat = fixed amount, Per Item = multiplied by quantity.<br>'
                'Fee code is used in API (e.g., "child_seat").'
            ),
        }),
        ('Options', {
            'fields': ('is_optional', 'applies_when'),
            'description': (
                '<strong>Fee Options</strong><br>'
                'Optional = customer can choose. Non-optional = always applied.<br>'
                '"Applies when" = conditions for automatic application.'
            ),
        }),
        ('Display', {
            'fields': ('display_order', 'description', 'is_active'),
            'description': 'Order in booking form and customer-facing description.',
        }),
    )


@admin.register(RoundTripDiscount)
class RoundTripDiscountAdmin(admin.ModelAdmin):
    """
    Round Trip Discount Configuration.

    Discount applied when customer books both directions (туда-обратно).
    Example: 10% off = multiplier 0.90
    """
    list_display = (
        'name',
        'multiplier',
        'discount_display',
        'is_active',
    )
    list_editable = ('multiplier', 'is_active')

    fieldsets = (
        (None, {
            'fields': ('name', 'multiplier'),
            'description': (
                '<strong>Round Trip Discount</strong><br>'
                '0.90 = 10% off, 0.85 = 15% off, 0.80 = 20% off<br>'
                'Applied to total of both trips.'
            ),
        }),
        ('Status', {
            'fields': ('is_active', 'description'),
        }),
    )

    @admin.display(description='Discount')
    def discount_display(self, obj):
        discount_pct = int((1 - obj.multiplier) * 100)
        return f'{discount_pct}% off'
