from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated

from .models import Booking
from .serializers import (
    CreateBookingRequestSerializer,
    BookingResponseSerializer,
    BookingListSerializer,
    BookingDetailSerializer,
)
from apps.vehicles.models import VehicleClass
from apps.routes.models import FixedRoute


class CreateBookingView(APIView):
    """
    Create a new booking.

    POST /api/bookings/create/

    Creates a booking with all pricing data from the frontend.
    Pricing is calculated on frontend via /api/pricing/calculate/ endpoint.
    """

    permission_classes = [AllowAny]

    def post(self, request):
        serializer = CreateBookingRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # Get vehicle class
        vehicle_class = VehicleClass.objects.get(id=data['vehicle_class_id'])

        # Get fixed route if applicable
        fixed_route = None
        if data['pricing_type'] == 'fixed_route' and data.get('route_name'):
            fixed_route = FixedRoute.objects.filter(
                route_name=data['route_name'],
                is_active=True
            ).first()

        # Build flight number string (combine outbound and return if present)
        flight_number = data.get('flight_number', '')
        return_flight = data.get('return_flight_number', '')
        if data.get('is_round_trip') and return_flight:
            if flight_number:
                flight_number = f"{flight_number} / {return_flight}"
            else:
                flight_number = f"Return: {return_flight}"

        # Create booking
        booking = Booking.objects.create(
            # Route
            pickup_address=data['pickup_address'],
            pickup_lat=data['pickup_lat'],
            pickup_lng=data['pickup_lng'],
            dropoff_address=data['dropoff_address'],
            dropoff_lat=data['dropoff_lat'],
            dropoff_lng=data['dropoff_lng'],
            service_date=data['service_date'],
            pickup_time=data['pickup_time'],

            # Passengers & luggage
            num_passengers=data['num_passengers'] + data.get('num_children', 0),
            num_large_luggage=data.get('num_large_luggage', 0),
            num_small_luggage=data.get('num_small_luggage', 0),
            has_children=data.get('num_children', 0) > 0,

            # Vehicle
            selected_vehicle_class=vehicle_class,

            # Flight & requests
            flight_number=flight_number,
            special_requests=data.get('special_requests', ''),

            # Pricing
            pricing_type=data['pricing_type'],
            fixed_route=fixed_route,
            distance_km=data.get('distance_km'),
            base_price=data['base_price'],
            vehicle_class_multiplier=data['vehicle_multiplier'],
            passenger_multiplier=data['passenger_multiplier'],
            seasonal_multiplier=data['seasonal_multiplier'],
            time_multiplier=data['time_multiplier'],
            subtotal=data['subtotal'],
            extra_fees_json=[
                {
                    'fee_code': fee['fee_code'],
                    'fee_name': fee['fee_name'],
                    'fee_type': fee['fee_type'],
                    'quantity': fee['quantity'],
                    'unit_amount': float(fee['unit_amount']),
                    'total_amount': float(fee['total_amount']),
                }
                for fee in data.get('extra_fees', [])
            ],
            extra_fees_total=data.get('extra_fees_total', 0),
            final_price=data['final_price'],

            # Customer
            customer_name=f"{data['customer_first_name']} {data['customer_last_name']}",
            customer_phone=data['customer_phone'],
            customer_email=data['customer_email'],
            customer=request.user if request.user.is_authenticated else None,

            # Status
            status=Booking.Status.PENDING,
            payment_status=Booking.PaymentStatus.UNPAID,
        )

        # Return created booking
        response_serializer = BookingResponseSerializer(booking)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)


class BookingListView(APIView):
    """
    List user's bookings.

    GET /api/bookings/
    """

    permission_classes = [IsAuthenticated]

    def get(self, request):
        bookings = Booking.objects.filter(customer=request.user).order_by('-created_at')
        serializer = BookingListSerializer(bookings, many=True)
        return Response({'data': serializer.data})


class BookingDetailView(APIView):
    """
    Get booking details.

    GET /api/bookings/<id>/
    """

    permission_classes = [IsAuthenticated]

    def get(self, request, booking_id):
        try:
            booking = Booking.objects.get(id=booking_id, customer=request.user)
        except Booking.DoesNotExist:
            return Response(
                {'error': 'Booking not found'},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = BookingDetailSerializer(booking)
        return Response({'data': serializer.data})
