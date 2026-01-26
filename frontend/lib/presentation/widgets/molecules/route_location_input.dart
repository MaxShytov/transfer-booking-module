import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

/// Combined pickup/dropoff location input with visual connection line
/// and swap button for exchanging locations.
class RouteLocationInput extends StatelessWidget {
  final String? pickupAddress;
  final String? dropoffAddress;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final VoidCallback onSwapTap;
  final String pickupPlaceholder;
  final String dropoffPlaceholder;

  const RouteLocationInput({
    super.key,
    this.pickupAddress,
    this.dropoffAddress,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onSwapTap,
    required this.pickupPlaceholder,
    required this.dropoffPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Connection line
        Positioned(
          left: 12,
          top: 28,
          bottom: 28,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              color: CupertinoColors.separator.resolveFrom(context),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        // Content
        Column(
          children: [
            // Pickup row
            _LocationRow(
              icon: _buildPickupIcon(),
              address: pickupAddress,
              placeholder: pickupPlaceholder,
              onTap: onPickupTap,
            ),
            const SizedBox(height: 8),
            // Dropoff row
            _LocationRow(
              icon: _buildDropoffIcon(),
              address: dropoffAddress,
              placeholder: dropoffPlaceholder,
              onTap: onDropoffTap,
            ),
          ],
        ),
        // Swap button
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: _SwapButton(onTap: onSwapTap),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CrosshairPainter(color: CupertinoColors.systemBlue),
      ),
    );
  }

  Widget _buildDropoffIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFDC143C),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFDC143C),
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final Widget icon;
  final String? address;
  final String placeholder;
  final VoidCallback onTap;

  const _LocationRow({
    required this.icon,
    this.address,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(right: 70), // Space for swap button
        child: Row(
          children: [
            icon,
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                ),
                child: Text(
                  hasAddress ? address! : placeholder,
                  style: TextStyle(
                    fontSize: 17,
                    color: hasAddress
                        ? CupertinoColors.label.resolveFrom(context)
                        : CupertinoColors.placeholderText.resolveFrom(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SwapButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.swap_vert,
          size: 24,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
      ),
    );
  }
}

/// Custom painter for crosshair pickup icon
class _CrosshairPainter extends CustomPainter {
  final Color color;

  _CrosshairPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Inner filled circle
    canvas.drawCircle(center, 3, fillPaint);

    // Crosshair lines
    // Top
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, 4),
      paint,
    );
    // Bottom
    canvas.drawLine(
      Offset(center.dx, size.height - 4),
      Offset(center.dx, size.height),
      paint,
    );
    // Left
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(4, center.dy),
      paint,
    );
    // Right
    canvas.drawLine(
      Offset(size.width - 4, center.dy),
      Offset(size.width, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
