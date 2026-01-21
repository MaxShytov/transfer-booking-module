from django.urls import path

from .views import CreateBookingView, BookingListView, BookingDetailView

app_name = 'bookings'

urlpatterns = [
    path('', BookingListView.as_view(), name='list'),
    path('create/', CreateBookingView.as_view(), name='create'),
    path('<int:booking_id>/', BookingDetailView.as_view(), name='detail'),
]
