from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from .models import User


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    """
    User Management.

    Roles: Admin, Manager, Driver, Customer
    Languages: EN, IT, DE, FR, AR (Arabic with RTL support)
    """
    list_display = ('email', 'first_name', 'last_name', 'role', 'language', 'is_active', 'is_staff')
    list_filter = ('role', 'language', 'is_active', 'is_staff', 'is_superuser')
    search_fields = ('email', 'first_name', 'last_name', 'phone')
    ordering = ('email',)
    list_editable = ('role', 'language', 'is_active')

    fieldsets = (
        (None, {
            'fields': ('email', 'password'),
            'description': 'Email is used as the username for authentication.',
        }),
        ('Personal Info', {
            'fields': ('first_name', 'last_name', 'phone', 'language'),
            'description': 'Language preference affects emails and notifications sent to the user.',
        }),
        ('Role & Permissions', {
            'fields': ('role', 'is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
            'description': (
                '<strong>Roles:</strong><br>'
                '- Admin: Full system access<br>'
                '- Manager: Booking & pricing management<br>'
                '- Driver: View assigned bookings<br>'
                '- Customer: Make bookings'
            ),
        }),
        ('Dates', {
            'fields': ('last_login', 'created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )
    readonly_fields = ('created_at', 'updated_at', 'last_login')

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2', 'first_name', 'last_name', 'phone', 'language', 'role'),
        }),
    )
