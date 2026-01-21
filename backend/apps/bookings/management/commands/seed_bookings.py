"""
Seed command for generating realistic booking data for a Sardinia transfer company.

Company profile:
- 12 own vehicles, 7 partner vehicles (19 total)
- 8 staff drivers
- High season (Jun-Sep): ~120 transfers/month
- Low season (Nov-Mar): ~62 transfers/month
- Vehicle classes: roughly equal distribution
- Only operates in Sardinia
"""

import random
from datetime import date, time, datetime, timedelta
from decimal import Decimal

from django.core.management.base import BaseCommand
from django.utils import timezone

from apps.bookings.models import Booking
from apps.vehicles.models import VehicleClass
from apps.routes.models import FixedRoute


class Command(BaseCommand):
    help = 'Seed realistic booking data for Sardinia transfer company (1 year)'

    def add_arguments(self, parser):
        parser.add_argument(
            '--year',
            type=int,
            default=2025,
            help='Year for booking data (default: 2025)'
        )
        parser.add_argument(
            '--clear',
            action='store_true',
            help='Clear existing bookings before seeding'
        )

    def handle(self, *args, **options):
        year = options['year']

        if options['clear']:
            deleted, _ = Booking.objects.all().delete()
            self.stdout.write(f'Cleared {deleted} existing bookings')

        self.stdout.write(f'Seeding bookings for year {year}...')

        # Load vehicle classes
        vehicle_classes = list(VehicleClass.objects.filter(is_active=True).order_by('tier_level'))
        if not vehicle_classes:
            self.stdout.write(self.style.ERROR('No vehicle classes found. Run seed_vehicles first.'))
            return

        # Load fixed routes
        fixed_routes = list(FixedRoute.objects.filter(is_active=True))
        if not fixed_routes:
            self.stdout.write(self.style.ERROR('No fixed routes found. Run seed_routes first.'))
            return

        # Define monthly booking targets based on seasonality
        # High season: June-September (~120/month)
        # Shoulder season: April-May, October (~90/month)
        # Low season: November-March (~62/month)
        monthly_targets = {
            1: 58,   # January - very low
            2: 52,   # February - lowest
            3: 65,   # March - starting to pick up
            4: 88,   # April - shoulder season starts
            5: 95,   # May - shoulder season
            6: 115,  # June - high season starts
            7: 135,  # July - peak season
            8: 145,  # August - peak (Ferragosto!)
            9: 110,  # September - high season ending
            10: 85,  # October - shoulder season
            11: 60,  # November - low season
            12: 55,  # December - low season (holidays)
        }

        # Customer name pools (Italian, German, British, French tourists)
        first_names_male = [
            'Marco', 'Luca', 'Alessandro', 'Giuseppe', 'Giovanni', 'Francesco',
            'Hans', 'Klaus', 'Wolfgang', 'Thomas', 'Michael', 'Andreas',
            'John', 'James', 'David', 'Peter', 'Robert', 'William',
            'Jean', 'Pierre', 'François', 'Philippe', 'Michel', 'Laurent',
            'Carlos', 'Miguel', 'Antonio', 'Pablo', 'Luis', 'Fernando',
        ]
        first_names_female = [
            'Maria', 'Giulia', 'Francesca', 'Sara', 'Anna', 'Chiara',
            'Sabine', 'Heike', 'Claudia', 'Monika', 'Petra', 'Ursula',
            'Sarah', 'Emma', 'Charlotte', 'Sophie', 'Emily', 'Jessica',
            'Marie', 'Isabelle', 'Nathalie', 'Sophie', 'Camille', 'Julie',
            'Carmen', 'Isabel', 'Lucia', 'Elena', 'Rosa', 'Ana',
        ]
        last_names = [
            'Rossi', 'Russo', 'Ferrari', 'Esposito', 'Bianchi', 'Romano',
            'Müller', 'Schmidt', 'Schneider', 'Fischer', 'Weber', 'Meyer',
            'Smith', 'Jones', 'Williams', 'Brown', 'Taylor', 'Wilson',
            'Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard',
            'García', 'Rodríguez', 'Martínez', 'López', 'Hernández', 'González',
            'De Vries', 'Van den Berg', 'Janssen', 'Bakker', 'Visser', 'Smit',
        ]

        # Email domains
        email_domains = [
            'gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com',
            'icloud.com', 'web.de', 't-online.de', 'gmx.de',
            'orange.fr', 'free.fr', 'laposte.net',
            'libero.it', 'virgilio.it', 'tiscali.it',
        ]

        # Phone prefixes by country
        phone_prefixes = [
            '+39 3',    # Italy
            '+49 15',   # Germany mobile
            '+49 17',   # Germany mobile
            '+44 7',    # UK mobile
            '+33 6',    # France mobile
            '+33 7',    # France mobile
            '+34 6',    # Spain mobile
            '+31 6',    # Netherlands mobile
            '+41 7',    # Switzerland mobile
        ]

        # Flight number patterns (major airlines to Sardinia)
        airlines = [
            ('FR', 'Ryanair'),
            ('U2', 'EasyJet'),
            ('W6', 'Wizz Air'),
            ('AZ', 'ITA Airways'),
            ('LH', 'Lufthansa'),
            ('BA', 'British Airways'),
            ('AF', 'Air France'),
            ('VY', 'Vueling'),
            ('IB', 'Iberia'),
            ('KL', 'KLM'),
        ]

        # Special requests pool
        special_requests = [
            '',  # Most bookings have no special requests
            '',
            '',
            '',
            '',
            'Please have a name sign at arrival',
            'Need space for golf bags',
            'Wheelchair accessible vehicle needed',
            'Baby on board - please drive carefully',
            'Meeting in arrivals hall',
            'Multiple stops needed',
            'Early morning flight - be on time please',
            'Large group - may need 2 vehicles',
            'VIP client - premium service required',
            'Elderly passengers - assistance needed',
            'Late arrival possible, will update',
        ]

        # Status distribution (for historical data)
        # Most past bookings should be completed
        def get_status_for_date(booking_date):
            today = date.today()
            if booking_date < today - timedelta(days=7):
                # Past bookings
                r = random.random()
                if r < 0.85:
                    return Booking.Status.COMPLETED
                elif r < 0.92:
                    return Booking.Status.CANCELLED
                else:
                    return Booking.Status.COMPLETED  # even more completed
            elif booking_date < today:
                # Recent past
                r = random.random()
                if r < 0.80:
                    return Booking.Status.COMPLETED
                elif r < 0.90:
                    return Booking.Status.CANCELLED
                else:
                    return Booking.Status.CONFIRMED
            elif booking_date <= today + timedelta(days=3):
                # Near future
                return Booking.Status.CONFIRMED
            else:
                # Future bookings
                r = random.random()
                if r < 0.85:
                    return Booking.Status.CONFIRMED
                else:
                    return Booking.Status.PENDING

        def get_payment_status(booking_status):
            if booking_status == Booking.Status.COMPLETED:
                return Booking.PaymentStatus.FULLY_PAID
            elif booking_status == Booking.Status.CANCELLED:
                r = random.random()
                if r < 0.3:
                    return Booking.PaymentStatus.REFUNDED
                else:
                    return Booking.PaymentStatus.UNPAID
            elif booking_status == Booking.Status.CONFIRMED:
                r = random.random()
                if r < 0.6:
                    return Booking.PaymentStatus.DEPOSIT_PAID
                elif r < 0.85:
                    return Booking.PaymentStatus.FULLY_PAID
                else:
                    return Booking.PaymentStatus.UNPAID
            else:
                return Booking.PaymentStatus.UNPAID

        # Seasonal multipliers
        def get_seasonal_multiplier(booking_date):
            month = booking_date.month
            day = booking_date.day
            # Ferragosto special (Aug 10-20)
            if month == 8 and 10 <= day <= 20:
                return Decimal('1.40')
            # High summer
            if month in [7, 8]:
                return Decimal('1.30')
            # Early summer / late summer
            if month in [6, 9]:
                return Decimal('1.20')
            # Shoulder season
            if month in [4, 5, 10]:
                return Decimal('1.10')
            # Christmas/New Year
            if month == 12 and day >= 20:
                return Decimal('1.15')
            if month == 1 and day <= 6:
                return Decimal('1.15')
            # Low season
            return Decimal('1.00')

        def get_time_multiplier(pickup_time):
            hour = pickup_time.hour
            # Night rate (22:00 - 06:00)
            if hour >= 22 or hour < 6:
                return Decimal('1.20')
            # Early morning (06:00 - 07:00)
            if 6 <= hour < 7:
                return Decimal('1.10')
            return Decimal('1.00')

        # Generate bookings
        total_created = 0
        used_references = set(
            Booking.objects.values_list('booking_reference', flat=True)
        )

        for month in range(1, 13):
            target = monthly_targets[month]
            # Add some variance (+/- 15%)
            actual_count = int(target * random.uniform(0.85, 1.15))

            self.stdout.write(f'  Month {month:02d}: generating {actual_count} bookings...')

            for _ in range(actual_count):
                # Random day in month
                if month in [1, 3, 5, 7, 8, 10, 12]:
                    max_day = 31
                elif month in [4, 6, 9, 11]:
                    max_day = 30
                else:
                    max_day = 28 if year % 4 != 0 else 29

                day = random.randint(1, max_day)
                service_date = date(year, month, day)

                # Pickup time - biased towards flight arrival times
                # Morning: 06:00-12:00 (40%)
                # Afternoon: 12:00-18:00 (35%)
                # Evening: 18:00-23:00 (20%)
                # Night: 00:00-06:00 (5%)
                time_roll = random.random()
                if time_roll < 0.40:
                    hour = random.randint(6, 11)
                elif time_roll < 0.75:
                    hour = random.randint(12, 17)
                elif time_roll < 0.95:
                    hour = random.randint(18, 22)
                else:
                    hour = random.choice([0, 1, 2, 3, 4, 5, 23])

                minute = random.choice([0, 15, 30, 45])
                pickup_time = time(hour, minute)

                # Select route (80% fixed route, 20% custom)
                if random.random() < 0.80:
                    route = random.choice(fixed_routes)
                    pricing_type = Booking.PricingType.FIXED_ROUTE
                    pickup_address = route.pickup_address
                    pickup_lat = route.pickup_lat
                    pickup_lng = route.pickup_lng
                    dropoff_address = route.dropoff_address
                    dropoff_lat = route.dropoff_lat
                    dropoff_lng = route.dropoff_lng
                    base_price = route.base_price
                    distance_km = route.distance_km
                    fixed_route_obj = route
                else:
                    # Custom route within Sardinia
                    pricing_type = Booking.PricingType.DISTANCE_BASED
                    custom_locations = [
                        ('Porto Torres Ferry Terminal', Decimal('40.83750'), Decimal('8.40280')),
                        ('Golfo Aranci Ferry Terminal', Decimal('40.98270'), Decimal('9.62170')),
                        ('Arbatax Port', Decimal('39.93610'), Decimal('9.70670')),
                        ('Sassari City Center', Decimal('40.72670'), Decimal('8.55940')),
                        ('Nuoro City Center', Decimal('40.32170'), Decimal('9.33110')),
                        ('Oristano City Center', Decimal('39.90280'), Decimal('8.59110')),
                        ('Chia Beach Resort', Decimal('38.89170'), Decimal('8.88610')),
                        ('Pula Beach', Decimal('38.97280'), Decimal('8.99780')),
                        ('Bosa Marina', Decimal('40.29170'), Decimal('8.49440')),
                        ('San Teodoro', Decimal('40.76940'), Decimal('9.67110')),
                        ('Castelsardo', Decimal('40.91390'), Decimal('8.71330')),
                        ('La Maddalena', Decimal('41.21280'), Decimal('9.40720')),
                        ('Santa Teresa Gallura', Decimal('41.24170'), Decimal('9.18780')),
                        ('Tortolì', Decimal('39.92780'), Decimal('9.65670')),
                        ('Carbonia', Decimal('39.16670'), Decimal('8.52220')),
                    ]
                    # Pick airport as pickup
                    airports = [r for r in fixed_routes if 'Airport' in r.pickup_address]
                    if airports:
                        airport = random.choice(airports)
                        pickup_address = airport.pickup_address
                        pickup_lat = airport.pickup_lat
                        pickup_lng = airport.pickup_lng
                    else:
                        pickup_address, pickup_lat, pickup_lng = random.choice(custom_locations)

                    dropoff_address, dropoff_lat, dropoff_lng = random.choice(custom_locations)

                    # Estimate distance and price
                    distance_km = Decimal(str(random.randint(20, 180)))
                    if distance_km <= 30:
                        base_price = Decimal('40.00') + distance_km * Decimal('2.00')
                    elif distance_km <= 100:
                        base_price = Decimal('50.00') + distance_km * Decimal('1.50')
                    else:
                        base_price = Decimal('60.00') + distance_km * Decimal('1.20')
                    fixed_route_obj = None

                # Passengers (weighted towards 2-3)
                pax_roll = random.random()
                if pax_roll < 0.15:
                    num_passengers = 1
                elif pax_roll < 0.50:
                    num_passengers = 2
                elif pax_roll < 0.75:
                    num_passengers = 3
                elif pax_roll < 0.88:
                    num_passengers = 4
                elif pax_roll < 0.95:
                    num_passengers = random.randint(5, 6)
                else:
                    num_passengers = random.randint(7, 8)

                # Children (25% of bookings have children, only if more than 1 passenger)
                has_children = random.random() < 0.25 and num_passengers > 1
                children_ages = []
                if has_children:
                    max_children = min(3, num_passengers - 1)
                    num_children = random.randint(1, max(1, max_children))
                    children_ages = [random.randint(0, 12) for _ in range(num_children)]

                # Luggage
                num_large_luggage = min(num_passengers, random.randint(0, num_passengers + 1))
                num_small_luggage = random.randint(0, num_passengers)

                # Vehicle class selection based on passengers
                suitable_classes = [vc for vc in vehicle_classes if vc.max_passengers >= num_passengers]
                if not suitable_classes:
                    suitable_classes = [vehicle_classes[-1]]  # Largest available

                # Weighted selection (slight preference for economy/business for small groups)
                if num_passengers <= 3:
                    weights = [3 if vc.tier_level <= 2 else 2 if vc.tier_level <= 4 else 1
                               for vc in suitable_classes]
                else:
                    weights = [1 for _ in suitable_classes]

                vehicle_class = random.choices(suitable_classes, weights=weights)[0]

                # Round trip (30% are round trips)
                is_round_trip = random.random() < 0.30
                return_date = None
                return_time_val = None
                return_flight_number = ''
                if is_round_trip:
                    # Return 3-14 days later
                    return_days = random.randint(3, 14)
                    return_date = service_date + timedelta(days=return_days)
                    return_hour = random.randint(6, 20)
                    return_time_val = time(return_hour, random.choice([0, 15, 30, 45]))
                    if random.random() < 0.7:
                        airline_code, _ = random.choice(airlines)
                        return_flight_number = f'{airline_code}{random.randint(100, 9999)}'

                # Calculate multipliers
                seasonal_mult = get_seasonal_multiplier(service_date)
                time_mult = get_time_multiplier(pickup_time)
                vehicle_mult = vehicle_class.price_multiplier
                passenger_mult = Decimal('1.00')
                if num_passengers > 5:
                    passenger_mult = Decimal('1.10')

                # Calculate prices
                subtotal = base_price * seasonal_mult * vehicle_mult * passenger_mult * time_mult
                subtotal = subtotal.quantize(Decimal('0.01'))

                # Extra fees (child seats, etc.)
                extra_fees_json = []
                extra_fees_total = Decimal('0.00')

                if has_children:
                    for child_age in children_ages:
                        if child_age <= 4:
                            fee = {
                                'fee_code': 'CHILD_SEAT',
                                'fee_name': 'Child Seat (0-4 years)',
                                'fee_type': 'flat',
                                'quantity': 1,
                                'unit_amount': '10.00',
                                'total_amount': '10.00'
                            }
                            extra_fees_json.append(fee)
                            extra_fees_total += Decimal('10.00')
                        elif child_age <= 12:
                            fee = {
                                'fee_code': 'BOOSTER_SEAT',
                                'fee_name': 'Booster Seat (4-12 years)',
                                'fee_type': 'flat',
                                'quantity': 1,
                                'unit_amount': '5.00',
                                'total_amount': '5.00'
                            }
                            extra_fees_json.append(fee)
                            extra_fees_total += Decimal('5.00')

                # Round trip discount
                round_trip_mult = Decimal('1.00')
                if is_round_trip:
                    round_trip_mult = Decimal('0.90')  # 10% discount
                    subtotal_with_return = subtotal * 2 * round_trip_mult
                    subtotal = subtotal_with_return.quantize(Decimal('0.01'))

                final_price = subtotal + extra_fees_total

                # Customer info
                is_male = random.random() < 0.55
                first_name = random.choice(first_names_male if is_male else first_names_female)
                last_name = random.choice(last_names)
                customer_name = f'{first_name} {last_name}'

                email_base = f'{first_name.lower()}.{last_name.lower()}'
                # Add number sometimes
                if random.random() < 0.3:
                    email_base += str(random.randint(1, 99))
                customer_email = f'{email_base}@{random.choice(email_domains)}'

                phone_prefix = random.choice(phone_prefixes)
                phone_number = ''.join([str(random.randint(0, 9)) for _ in range(8)])
                customer_phone = f'{phone_prefix}{phone_number}'

                # Flight number (70% have flight info for airport pickups)
                flight_number = ''
                if 'Airport' in pickup_address and random.random() < 0.70:
                    airline_code, _ = random.choice(airlines)
                    flight_number = f'{airline_code}{random.randint(100, 9999)}'

                # Status and payment
                status = get_status_for_date(service_date)
                payment_status = get_payment_status(status)

                # Generate unique booking reference
                ref_year = service_date.year
                while True:
                    ref_num = random.randint(1000, 9999)
                    booking_reference = f'SAT-{ref_year}-{ref_num:04d}'
                    if booking_reference not in used_references:
                        used_references.add(booking_reference)
                        break

                # Timestamps
                # Booking was made 1-60 days before service date
                days_before = random.randint(1, 60)
                created_at = datetime.combine(
                    service_date - timedelta(days=days_before),
                    time(random.randint(8, 22), random.randint(0, 59))
                )
                created_at = timezone.make_aware(created_at)

                confirmed_at = None
                completed_at = None

                if status in [Booking.Status.CONFIRMED, Booking.Status.COMPLETED, Booking.Status.IN_PROGRESS]:
                    # Confirmed within 24 hours of booking
                    confirmed_at = created_at + timedelta(hours=random.randint(1, 24))

                if status == Booking.Status.COMPLETED:
                    # Completed on service date
                    service_datetime = datetime.combine(service_date, pickup_time)
                    duration_hours = float(distance_km or 30) / 50  # ~50 km/h average
                    completed_at = timezone.make_aware(
                        service_datetime + timedelta(hours=duration_hours + 0.5)
                    )

                # Create booking
                booking = Booking(
                    booking_reference=booking_reference,
                    pickup_address=pickup_address,
                    pickup_lat=pickup_lat,
                    pickup_lng=pickup_lng,
                    dropoff_address=dropoff_address,
                    dropoff_lat=dropoff_lat,
                    dropoff_lng=dropoff_lng,
                    service_date=service_date,
                    pickup_time=pickup_time,
                    is_round_trip=is_round_trip,
                    return_date=return_date,
                    return_time=return_time_val,
                    return_flight_number=return_flight_number,
                    num_passengers=num_passengers,
                    num_large_luggage=num_large_luggage,
                    num_small_luggage=num_small_luggage,
                    has_children=has_children,
                    children_ages=children_ages,
                    selected_vehicle_class=vehicle_class,
                    flight_number=flight_number,
                    special_requests=random.choice(special_requests),
                    pricing_type=pricing_type,
                    fixed_route=fixed_route_obj,
                    distance_km=distance_km,
                    base_price=base_price,
                    seasonal_multiplier=seasonal_mult,
                    vehicle_class_multiplier=vehicle_mult,
                    passenger_multiplier=passenger_mult,
                    time_multiplier=time_mult,
                    subtotal=subtotal,
                    extra_fees_json=extra_fees_json,
                    extra_fees_total=extra_fees_total,
                    final_price=final_price,
                    currency='EUR',
                    customer_name=customer_name,
                    customer_email=customer_email,
                    customer_phone=customer_phone,
                    status=status,
                    payment_status=payment_status,
                    confirmed_at=confirmed_at,
                    completed_at=completed_at,
                )
                booking.save()
                # Update created_at (auto_now_add override)
                Booking.objects.filter(pk=booking.pk).update(created_at=created_at)

                total_created += 1

        # Summary statistics
        self.stdout.write('')
        self.stdout.write(self.style.SUCCESS(f'✓ Created {total_created} bookings for year {year}'))

        # Print statistics
        self.stdout.write('')
        self.stdout.write('Statistics:')

        from django.db.models import Count, Sum, Avg

        stats = Booking.objects.filter(service_date__year=year).aggregate(
            total=Count('id'),
            revenue=Sum('final_price'),
            avg_price=Avg('final_price'),
        )
        self.stdout.write(f'  Total bookings: {stats["total"]}')
        self.stdout.write(f'  Total revenue: €{stats["revenue"]:,.2f}')
        self.stdout.write(f'  Average price: €{stats["avg_price"]:,.2f}')

        # By status
        status_counts = Booking.objects.filter(
            service_date__year=year
        ).values('status').annotate(count=Count('id'))
        self.stdout.write('  By status:')
        for s in status_counts:
            self.stdout.write(f'    - {s["status"]}: {s["count"]}')

        # By vehicle class
        class_counts = Booking.objects.filter(
            service_date__year=year
        ).values('selected_vehicle_class__class_name').annotate(count=Count('id'))
        self.stdout.write('  By vehicle class:')
        for c in class_counts:
            self.stdout.write(f'    - {c["selected_vehicle_class__class_name"]}: {c["count"]}')

        # Round trips
        round_trips = Booking.objects.filter(
            service_date__year=year, is_round_trip=True
        ).count()
        self.stdout.write(f'  Round trips: {round_trips} ({round_trips*100/stats["total"]:.1f}%)')

        self.stdout.write('')
        self.stdout.write(self.style.SUCCESS('✓ Booking seed complete!'))
