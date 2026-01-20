import 'package:flutter/cupertino.dart';

/// A stepper field with + and - buttons for numeric input (Cupertino style).
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: CupertinoColors.systemBlue,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CupertinoStepperButton(
                  icon: CupertinoIcons.minus,
                  onTap: canDecrement ? () => onChanged(value - 1) : null,
                  isEnabled: canDecrement,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  alignment: Alignment.center,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                ),
                _CupertinoStepperButton(
                  icon: CupertinoIcons.plus,
                  onTap: canIncrement ? () => onChanged(value + 1) : null,
                  isEnabled: canIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _CupertinoStepperButton({
    required this.icon,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(8),
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Icon(
        icon,
        size: 20,
        color: isEnabled
            ? CupertinoColors.systemBlue
            : CupertinoColors.tertiaryLabel.resolveFrom(context),
      ),
    );
  }
}
