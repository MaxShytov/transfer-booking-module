import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

/// A stepper field with + and - buttons for numeric input (Cupertino style).
/// Matches HTML prototype with 36px circle buttons and 2px border.
class StepperField extends StatelessWidget {
  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final IconData? icon;
  final String? subtitle;

  const StepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 99,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = value > minValue;
    final canIncrement = value < maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CounterButton(
                icon: Icons.remove,
                onTap: canDecrement ? () => onChanged(value - 1) : null,
                isEnabled: canDecrement,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 30),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
              _CounterButton(
                icon: Icons.add,
                onTap: canIncrement ? () => onChanged(value + 1) : null,
                isEnabled: canIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Counter button matching HTML prototype: 36px circle with 2px border.
class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _CounterButton({
    required this.icon,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            icon == Icons.remove ? '−' : '+',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: isEnabled
                  ? CupertinoColors.secondaryLabel.resolveFrom(context)
                  : CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }
}
