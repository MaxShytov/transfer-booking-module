from decimal import Decimal
from datetime import date, time

from django.core.management.base import BaseCommand

from apps.pricing.models import (
    SeasonalMultiplier,
    PassengerMultiplier,
    TimeMultiplier,
    ExtraFee,
    RoundTripDiscount
)
from apps.vehicles.models import VehicleClass


class Command(BaseCommand):
    help = 'Seed pricing multipliers and extra fees'

    def handle(self, *args, **options):
        self.seed_seasonal_multipliers()
        self.seed_passenger_multipliers()
        self.seed_time_multipliers()
        self.seed_extra_fees()
        self.seed_round_trip_discount()
        self.stdout.write(self.style.SUCCESS('✓ Pricing seeding complete!'))

    def seed_seasonal_multipliers(self):
        self.stdout.write('Seeding seasonal multipliers...')

        seasons = [
            {
                'season_name': 'Low Season',
                'start_date': date(2026, 11, 1),
                'end_date': date(2026, 3, 31),
                'multiplier': Decimal('1.00'),
                'priority': 10,
                'description': 'Base pricing - winter months',
            },
            {
                'season_name': 'Shoulder Season (Spring)',
                'start_date': date(2026, 4, 1),
                'end_date': date(2026, 6, 14),
                'multiplier': Decimal('1.15'),
                'priority': 5,
                'description': 'Good weather, fewer tourists',
            },
            {
                'season_name': 'High Summer',
                'start_date': date(2026, 6, 15),
                'end_date': date(2026, 9, 15),
                'multiplier': Decimal('1.30'),
                'priority': 3,
                'description': 'Peak tourist season in Sardinia',
            },
            {
                'season_name': 'Shoulder Season (Fall)',
                'start_date': date(2026, 9, 16),
                'end_date': date(2026, 10, 31),
                'multiplier': Decimal('1.15'),
                'priority': 5,
                'description': 'Post-summer, still pleasant weather',
            },
            {
                'season_name': 'Ferragosto',
                'start_date': date(2026, 8, 10),
                'end_date': date(2026, 8, 20),
                'multiplier': Decimal('1.40'),
                'priority': 1,
                'description': 'Italian national holiday - peak demand',
            },
            {
                'season_name': 'Christmas/New Year',
                'start_date': date(2026, 12, 20),
                'end_date': date(2026, 1, 5),
                'multiplier': Decimal('1.25'),
                'priority': 2,
                'description': 'Holiday premium',
            },
        ]

        for s_data in seasons:
            obj, created = SeasonalMultiplier.objects.update_or_create(
                season_name=s_data['season_name'],
                defaults=s_data
            )
            status = 'Created' if created else 'Updated'
            self.stdout.write(f'  {status}: {obj.season_name}')

        self.stdout.write(self.style.SUCCESS(f'✓ {len(seasons)} seasonal multipliers seeded'))

    def seed_passenger_multipliers(self):
        self.stdout.write('Seeding passenger multipliers per vehicle class...')

        # Clear existing multipliers
        PassengerMultiplier.objects.all().delete()

        # Define multipliers per vehicle class
        # Format: class_code -> list of (min_pax, max_pax, multiplier, description)
        multipliers_by_class = {
            'economy_sedan': [
                # max 4 passengers
                (1, 3, Decimal('1.00'), 'Comfortable - base rate'),
                (4, 4, Decimal('1.05'), 'Full capacity'),
            ],
            'business_sedan': [
                # max 4 passengers
                (1, 3, Decimal('1.00'), 'Comfortable - base rate'),
                (4, 4, Decimal('1.05'), 'Full capacity'),
            ],
            'luxury_sedan': [
                # max 3 passengers
                (1, 2, Decimal('1.00'), 'Comfortable - base rate'),
                (3, 3, Decimal('1.05'), 'Full capacity'),
            ],
            'minivan': [
                # max 7 passengers
                (1, 5, Decimal('1.00'), 'Comfortable - base rate'),
                (6, 7, Decimal('1.10'), 'Full capacity'),
            ],
            'luxury_minivan': [
                # max 7 passengers
                (1, 5, Decimal('1.00'), 'Comfortable - base rate'),
                (6, 7, Decimal('1.10'), 'Full capacity'),
            ],
            'minibus': [
                # max 16 passengers
                (1, 10, Decimal('1.00'), 'Comfortable - base rate'),
                (11, 14, Decimal('1.10'), 'Near capacity'),
                (15, 16, Decimal('1.15'), 'Full capacity'),
            ],
            'large_minibus': [
                # max 25 passengers
                (1, 16, Decimal('1.00'), 'Comfortable - base rate'),
                (17, 22, Decimal('1.10'), 'Near capacity'),
                (23, 25, Decimal('1.15'), 'Full capacity'),
            ],
        }

        count = 0
        for class_code, ranges in multipliers_by_class.items():
            try:
                vehicle_class = VehicleClass.objects.get(class_code=class_code)
                for min_pax, max_pax, multiplier, description in ranges:
                    PassengerMultiplier.objects.create(
                        vehicle_class=vehicle_class,
                        min_passengers=min_pax,
                        max_passengers=max_pax,
                        multiplier=multiplier,
                        description=description,
                        display_order=min_pax,
                    )
                    count += 1
                self.stdout.write(f'  {vehicle_class.class_name}: {len(ranges)} ranges')
            except VehicleClass.DoesNotExist:
                self.stdout.write(
                    self.style.WARNING(f'  Vehicle class {class_code} not found, skipping')
                )

        self.stdout.write(self.style.SUCCESS(f'✓ {count} passenger multipliers seeded'))

    def seed_time_multipliers(self):
        self.stdout.write('Seeding time multipliers...')

        multipliers = [
            {
                'time_name': 'Standard Hours',
                'start_time': time(6, 0),
                'end_time': time(22, 0),
                'multiplier': Decimal('1.00'),
                'description': 'Normal business hours',
            },
            {
                'time_name': 'Late Night',
                'start_time': time(22, 0),
                'end_time': time(6, 0),
                'multiplier': Decimal('1.20'),
                'description': 'Night transfer premium',
            },
        ]

        TimeMultiplier.objects.all().delete()
        for m_data in multipliers:
            TimeMultiplier.objects.create(**m_data)

        self.stdout.write(self.style.SUCCESS(f'✓ {len(multipliers)} time multipliers seeded'))

    def seed_extra_fees(self):
        self.stdout.write('Seeding extra fees...')

        fees = [
            {
                'fee_name': 'Child Seat (0-4 years)',
                'fee_code': 'child_seat',
                'fee_type': 'flat',
                'amount': Decimal('10.00'),
                'is_optional': True,
                'display_order': 1,
                'description': 'Rear-facing or forward-facing child seat',
            },
            {
                'fee_name': 'Booster Seat (4-12 years)',
                'fee_code': 'booster_seat',
                'fee_type': 'flat',
                'amount': Decimal('5.00'),
                'is_optional': True,
                'display_order': 2,
                'description': 'Booster cushion for older children',
            },
            {
                'fee_name': 'Extra Large Luggage',
                'fee_code': 'extra_luggage',
                'fee_type': 'per_item',
                'amount': Decimal('15.00'),
                'is_optional': True,
                'display_order': 3,
                'description': 'Bags over 30kg',
            },
            {
                'fee_name': 'Surfboard/Bike Transport',
                'fee_code': 'sports_equipment',
                'fee_type': 'per_item',
                'amount': Decimal('25.00'),
                'is_optional': True,
                'display_order': 4,
                'description': 'Surfboards, bikes, golf clubs',
            },
            {
                'fee_name': 'Pet Transport (Small)',
                'fee_code': 'pet_small',
                'fee_type': 'flat',
                'amount': Decimal('20.00'),
                'is_optional': True,
                'display_order': 5,
                'description': 'Small pets in carrier',
            },
            {
                'fee_name': 'Pet Transport (Large)',
                'fee_code': 'pet_large',
                'fee_type': 'flat',
                'amount': Decimal('35.00'),
                'is_optional': True,
                'display_order': 6,
                'description': 'Large dogs',
            },
            {
                'fee_name': 'Meet & Greet Premium',
                'fee_code': 'meet_greet',
                'fee_type': 'flat',
                'amount': Decimal('20.00'),
                'is_optional': True,
                'display_order': 7,
                'description': 'Driver meets inside terminal with name sign',
            },
            {
                'fee_name': 'Waiting Time',
                'fee_code': 'waiting_time',
                'fee_type': 'per_item',
                'amount': Decimal('30.00'),
                'is_optional': False,
                'display_order': 8,
                'description': 'Per hour after free 15 minutes',
            },
            {
                'fee_name': 'Additional Stop',
                'fee_code': 'additional_stop',
                'fee_type': 'per_item',
                'amount': Decimal('15.00'),
                'is_optional': True,
                'display_order': 9,
                'description': 'Extra stop along the route',
            },
        ]

        for fee_data in fees:
            obj, created = ExtraFee.objects.update_or_create(
                fee_code=fee_data['fee_code'],
                defaults=fee_data
            )
            status = 'Created' if created else 'Updated'
            self.stdout.write(f'  {status}: {obj.fee_name}')

        self.stdout.write(self.style.SUCCESS(f'✓ {len(fees)} extra fees seeded'))

    def seed_round_trip_discount(self):
        self.stdout.write('Seeding round trip discount...')

        obj, created = RoundTripDiscount.objects.update_or_create(
            name='Round Trip Discount',
            defaults={
                'multiplier': Decimal('0.90'),
                'description': 'Save 10% when booking a round trip (туда-обратно)',
                'is_active': True,
            }
        )
        status = 'Created' if created else 'Updated'
        self.stdout.write(f'  {status}: {obj.name} ({obj.multiplier})')
        self.stdout.write(self.style.SUCCESS('✓ Round trip discount seeded'))
