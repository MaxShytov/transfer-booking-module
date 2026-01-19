from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import FixedRouteViewSet, DistancePricingRuleViewSet

app_name = 'routes'

router = DefaultRouter()
router.register(r'fixed', FixedRouteViewSet, basename='fixed-route')
router.register(r'distance-rules', DistancePricingRuleViewSet, basename='distance-rule')

urlpatterns = [
    path('', include(router.urls)),
]
