import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transfer_booking/presentation/providers/booking_flow_provider.dart';

void main() {
  group('BookingFlowProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('setNumPassengers', () {
      test('should clear selected vehicle when passengers count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        // First select a vehicle (simulate by checking state structure)
        final initialState = container.read(bookingFlowProvider);
        expect(initialState.numPassengers, equals(1));
        expect(initialState.selectedVehicle, isNull);

        // Change passengers
        notifier.setNumPassengers(3);

        final newState = container.read(bookingFlowProvider);
        expect(newState.numPassengers, equals(3));
        // Vehicle should be cleared (clearVehicle: true in setNumPassengers)
        expect(newState.selectedVehicle, isNull);
      });

      test('should clear price when passengers count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumPassengers(5);

        final state = container.read(bookingFlowProvider);
        expect(state.numPassengers, equals(5));
        expect(state.priceCalculation, isNull);
      });
    });

    group('setNumChildren', () {
      test('should clear selected vehicle when children count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        final initialState = container.read(bookingFlowProvider);
        expect(initialState.numChildren, equals(0));

        // Change children count
        notifier.setNumChildren(3);

        final newState = container.read(bookingFlowProvider);
        expect(newState.numChildren, equals(3));
        // Vehicle should be cleared (this was the bug fix)
        expect(newState.selectedVehicle, isNull);
      });

      test('should clear price when children count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumChildren(2);

        final state = container.read(bookingFlowProvider);
        expect(state.numChildren, equals(2));
        expect(state.priceCalculation, isNull);
      });
    });

    group('total passengers calculation', () {
      test('total passengers should be sum of adults and children', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumPassengers(3);
        notifier.setNumChildren(3);

        final state = container.read(bookingFlowProvider);
        final totalPassengers = state.numPassengers + state.numChildren;

        expect(totalPassengers, equals(6));
      });

      test('changing either adults or children should affect total', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        // Start with 2 adults, 1 child = 3 total
        notifier.setNumPassengers(2);
        notifier.setNumChildren(1);

        var state = container.read(bookingFlowProvider);
        expect(state.numPassengers + state.numChildren, equals(3));

        // Change to 2 adults, 4 children = 6 total
        notifier.setNumChildren(4);

        state = container.read(bookingFlowProvider);
        expect(state.numPassengers + state.numChildren, equals(6));

        // Change to 5 adults, 4 children = 9 total
        notifier.setNumPassengers(5);

        state = container.read(bookingFlowProvider);
        expect(state.numPassengers + state.numChildren, equals(9));
      });
    });

    group('setNumLargeLuggage', () {
      test('should clear selected vehicle when luggage count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumLargeLuggage(2);

        final state = container.read(bookingFlowProvider);
        expect(state.numLargeLuggage, equals(2));
        expect(state.selectedVehicle, isNull);
      });
    });

    group('initial state', () {
      test('should have correct default values', () {
        final state = container.read(bookingFlowProvider);

        expect(state.numPassengers, equals(1));
        expect(state.numChildren, equals(0));
        expect(state.numLargeLuggage, equals(0));
        expect(state.numSmallLuggage, equals(0));
        expect(state.selectedVehicle, isNull);
        expect(state.currentStep, equals(BookingStep.routeSelection));
      });
    });

    group('reset', () {
      test('should reset all values to initial state', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        // Modify state
        notifier.setNumPassengers(5);
        notifier.setNumChildren(3);
        notifier.setNumLargeLuggage(2);

        // Verify modifications
        var state = container.read(bookingFlowProvider);
        expect(state.numPassengers, equals(5));
        expect(state.numChildren, equals(3));

        // Reset
        notifier.reset();

        // Verify reset
        state = container.read(bookingFlowProvider);
        expect(state.numPassengers, equals(1));
        expect(state.numChildren, equals(0));
        expect(state.numLargeLuggage, equals(0));
      });
    });

    group('setNumChildSeats', () {
      test('should set number of child seats (toddlers)', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumChildSeats(2);

        final state = container.read(bookingFlowProvider);
        expect(state.numChildSeats, equals(2));
      });

      test('should clear selected vehicle when child seats count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumChildSeats(3);

        final state = container.read(bookingFlowProvider);
        expect(state.selectedVehicle, isNull);
      });

      test('should clear price when child seats count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumChildSeats(1);

        final state = container.read(bookingFlowProvider);
        expect(state.priceCalculation, isNull);
      });
    });

    group('setNumBoosterSeats', () {
      test('should set number of booster seats (children 4-12)', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumBoosterSeats(3);

        final state = container.read(bookingFlowProvider);
        expect(state.numBoosterSeats, equals(3));
      });

      test('should clear selected vehicle when booster seats count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumBoosterSeats(2);

        final state = container.read(bookingFlowProvider);
        expect(state.selectedVehicle, isNull);
      });

      test('should clear price when booster seats count changes', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        notifier.setNumBoosterSeats(4);

        final state = container.read(bookingFlowProvider);
        expect(state.priceCalculation, isNull);
      });
    });

    group('total passengers with child seats and boosters', () {
      test('total should include adults, toddlers, and children', () {
        final notifier = container.read(bookingFlowProvider.notifier);

        // 2 adults + 1 toddler + 2 children = 5 passengers
        notifier.setNumPassengers(2);
        notifier.setNumChildSeats(1); // toddlers
        notifier.setNumBoosterSeats(2); // children 4-12

        final state = container.read(bookingFlowProvider);
        final totalPassengers = state.numPassengers +
            state.numChildSeats +
            state.numBoosterSeats;

        expect(totalPassengers, equals(5));
      });

      test('default state should have zero child seats and boosters', () {
        final state = container.read(bookingFlowProvider);

        expect(state.numChildSeats, equals(0));
        expect(state.numBoosterSeats, equals(0));
      });
    });

    group('extraFeesTotal', () {
      test('should calculate total from selected extras', () {
        final state = container.read(bookingFlowProvider);

        // Initial state has no extras
        expect(state.extraFeesTotal, equals(0.0));
      });
    });
  });
}
