import 'package:flutter_test/flutter_test.dart';
import 'package:transfer_booking/data/models/extra_fee.dart';

void main() {
  group('ExtraFee', () {
    group('calculateFee', () {
      test('flat fee should multiply by quantity', () {
        const fee = ExtraFee(
          id: 1,
          feeName: 'Child Seat',
          feeCode: 'child_seat',
          feeType: FeeType.flat,
          amount: 15.0,
          isOptional: true,
          displayOrder: 1,
          description: 'Child seat for toddlers',
        );

        // Single quantity
        expect(fee.calculateFee(quantity: 1), equals(15.0));

        // Multiple quantities - this was the bug fix
        expect(fee.calculateFee(quantity: 2), equals(30.0));
        expect(fee.calculateFee(quantity: 3), equals(45.0));
      });

      test('perItem fee should multiply by quantity', () {
        const fee = ExtraFee(
          id: 2,
          feeName: 'Booster Seat',
          feeCode: 'booster_seat',
          feeType: FeeType.perItem,
          amount: 10.0,
          isOptional: true,
          displayOrder: 2,
          description: 'Booster seat for children',
        );

        expect(fee.calculateFee(quantity: 1), equals(10.0));
        expect(fee.calculateFee(quantity: 2), equals(20.0));
        expect(fee.calculateFee(quantity: 5), equals(50.0));
      });

      test('percentage fee should calculate based on basePrice', () {
        const fee = ExtraFee(
          id: 3,
          feeName: 'Service Fee',
          feeCode: 'service_fee',
          feeType: FeeType.percentage,
          amount: 10.0, // 10%
          isOptional: false,
          displayOrder: 3,
          description: 'Service fee',
        );

        expect(fee.calculateFee(basePrice: 100.0), equals(10.0));
        expect(fee.calculateFee(basePrice: 200.0), equals(20.0));
        expect(fee.calculateFee(basePrice: null), equals(0.0));
      });

      test('child seats and boosters scenario', () {
        const childSeatFee = ExtraFee(
          id: 1,
          feeName: 'Child Seat',
          feeCode: 'child_seat',
          feeType: FeeType.flat,
          amount: 15.0,
          isOptional: true,
          displayOrder: 1,
          description: 'For toddlers up to 4 years',
        );

        const boosterFee = ExtraFee(
          id: 2,
          feeName: 'Booster Seat',
          feeCode: 'booster_seat',
          feeType: FeeType.flat,
          amount: 10.0,
          isOptional: true,
          displayOrder: 2,
          description: 'For children 4-12 years',
        );

        // Scenario: 2 toddlers + 3 children
        final childSeatsTotal = childSeatFee.calculateFee(quantity: 2);
        final boostersTotal = boosterFee.calculateFee(quantity: 3);

        expect(childSeatsTotal, equals(30.0)); // 2 * 15
        expect(boostersTotal, equals(30.0)); // 3 * 10
        expect(childSeatsTotal + boostersTotal, equals(60.0));
      });
    });

    group('formattedPrice', () {
      test('flat fee should show euro amount', () {
        const fee = ExtraFee(
          id: 1,
          feeName: 'Child Seat',
          feeCode: 'child_seat',
          feeType: FeeType.flat,
          amount: 15.0,
          isOptional: true,
          displayOrder: 1,
          description: '',
        );

        expect(fee.formattedPrice, equals('€15.00'));
      });

      test('perItem fee should show euro amount per item', () {
        const fee = ExtraFee(
          id: 1,
          feeName: 'Extra Bag',
          feeCode: 'extra_bag',
          feeType: FeeType.perItem,
          amount: 5.0,
          isOptional: true,
          displayOrder: 1,
          description: '',
        );

        expect(fee.formattedPrice, equals('€5.00/item'));
      });

      test('percentage fee should show percentage', () {
        const fee = ExtraFee(
          id: 1,
          feeName: 'Service Fee',
          feeCode: 'service_fee',
          feeType: FeeType.percentage,
          amount: 10.0,
          isOptional: false,
          displayOrder: 1,
          description: '',
        );

        expect(fee.formattedPrice, equals('10%'));
      });
    });
  });
}
