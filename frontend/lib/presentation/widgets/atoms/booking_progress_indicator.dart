import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

/// Progress indicator for booking wizard steps (Cupertino style).
class BookingProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const BookingProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    final labels = stepLabels ??
        ['Route', 'Vehicle', 'Extras', 'Details', 'Review'];

    return Column(
      children: [
        // Progress bar
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey5.resolveFrom(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Step indicators with labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            final label = index < labels.length ? labels[index] : '';

            return _CupertinoStepIndicator(
              stepNumber: index + 1,
              label: label,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
            );
          }),
        ),
      ],
    );
  }
}

class _CupertinoStepIndicator extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  const _CupertinoStepIndicator({
    required this.stepNumber,
    required this.label,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = isCompleted || isCurrent;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey5.resolveFrom(context),
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(
                    color: CupertinoColors.systemBlue,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: CupertinoColors.white,
                  )
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? CupertinoColors.white
                          : CupertinoColors.secondaryLabel.resolveFrom(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive
                ? CupertinoColors.systemBlue
                : CupertinoColors.secondaryLabel.resolveFrom(context),
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Compact progress indicator showing only dots (Cupertino style).
class CompactProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CompactProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Container(
          width: isCurrent ? 24 : 8,
          height: 8,
          margin: EdgeInsets.only(
            right: index < totalSteps - 1 ? 8 : 0,
          ),
          decoration: BoxDecoration(
            color: isCompleted || isCurrent
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey5.resolveFrom(context),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
