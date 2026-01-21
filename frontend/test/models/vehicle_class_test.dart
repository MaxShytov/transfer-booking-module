import 'package:flutter_test/flutter_test.dart';
import 'package:transfer_booking/data/models/vehicle_class.dart';

void main() {
  group('VehicleClass', () {
    late VehicleClass sedan;
    late VehicleClass minivan;
    late VehicleClass van;

    setUp(() {
      sedan = const VehicleClass(
        id: 1,
        className: 'Sedan',
        classCode: 'sedan',
        description: 'Comfortable sedan',
        exampleVehicles: 'Toyota Camry',
        maxPassengers: 4,
        maxLargeLuggage: 2,
        maxSmallLuggage: 2,
        tierLevel: 1,
        priceMultiplier: 1.0,
        displayOrder: 1,
      );

      minivan = const VehicleClass(
        id: 2,
        className: 'Minivan',
        classCode: 'minivan',
        description: 'Spacious minivan',
        exampleVehicles: 'Toyota Sienna',
        maxPassengers: 6,
        maxLargeLuggage: 4,
        maxSmallLuggage: 4,
        tierLevel: 2,
        priceMultiplier: 1.3,
        displayOrder: 2,
      );

      van = const VehicleClass(
        id: 3,
        className: 'Van',
        classCode: 'van',
        description: 'Large van',
        exampleVehicles: 'Mercedes Sprinter',
        maxPassengers: 8,
        maxLargeLuggage: 6,
        maxSmallLuggage: 6,
        tierLevel: 3,
        priceMultiplier: 1.5,
        displayOrder: 3,
      );
    });

    group('canAccommodate', () {
      test('sedan should accommodate 4 passengers', () {
        expect(sedan.canAccommodate(passengers: 4), isTrue);
        expect(sedan.canAccommodate(passengers: 5), isFalse);
      });

      test('minivan should accommodate 6 passengers (3 adults + 3 children)', () {
        // This is the main bug fix scenario
        expect(minivan.canAccommodate(passengers: 6), isTrue);
        expect(minivan.canAccommodate(passengers: 7), isFalse);
      });

      test('sedan should NOT accommodate 6 passengers', () {
        // 3 adults + 3 children = 6 passengers, sedan max is 4
        expect(sedan.canAccommodate(passengers: 6), isFalse);
      });

      test('should check luggage capacity', () {
        expect(sedan.canAccommodate(passengers: 2, largeLuggage: 2), isTrue);
        expect(sedan.canAccommodate(passengers: 2, largeLuggage: 3), isFalse);
      });

      test('should check both passengers and luggage', () {
        expect(
          minivan.canAccommodate(passengers: 6, largeLuggage: 4),
          isTrue,
        );
        expect(
          minivan.canAccommodate(passengers: 6, largeLuggage: 5),
          isFalse,
        );
        expect(
          minivan.canAccommodate(passengers: 7, largeLuggage: 4),
          isFalse,
        );
      });

      test('should check tier level when specified', () {
        expect(sedan.canAccommodate(passengers: 2, minTier: 1), isTrue);
        expect(sedan.canAccommodate(passengers: 2, minTier: 2), isFalse);
        expect(minivan.canAccommodate(passengers: 2, minTier: 2), isTrue);
      });
    });

    group('vehicle selection for 6 passengers', () {
      test('only vehicles with 6+ seats should be available for 6 passengers', () {
        final vehicles = [sedan, minivan, van];
        const totalPassengers = 6; // 3 adults + 3 children

        final suitableVehicles = vehicles
            .where((v) => v.canAccommodate(passengers: totalPassengers))
            .toList();

        expect(suitableVehicles, hasLength(2));
        expect(suitableVehicles, contains(minivan));
        expect(suitableVehicles, contains(van));
        expect(suitableVehicles, isNot(contains(sedan)));
      });

      test('sedan with 5 seats should not fit 6 passengers', () {
        const sedan5 = VehicleClass(
          id: 1,
          className: 'Sedan',
          classCode: 'sedan5',
          description: 'Sedan with 5 seats',
          exampleVehicles: 'Toyota Camry',
          maxPassengers: 5,
          maxLargeLuggage: 3,
          maxSmallLuggage: 3,
          tierLevel: 1,
          priceMultiplier: 1.0,
          displayOrder: 1,
        );

        expect(sedan5.canAccommodate(passengers: 6), isFalse);
        expect(sedan5.canAccommodate(passengers: 5), isTrue);
      });
    });
  });
}
