from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import DispatcherBookingViewSet, DriverViewSet

router = DefaultRouter()
router.register(r'bookings', DispatcherBookingViewSet, basename='dispatcher-bookings')
router.register(r'drivers', DriverViewSet, basename='dispatcher-drivers')

urlpatterns = [
    path('', include(router.urls)),
]
