import 'package:flutter/cupertino.dart';

/// A styled card container for route selection sections.
/// Follows the Cupertino design system with rounded corners and shadows.
/// Matches HTML prototype with 25px padding, 20px border-radius, and shadow.
class RouteCard extends StatelessWidget {
  final String? title;
  final IconData? titleIcon;
  final Widget? trailing;
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? backgroundColor;

  const RouteCard({
    super.key,
    this.title,
    this.titleIcon,
    this.trailing,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(25),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              _buildHeader(context),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardContent,
      );
    }

    return cardContent;
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (titleIcon != null) ...[
              Icon(
                titleIcon,
                size: 20,
                color: CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
