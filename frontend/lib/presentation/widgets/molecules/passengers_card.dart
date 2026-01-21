import 'package:flutter/cupertino.dart';
import '../atoms/stepper_field.dart';

/// Card for selecting number of passengers (adults, toddlers with child seats, children with boosters).
/// Matches HTML prototype with border-bottom item rows.
class PassengersCard extends StatelessWidget {
  final int adults;
  final int childSeats; // Toddlers up to 4 years (need child seat)
  final int boosterSeats; // Children 4-12 years (need booster)
  final ValueChanged<int> onAdultsChanged;
  final ValueChanged<int> onChildSeatsChanged;
  final ValueChanged<int> onBoosterSeatsChanged;
  final String adultsLabel;
  final String childSeatsLabel;
  final String childSeatsSubtitle;
  final String boosterSeatsLabel;
  final String boosterSeatsSubtitle;

  const PassengersCard({
    super.key,
    required this.adults,
    required this.childSeats,
    required this.boosterSeats,
    required this.onAdultsChanged,
    required this.onChildSeatsChanged,
    required this.onBoosterSeatsChanged,
    required this.adultsLabel,
    required this.childSeatsLabel,
    required this.childSeatsSubtitle,
    required this.boosterSeatsLabel,
    required this.boosterSeatsSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Adults row with bottom border
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
          ),
          child: StepperField(
            label: adultsLabel,
            value: adults,
            minValue: 1,
            maxValue: 25,
            onChanged: onAdultsChanged,
          ),
        ),
        // Child seats row (toddlers up to 4 years) with bottom border
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
          ),
          child: StepperField(
            label: childSeatsLabel,
            subtitle: childSeatsSubtitle,
            value: childSeats,
            minValue: 0,
            maxValue: 5,
            onChanged: onChildSeatsChanged,
          ),
        ),
        // Booster seats row (children 4-12 years) - no border, last item
        StepperField(
          label: boosterSeatsLabel,
          subtitle: boosterSeatsSubtitle,
          value: boosterSeats,
          minValue: 0,
          maxValue: 5,
          onChanged: onBoosterSeatsChanged,
        ),
      ],
    );
  }
}
