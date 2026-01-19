from django.contrib import admin

from .models import Booking


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    """
    Booking Management.

    Central table storing all booking data and pricing calculations.
    Price formula: Final = (Base × Vehicle × Passengers × Season × Time) + Extra Fees

    Status flow: Pending → Confirmed → In Progress → Completed (or Cancelled)
    """
    list_display = (
        'booking_reference',
        'customer_name',
        'service_date',
        'pickup_time',
        'num_passengers',
        'selected_vehicle_class',
        'final_price',
        'status',
        'payment_status',
    )
    list_filter = (
        'status',
        'payment_status',
        'pricing_type',
        'selected_vehicle_class',
        'service_date',
    )
    search_fields = (
        'booking_reference',
        'customer_name',
        'customer_email',
        'customer_phone',
        'pickup_address',
        'dropoff_address',
    )
    date_hierarchy = 'service_date'
    ordering = ['-created_at']
    readonly_fields = ('booking_reference', 'created_at', 'updated_at')

    fieldsets = (
        ('Booking Info', {
            'fields': ('booking_reference', 'status', 'payment_status'),
            'description': (
                '<strong>Booking Reference</strong><br>'
                'Format: SAT-YYYY-XXXX (auto-generated).<br>'
                'Status: Pending → Confirmed → In Progress → Completed'
            ),
        }),
        ('Route', {
            'fields': (
                'pickup_address', ('pickup_lat', 'pickup_lng'), 'pickup_notes',
                'dropoff_address', ('dropoff_lat', 'dropoff_lng'), 'dropoff_notes',
                ('service_date', 'pickup_time'),
            ),
            'description': (
                '<strong>Transfer Route</strong><br>'
                'Coordinates are obtained from Google Places API.'
            ),
        }),
        ('Passengers & Vehicle', {
            'fields': (
                ('num_passengers', 'num_large_luggage', 'num_small_luggage'),
                ('has_children', 'children_ages'),
                ('selected_vehicle_class', 'actual_vehicle_class'),
                'vehicle_upgrade_reason',
            ),
            'description': (
                '<strong>Passenger Details & Vehicle Selection</strong><br>'
                'Selected = what customer chose. Actual = what was delivered (may be upgraded).<br>'
                'Upgrade reason explains why actual differs from selected.'
            ),
        }),
        ('Flight & Requests', {
            'fields': ('flight_number', 'special_requests'),
            'description': 'Optional flight info for airport pickups and special notes.',
        }),
        ('Pricing', {
            'fields': (
                'pricing_type', 'fixed_route', 'distance_km', 'duration_minutes',
                'base_price',
                ('seasonal_multiplier', 'vehicle_class_multiplier'),
                ('passenger_multiplier', 'time_multiplier'),
                'subtotal', 'extra_fees_json', 'extra_fees_total',
                ('final_price', 'currency'),
            ),
            'description': (
                '<strong>Price Breakdown</strong><br>'
                'Formula: Final = (Base × Vehicle × Passengers × Season × Time) + Extra Fees<br>'
                'Pricing type: Fixed Route (pre-defined price) or Distance-Based (calculated).'
            ),
        }),
        ('Customer', {
            'fields': (
                'customer_name', 'customer_phone', 'customer_email', 'customer',
            ),
            'description': 'Customer contact information. "Customer" links to registered user account (if any).',
        }),
        ('Payment', {
            'fields': ('payment_method', 'payment_intent_id'),
            'description': (
                '<strong>Payment Information</strong><br>'
                'Payment Intent ID is from Stripe for tracking transactions.'
            ),
        }),
        ('Internal', {
            'fields': ('internal_notes', 'confirmed_at', 'completed_at'),
            'classes': ('collapse',),
            'description': 'Internal notes and timestamps (not visible to customer).',
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )
