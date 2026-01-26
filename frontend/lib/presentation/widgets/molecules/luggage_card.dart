import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import '../atoms/stepper_field.dart';

/// Card for selecting luggage quantities and sports equipment.
/// Matches HTML prototype with border-bottom item rows.
class LuggageCard extends StatelessWidget {
  // Large luggage
  final int largeLuggage;
  final ValueChanged<int> onLargeLuggageChanged;
  final String largeLabel;
  final String largeSubtitle;

  // Surfboard/Bike/Golf
  final int surfboardBikeGolf;
  final ValueChanged<int> onSurfboardBikeGolfChanged;
  final String surfboardBikeGolfLabel;

  // Ski/Snowboard
  final int skiSnowboard;
  final ValueChanged<int> onSkiSnowboardChanged;
  final String skiSnowboardLabel;

  // Other sports
  final bool hasOtherSports;
  final String? otherSportsDetails;
  final ValueChanged<bool> onOtherSportsChanged;
  final ValueChanged<String> onOtherSportsDetailsChanged;
  final String otherSportsLabel;
  final String otherSportsPlaceholder;

  // Small luggage
  final int smallLuggage;
  final ValueChanged<int> onSmallLuggageChanged;
  final String smallLabel;
  final String smallSubtitle;

  const LuggageCard({
    super.key,
    required this.largeLuggage,
    required this.onLargeLuggageChanged,
    required this.largeLabel,
    required this.largeSubtitle,
    required this.surfboardBikeGolf,
    required this.onSurfboardBikeGolfChanged,
    required this.surfboardBikeGolfLabel,
    required this.skiSnowboard,
    required this.onSkiSnowboardChanged,
    required this.skiSnowboardLabel,
    required this.hasOtherSports,
    this.otherSportsDetails,
    required this.onOtherSportsChanged,
    required this.onOtherSportsDetailsChanged,
    required this.otherSportsLabel,
    required this.otherSportsPlaceholder,
    required this.smallLuggage,
    required this.onSmallLuggageChanged,
    required this.smallLabel,
    required this.smallSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Large luggage
        _buildItemRow(
          context,
          child: StepperField(
            label: largeLabel,
            subtitle: largeSubtitle,
            value: largeLuggage,
            minValue: 0,
            maxValue: 20,
            onChanged: onLargeLuggageChanged,
          ),
        ),

        // Surfboard/Bike/Golf
        _buildItemRow(
          context,
          child: StepperField(
            label: surfboardBikeGolfLabel,
            value: surfboardBikeGolf,
            minValue: 0,
            maxValue: 10,
            onChanged: onSurfboardBikeGolfChanged,
          ),
        ),

        // Ski/Snowboard
        _buildItemRow(
          context,
          child: StepperField(
            label: skiSnowboardLabel,
            value: skiSnowboard,
            minValue: 0,
            maxValue: 10,
            onChanged: onSkiSnowboardChanged,
          ),
        ),

        // Other sports equipment
        _buildItemRow(
          context,
          child: _OtherSportsEquipmentRow(
            isChecked: hasOtherSports,
            details: otherSportsDetails,
            onCheckedChanged: onOtherSportsChanged,
            onDetailsChanged: onOtherSportsDetailsChanged,
            label: otherSportsLabel,
            placeholder: otherSportsPlaceholder,
          ),
        ),

        // Small luggage (last item, no border)
        StepperField(
          label: smallLabel,
          subtitle: smallSubtitle,
          value: smallLuggage,
          minValue: 0,
          maxValue: 20,
          onChanged: onSmallLuggageChanged,
        ),
      ],
    );
  }

  Widget _buildItemRow(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: child,
    );
  }
}

/// Row with checkbox for "Other sports equipment" with conditional text input.
/// Matches HTML prototype styling.
class _OtherSportsEquipmentRow extends StatelessWidget {
  final bool isChecked;
  final String? details;
  final ValueChanged<bool> onCheckedChanged;
  final ValueChanged<String> onDetailsChanged;
  final String label;
  final String placeholder;

  const _OtherSportsEquipmentRow({
    required this.isChecked,
    this.details,
    required this.onCheckedChanged,
    required this.onDetailsChanged,
    required this.label,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onCheckedChanged(!isChecked),
                child: _Checkbox(isChecked: isChecked),
              ),
            ],
          ),
        ),
        if (isChecked)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              placeholder: placeholder,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                border: Border.all(
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.label,
              ),
              onChanged: onDetailsChanged,
              controller: TextEditingController(text: details),
            ),
          ),
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool isChecked;

  const _Checkbox({required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked
            ? CupertinoColors.systemBlue
            : CupertinoColors.systemBackground.resolveFrom(context),
        border: Border.all(
          color: isChecked
              ? CupertinoColors.systemBlue
              : CupertinoColors.separator.resolveFrom(context),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              size: 16,
              color: CupertinoColors.white,
            )
          : null,
    );
  }
}
