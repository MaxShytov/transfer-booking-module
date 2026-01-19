from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    SeasonalMultiplierViewSet,
    TimeMultiplierViewSet,
    ExtraFeeViewSet,
    PriceCalculateView,
)

app_name = 'pricing'

router = DefaultRouter()
router.register(r'seasonal-multipliers', SeasonalMultiplierViewSet, basename='seasonal-multiplier')
router.register(r'time-multipliers', TimeMultiplierViewSet, basename='time-multiplier')
router.register(r'extra-fees', ExtraFeeViewSet, basename='extra-fee')

urlpatterns = [
    path('', include(router.urls)),
    path('calculate/', PriceCalculateView.as_view(), name='calculate'),
]
