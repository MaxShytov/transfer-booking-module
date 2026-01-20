import 'package:flutter/cupertino.dart';

/// A styled button widget with iOS Cupertino style.
///
/// Uses CupertinoButton.filled for primary actions.
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double minHeight;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.minHeight = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectivelyDisabled = isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(
          vertical: minHeight > 44 ? (minHeight - 24) / 2 : 14,
          horizontal: 20,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        color: CupertinoColors.systemBlue,
        disabledColor: CupertinoColors.systemGrey4,
        onPressed: effectivelyDisabled ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
                color: CupertinoColors.white,
              )
            : Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                ),
              ),
      ),
    );
  }
}

/// Secondary button with outlined style.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectivelyDisabled = isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        borderRadius: BorderRadius.circular(12),
        color: CupertinoColors.systemGrey6,
        onPressed: effectivelyDisabled ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator()
            : Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                ),
              ),
      ),
    );
  }
}
