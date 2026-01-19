from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import VehicleClassViewSet, VehicleClassRequirementViewSet

app_name = 'vehicles'

router = DefaultRouter()
router.register(r'classes', VehicleClassViewSet, basename='vehicle-class')
router.register(r'requirements', VehicleClassRequirementViewSet, basename='vehicle-requirement')

urlpatterns = [
    path('', include(router.urls)),
]
