import 'package:flutter/cupertino.dart';

/// Card displaying trip distance and duration.
/// Clickable to scroll to map preview.
class TripInfoCard extends StatelessWidget {
  final String? distanceText;
  final String? durationText;
  final VoidCallback? onTap;
  final String distanceLabel;
  final String durationLabel;

  const TripInfoCard({
    super.key,
    this.distanceText,
    this.durationText,
    this.onTap,
    required this.distanceLabel,
    required this.durationLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            Expanded(
              child: _TripInfoItem(
                icon: CupertinoIcons.map,
                value: distanceText ?? '--',
                label: distanceLabel.toUpperCase(),
              ),
            ),
            Container(
              width: 1,
              height: 60,
              color: CupertinoColors.separator.resolveFrom(context),
            ),
            Expanded(
              child: _TripInfoItem(
                icon: CupertinoIcons.clock,
                value: durationText ?? '--',
                label: durationLabel.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripInfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _TripInfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 40,
          color: CupertinoColors.systemBlue,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
