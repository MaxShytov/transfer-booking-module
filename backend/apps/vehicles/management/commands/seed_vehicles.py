from django.core.management.base import BaseCommand

from apps.vehicles.models import VehicleClass, VehicleClassRequirement


class Command(BaseCommand):
    help = 'Seed vehicle classes and requirements'

    def handle(self, *args, **options):
        self.stdout.write('Seeding vehicle classes...')

        # Vehicle Classes
        vehicle_classes = [
            {
                'class_name': 'Economy Sedan',
                'class_code': 'economy_sedan',
                'tier_level': 1,
                'price_multiplier': 1.00,
                'max_passengers': 4,
                'max_large_luggage': 2,
                'max_small_luggage': 2,
                'description': 'Comfortable sedan for up to 4 passengers',
                'example_vehicles': 'VW Passat, Toyota Camry, Ford Mondeo, Skoda Superb',
                'display_order': 1,
            },
            {
                'class_name': 'Business Sedan',
                'class_code': 'business_sedan',
                'tier_level': 2,
                'price_multiplier': 1.30,
                'max_passengers': 4,
                'max_large_luggage': 3,
                'max_small_luggage': 2,
                'description': 'Premium sedan with extra comfort and luggage space',
                'example_vehicles': 'Mercedes E-Class, BMW 5 Series, Audi A6',
                'display_order': 2,
            },
            {
                'class_name': 'Luxury Sedan',
                'class_code': 'luxury_sedan',
                'tier_level': 3,
                'price_multiplier': 1.80,
                'max_passengers': 3,
                'max_large_luggage': 2,
                'max_small_luggage': 2,
                'description': 'Top-tier luxury sedan for VIP passengers',
                'example_vehicles': 'Mercedes S-Class, BMW 7 Series, Audi A8, Tesla Model S',
                'display_order': 3,
            },
            {
                'class_name': 'Minivan',
                'class_code': 'minivan',
                'tier_level': 4,
                'price_multiplier': 1.40,
                'max_passengers': 7,
                'max_large_luggage': 5,
                'max_small_luggage': 4,
                'description': 'Spacious minivan for groups and families',
                'example_vehicles': 'Mercedes V-Class, VW Multivan, Ford Transit Custom',
                'display_order': 4,
            },
            {
                'class_name': 'Luxury Minivan',
                'class_code': 'luxury_minivan',
                'tier_level': 5,
                'price_multiplier': 2.20,
                'max_passengers': 7,
                'max_large_luggage': 5,
                'max_small_luggage': 4,
                'description': 'Premium minivan with VIP amenities',
                'example_vehicles': 'Mercedes V-Class VIP, VW Multivan Premium',
                'display_order': 5,
            },
            {
                'class_name': 'Minibus',
                'class_code': 'minibus',
                'tier_level': 6,
                'price_multiplier': 2.50,
                'max_passengers': 16,
                'max_large_luggage': 12,
                'max_small_luggage': 8,
                'description': 'Medium bus for larger groups',
                'example_vehicles': 'Mercedes Sprinter, Ford Transit',
                'display_order': 6,
            },
            {
                'class_name': 'Large Minibus',
                'class_code': 'large_minibus',
                'tier_level': 7,
                'price_multiplier': 3.50,
                'max_passengers': 25,
                'max_large_luggage': 20,
                'max_small_luggage': 15,
                'description': 'Large bus for big groups and events',
                'example_vehicles': 'Mercedes Sprinter Extended, Iveco Daily',
                'display_order': 7,
            },
        ]

        for vc_data in vehicle_classes:
            obj, created = VehicleClass.objects.update_or_create(
                class_code=vc_data['class_code'],
                defaults=vc_data
            )
            status = 'Created' if created else 'Updated'
            self.stdout.write(f'  {status}: {obj.class_name}')

        self.stdout.write(self.style.SUCCESS(f'✓ {len(vehicle_classes)} vehicle classes seeded'))

        # Vehicle Requirements
        self.stdout.write('Seeding vehicle requirements...')

        requirements = [
            # Passenger-based
            {'min_value': 1, 'max_value': 4, 'min_vehicle_tier': 1, 'required_for': 'passengers',
             'validation_message': '1-4 passengers can use Economy Sedan or higher'},
            {'min_value': 5, 'max_value': 7, 'min_vehicle_tier': 4, 'required_for': 'passengers',
             'validation_message': '5-7 passengers require a Minivan or larger'},
            {'min_value': 8, 'max_value': 16, 'min_vehicle_tier': 6, 'required_for': 'passengers',
             'validation_message': '8-16 passengers require a Minibus or larger'},
            {'min_value': 17, 'max_value': 25, 'min_vehicle_tier': 7, 'required_for': 'passengers',
             'validation_message': '17-25 passengers require a Large Minibus'},
            # Luggage-based
            {'min_value': 0, 'max_value': 2, 'min_vehicle_tier': 1, 'required_for': 'luggage',
             'validation_message': '0-2 large bags can fit in Economy Sedan or higher'},
            {'min_value': 3, 'max_value': 5, 'min_vehicle_tier': 4, 'required_for': 'luggage',
             'validation_message': '3-5 large bags require a Minivan or larger'},
            {'min_value': 6, 'max_value': 12, 'min_vehicle_tier': 6, 'required_for': 'luggage',
             'validation_message': '6-12 large bags require a Minibus or larger'},
            {'min_value': 13, 'max_value': 99, 'min_vehicle_tier': 7, 'required_for': 'luggage',
             'validation_message': '13+ large bags require a Large Minibus'},
        ]

        VehicleClassRequirement.objects.all().delete()
        for req_data in requirements:
            VehicleClassRequirement.objects.create(**req_data)

        self.stdout.write(self.style.SUCCESS(f'✓ {len(requirements)} vehicle requirements seeded'))
        self.stdout.write(self.style.SUCCESS('✓ Vehicles seeding complete!'))
