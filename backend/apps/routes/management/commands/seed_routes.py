from decimal import Decimal

from django.core.management.base import BaseCommand

from apps.routes.models import FixedRoute, DistancePricingRule


class Command(BaseCommand):
    help = 'Seed fixed routes and distance pricing rules for Sardinia'

    def handle(self, *args, **options):
        self.stdout.write('Seeding fixed routes...')

        # Fixed Routes for Sardinia
        routes = [
            {
                'route_name': 'Cagliari Airport → Cagliari City Center',
                'pickup_address': 'Cagliari Elmas Airport (CAG)',
                'pickup_lat': Decimal('39.25146900'),
                'pickup_lng': Decimal('9.05438300'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Cagliari City Center',
                'dropoff_lat': Decimal('39.22384000'),
                'dropoff_lng': Decimal('9.12166000'),
                'dropoff_type': 'city_center',
                'dropoff_radius_km': Decimal('2.00'),
                'base_price': Decimal('35.00'),
                'distance_km': Decimal('10.0'),
            },
            {
                'route_name': 'Cagliari Airport → Villasimius',
                'pickup_address': 'Cagliari Elmas Airport (CAG)',
                'pickup_lat': Decimal('39.25146900'),
                'pickup_lng': Decimal('9.05438300'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Villasimius Town Center',
                'dropoff_lat': Decimal('39.13700000'),
                'dropoff_lng': Decimal('9.51200000'),
                'dropoff_type': 'city_center',
                'dropoff_radius_km': Decimal('3.00'),
                'base_price': Decimal('80.00'),
                'distance_km': Decimal('55.0'),
            },
            {
                'route_name': 'Cagliari Airport → Costa Smeralda',
                'pickup_address': 'Cagliari Elmas Airport (CAG)',
                'pickup_lat': Decimal('39.25146900'),
                'pickup_lng': Decimal('9.05438300'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Porto Cervo, Costa Smeralda',
                'dropoff_lat': Decimal('41.13800000'),
                'dropoff_lng': Decimal('9.53500000'),
                'dropoff_type': 'resort',
                'dropoff_radius_km': Decimal('5.00'),
                'base_price': Decimal('450.00'),
                'distance_km': Decimal('305.5'),
            },
            {
                'route_name': 'Olbia Airport → Porto Cervo',
                'pickup_address': 'Olbia Costa Smeralda Airport (OLB)',
                'pickup_lat': Decimal('40.89860000'),
                'pickup_lng': Decimal('9.51750000'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Porto Cervo, Costa Smeralda',
                'dropoff_lat': Decimal('41.13800000'),
                'dropoff_lng': Decimal('9.53500000'),
                'dropoff_type': 'resort',
                'dropoff_radius_km': Decimal('5.00'),
                'base_price': Decimal('65.00'),
                'distance_km': Decimal('30.0'),
            },
            {
                'route_name': 'Olbia Airport → Palau (Ferry)',
                'pickup_address': 'Olbia Costa Smeralda Airport (OLB)',
                'pickup_lat': Decimal('40.89860000'),
                'pickup_lng': Decimal('9.51750000'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Palau Ferry Terminal',
                'dropoff_lat': Decimal('41.17900000'),
                'dropoff_lng': Decimal('9.38600000'),
                'dropoff_type': 'city_center',
                'dropoff_radius_km': Decimal('2.00'),
                'base_price': Decimal('55.00'),
                'distance_km': Decimal('40.0'),
            },
            {
                'route_name': 'Alghero Airport → Alghero City',
                'pickup_address': 'Alghero-Fertilia Airport (AHO)',
                'pickup_lat': Decimal('40.63210000'),
                'pickup_lng': Decimal('8.29080000'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Alghero City Center',
                'dropoff_lat': Decimal('40.55790000'),
                'dropoff_lng': Decimal('8.31960000'),
                'dropoff_type': 'city_center',
                'dropoff_radius_km': Decimal('2.00'),
                'base_price': Decimal('25.00'),
                'distance_km': Decimal('10.0'),
            },
            {
                'route_name': 'Alghero Airport → Stintino',
                'pickup_address': 'Alghero-Fertilia Airport (AHO)',
                'pickup_lat': Decimal('40.63210000'),
                'pickup_lng': Decimal('8.29080000'),
                'pickup_type': 'airport',
                'pickup_radius_km': Decimal('5.00'),
                'dropoff_address': 'Stintino',
                'dropoff_lat': Decimal('40.93550000'),
                'dropoff_lng': Decimal('8.22890000'),
                'dropoff_type': 'city_center',
                'dropoff_radius_km': Decimal('3.00'),
                'base_price': Decimal('75.00'),
                'distance_km': Decimal('55.0'),
            },
        ]

        for route_data in routes:
            obj, created = FixedRoute.objects.update_or_create(
                route_name=route_data['route_name'],
                defaults=route_data
            )
            status = 'Created' if created else 'Updated'
            self.stdout.write(f'  {status}: {obj.route_name}')

        self.stdout.write(self.style.SUCCESS(f'✓ {len(routes)} fixed routes seeded'))

        # Distance Pricing Rules
        self.stdout.write('Seeding distance pricing rules...')

        rules = [
            {
                'rule_name': 'Short trips (0-30km)',
                'base_rate': Decimal('40.00'),
                'price_per_km': Decimal('2.00'),
                'min_distance_km': 0,
                'max_distance_km': 30,
                'priority': 1,
            },
            {
                'rule_name': 'Medium trips (31-100km)',
                'base_rate': Decimal('50.00'),
                'price_per_km': Decimal('1.50'),
                'min_distance_km': 31,
                'max_distance_km': 100,
                'priority': 2,
            },
            {
                'rule_name': 'Long trips (101-200km)',
                'base_rate': Decimal('60.00'),
                'price_per_km': Decimal('1.20'),
                'min_distance_km': 101,
                'max_distance_km': 200,
                'priority': 3,
            },
            {
                'rule_name': 'Extra long trips (201+km)',
                'base_rate': Decimal('80.00'),
                'price_per_km': Decimal('1.00'),
                'min_distance_km': 201,
                'max_distance_km': 9999,
                'priority': 4,
            },
        ]

        for rule_data in rules:
            obj, created = DistancePricingRule.objects.update_or_create(
                rule_name=rule_data['rule_name'],
                defaults=rule_data
            )
            status = 'Created' if created else 'Updated'
            self.stdout.write(f'  {status}: {obj.rule_name}')

        self.stdout.write(self.style.SUCCESS(f'✓ {len(rules)} distance pricing rules seeded'))
        self.stdout.write(self.style.SUCCESS('✓ Routes seeding complete!'))
