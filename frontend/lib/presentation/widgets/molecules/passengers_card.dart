import 'package:flutter/cupertino.dart';
import '../atoms/stepper_field.dart';

/// Card for selecting number of passengers (adults and children).
/// Matches HTML prototype with border-bottom item rows.
class PassengersCard extends StatelessWidget {
  final int adults;
  final int children;
  final ValueChanged<int> onAdultsChanged;
  final ValueChanged<int> onChildrenChanged;
  final String adultsLabel;
  final String childrenLabel;
  final String childrenSubtitle;

  const PassengersCard({
    super.key,
    required this.adults,
    required this.children,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
    required this.adultsLabel,
    required this.childrenLabel,
    required this.childrenSubtitle,
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
        // Children row (no border - last item)
        StepperField(
          label: childrenLabel,
          subtitle: childrenSubtitle,
          value: children,
          minValue: 0,
          maxValue: 10,
          onChanged: onChildrenChanged,
        ),
      ],
    );
  }
}
