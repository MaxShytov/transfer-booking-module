"""
URL configuration for Transfer Booking Module.
"""
from django.conf import settings
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),

    # Authentication API
    path('api/v1/auth/', include('apps.accounts.urls')),

    # API endpoints
    path('api/v1/vehicles/', include('apps.vehicles.urls')),
    path('api/v1/routes/', include('apps.routes.urls')),
    path('api/v1/pricing/', include('apps.pricing.urls')),
    # path('api/v1/bookings/', include('apps.bookings.urls')),  # Coming in Sprint 3
]

# Debug toolbar (development only)
if settings.DEBUG:
    try:
        import debug_toolbar
        urlpatterns = [
            path('__debug__/', include(debug_toolbar.urls)),
        ] + urlpatterns
    except ImportError:
        pass
