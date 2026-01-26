from datetime import date, timedelta
from decimal import Decimal

from django.contrib.auth import get_user_model
from django.db.models import Sum, Count, Q
from django.utils import timezone
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters import rest_framework as filters

from apps.bookings.models import Booking
from apps.accounts.models import DriverProfile
from .permissions import IsDispatcher
from .serializers import (
    DispatcherBookingListSerializer,
    DispatcherBookingDetailSerializer,
    DispatcherBookingUpdateSerializer,
    DispatcherBookingCreateSerializer,
    BookingStatusUpdateSerializer,
    BookingDriverAssignSerializer,
    BookingPaymentStatusUpdateSerializer,
    BookingNotesUpdateSerializer,
    DriverListSerializer,
    DispatcherStatsSerializer,
)

User = get_user_model()


class BookingFilter(filters.FilterSet):
    """Filter for bookings in dispatcher dashboard."""

    date = filters.DateFilter(field_name='service_date')
    date_from = filters.DateFilter(field_name='service_date', lookup_expr='gte')
    date_to = filters.DateFilter(field_name='service_date', lookup_expr='lte')
    status = filters.ChoiceFilter(choices=Booking.Status.choices)
    payment_status = filters.ChoiceFilter(choices=Booking.PaymentStatus.choices)
    assigned_driver = filters.NumberFilter(field_name='assigned_driver_id')
    unassigned = filters.BooleanFilter(method='filter_unassigned')
    search = filters.CharFilter(method='filter_search')

    class Meta:
        model = Booking
        fields = ['date', 'date_from', 'date_to', 'status', 'payment_status', 'assigned_driver']

    def filter_unassigned(self, queryset, name, value):
        if value:
            return queryset.filter(assigned_driver__isnull=True)
        return queryset

    def filter_search(self, queryset, name, value):
        if value:
            return queryset.filter(
                Q(booking_reference__icontains=value) |
                Q(customer_name__icontains=value) |
                Q(customer_phone__icontains=value) |
                Q(customer_email__icontains=value) |
                Q(pickup_address__icontains=value) |
                Q(dropoff_address__icontains=value)
            )
        return queryset


class DispatcherBookingViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing bookings in dispatcher dashboard.

    Provides CRUD operations plus additional actions:
    - update_status: Change booking status
    - assign_driver: Assign/unassign driver
    - update_payment_status: Change payment status
    - update_notes: Update dispatcher/internal notes
    """

    permission_classes = [IsDispatcher]
    filterset_class = BookingFilter

    def get_queryset(self):
        return Booking.objects.select_related(
            'selected_vehicle_class',
            'assigned_driver',
            'assigned_driver__driver_profile',
        ).order_by('-service_date', 'pickup_time')

    def get_serializer_class(self):
        if self.action == 'list':
            return DispatcherBookingListSerializer
        elif self.action == 'create':
            return DispatcherBookingCreateSerializer
        elif self.action in ('update', 'partial_update'):
            return DispatcherBookingUpdateSerializer
        return DispatcherBookingDetailSerializer

    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        """Update booking status."""
        booking = self.get_object()
        serializer = BookingStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        new_status = serializer.validated_data['status']
        now = timezone.now()

        # Update status and related timestamps
        booking.status = new_status
        if new_status == 'confirmed' and not booking.confirmed_at:
            booking.confirmed_at = now
        elif new_status == 'completed' and not booking.completed_at:
            booking.completed_at = now
        elif new_status == 'cancelled':
            booking.cancelled_at = now
            booking.cancellation_reason = serializer.validated_data.get('cancellation_reason', '')

        booking.save()
        return Response(DispatcherBookingDetailSerializer(booking).data)

    @action(detail=True, methods=['post'])
    def assign_driver(self, request, pk=None):
        """Assign or unassign driver to booking."""
        booking = self.get_object()
        serializer = BookingDriverAssignSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        driver_id = serializer.validated_data.get('driver_id')
        if driver_id:
            booking.assigned_driver = User.objects.get(id=driver_id)
        else:
            booking.assigned_driver = None

        booking.save()
        return Response(DispatcherBookingDetailSerializer(booking).data)

    @action(detail=True, methods=['post'])
    def update_payment_status(self, request, pk=None):
        """Update payment status."""
        booking = self.get_object()
        serializer = BookingPaymentStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        booking.payment_status = serializer.validated_data['payment_status']
        booking.save()
        return Response(DispatcherBookingDetailSerializer(booking).data)

    @action(detail=True, methods=['post'])
    def update_notes(self, request, pk=None):
        """Update dispatcher and/or internal notes."""
        booking = self.get_object()
        serializer = BookingNotesUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        if 'dispatcher_notes' in serializer.validated_data:
            booking.dispatcher_notes = serializer.validated_data['dispatcher_notes']
        if 'internal_notes' in serializer.validated_data:
            booking.internal_notes = serializer.validated_data['internal_notes']

        booking.save()
        return Response(DispatcherBookingDetailSerializer(booking).data)

    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get dispatcher dashboard statistics."""
        today = date.today()

        # Today's bookings
        today_bookings = Booking.objects.filter(service_date=today)
        today_revenue = today_bookings.aggregate(
            total=Sum('final_price')
        )['total'] or Decimal('0.00')

        # Status counts (all bookings)
        all_bookings = Booking.objects.all()
        status_counts = all_bookings.values('status').annotate(count=Count('id'))
        status_dict = {s['status']: s['count'] for s in status_counts}

        # Unassigned bookings (pending or confirmed without driver)
        unassigned = Booking.objects.filter(
            status__in=['pending', 'confirmed'],
            assigned_driver__isnull=True
        ).count()

        # Unpaid bookings (exclude completed/cancelled)
        unpaid = Booking.objects.filter(
            payment_status='unpaid',
            status__in=['pending', 'confirmed', 'in_progress']
        ).count()

        # Driver stats
        drivers_total = User.objects.filter(role='driver', is_active=True).count()
        drivers_available = User.objects.filter(
            role='driver',
            is_active=True,
            driver_profile__is_available=True
        ).count()

        stats = {
            'today_transfers': today_bookings.count(),
            'today_revenue': today_revenue,
            'pending_count': status_dict.get('pending', 0),
            'confirmed_count': status_dict.get('confirmed', 0),
            'in_progress_count': status_dict.get('in_progress', 0),
            'completed_count': status_dict.get('completed', 0),
            'cancelled_count': status_dict.get('cancelled', 0),
            'unassigned_count': unassigned,
            'unpaid_count': unpaid,
            'drivers_available': drivers_available,
            'drivers_total': drivers_total,
        }

        return Response(DispatcherStatsSerializer(stats).data)

    @action(detail=False, methods=['get'])
    def today(self, request):
        """Get today's bookings."""
        today = date.today()
        queryset = self.get_queryset().filter(service_date=today)
        serializer = DispatcherBookingListSerializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def upcoming(self, request):
        """Get upcoming bookings (next 7 days)."""
        today = date.today()
        end_date = today + timedelta(days=7)
        queryset = self.get_queryset().filter(
            service_date__gte=today,
            service_date__lte=end_date
        )
        serializer = DispatcherBookingListSerializer(queryset, many=True)
        return Response(serializer.data)


class DriverViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for listing drivers in dispatcher dashboard.
    """

    permission_classes = [IsDispatcher]
    serializer_class = DriverListSerializer

    def get_queryset(self):
        return User.objects.filter(
            role='driver',
            is_active=True
        ).select_related('driver_profile').prefetch_related('assigned_bookings')

    @action(detail=False, methods=['get'])
    def available(self, request):
        """Get available drivers."""
        queryset = self.get_queryset().filter(
            driver_profile__is_available=True
        )
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def toggle_availability(self, request, pk=None):
        """Toggle driver availability."""
        driver = self.get_object()
        profile, created = DriverProfile.objects.get_or_create(
            user=driver,
            defaults={'vehicle_plate': '', 'vehicle_model': ''}
        )
        profile.is_available = not profile.is_available
        profile.save()
        return Response(self.get_serializer(driver).data)

    @action(detail=True, methods=['get'])
    def bookings(self, request, pk=None):
        """Get bookings assigned to driver."""
        driver = self.get_object()
        bookings = Booking.objects.filter(
            assigned_driver=driver
        ).order_by('-service_date', 'pickup_time')

        # Apply date filters if provided
        date_from = request.query_params.get('date_from')
        date_to = request.query_params.get('date_to')
        if date_from:
            bookings = bookings.filter(service_date__gte=date_from)
        if date_to:
            bookings = bookings.filter(service_date__lte=date_to)

        serializer = DispatcherBookingListSerializer(bookings, many=True)
        return Response(serializer.data)
