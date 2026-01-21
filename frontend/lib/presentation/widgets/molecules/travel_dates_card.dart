import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../atoms/animated_discount_chip.dart';

/// Card for selecting travel dates with round trip toggle.
/// Matches HTML prototype styling with border-top datetime sections.
class TravelDatesCard extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool> onRoundTripChanged;

  // Outbound
  final DateTime? outboundDate;
  final String? outboundTime;
  final bool isOutboundArrival;
  final VoidCallback onOutboundTap;
  final VoidCallback onOutboundNowTap;

  // Return (shown only if round trip)
  final DateTime? returnDate;
  final String? returnTime;
  final bool isReturnArrival;
  final VoidCallback onReturnTap;
  final VoidCallback onReturnNowTap;

  // Localized strings
  final String travelDateLabel;
  final String travelDatesLabel;
  final String roundTripLabel;
  final String discountText;
  final String outboundLabel;
  final String returnLabel;
  final String departureAbbrev;
  final String arrivalAbbrev;
  final String nowLabel;

  const TravelDatesCard({
    super.key,
    required this.isRoundTrip,
    required this.onRoundTripChanged,
    this.outboundDate,
    this.outboundTime,
    required this.isOutboundArrival,
    required this.onOutboundTap,
    required this.onOutboundNowTap,
    this.returnDate,
    this.returnTime,
    required this.isReturnArrival,
    required this.onReturnTap,
    required this.onReturnNowTap,
    required this.travelDateLabel,
    required this.travelDatesLabel,
    required this.roundTripLabel,
    required this.discountText,
    required this.outboundLabel,
    required this.returnLabel,
    required this.departureAbbrev,
    required this.arrivalAbbrev,
    required this.nowLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and toggle
          _buildHeader(context),
          const SizedBox(height: 20),

          // Outbound label (only show when round trip)
          if (isRoundTrip)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                outboundLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  letterSpacing: 1,
                ),
              ),
            ),

          // Outbound datetime section
          _DateTimeSection(
            date: outboundDate,
            time: outboundTime,
            isArrival: isOutboundArrival,
            onTap: onOutboundTap,
            onNowTap: onOutboundNowTap,
            departureAbbrev: departureAbbrev,
            arrivalAbbrev: arrivalAbbrev,
            nowLabel: nowLabel,
          ),

          // Return section (if round trip)
          if (isRoundTrip) ...[
            const SizedBox(height: 15),
            Text(
              returnLabel.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            _DateTimeSection(
              date: returnDate,
              time: returnTime,
              isArrival: isReturnArrival,
              onTap: onReturnTap,
              onNowTap: onReturnNowTap,
              departureAbbrev: departureAbbrev,
              arrivalAbbrev: arrivalAbbrev,
              nowLabel: nowLabel,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Title
        Flexible(
          child: Text(
            isRoundTrip ? travelDatesLabel : travelDateLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        // Round trip toggle with label
        GestureDetector(
          onTap: () => onRoundTripChanged(!isRoundTrip),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CustomSwitch(isOn: isRoundTrip),
              const SizedBox(width: 10),
              Text(
                roundTripLabel,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Discount chip
        AnimatedDiscountChip(
          text: discountText,
          isActive: isRoundTrip,
        ),
      ],
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  final bool isOn;

  const _CustomSwitch({required this.isOn});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 50,
      height: 28,
      decoration: BoxDecoration(
        color: isOn
            ? CupertinoColors.systemBlue
            : CupertinoColors.systemGrey4.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// DateTime section matching HTML prototype with border-top style.
class _DateTimeSection extends StatelessWidget {
  final DateTime? date;
  final String? time;
  final bool isArrival;
  final VoidCallback onTap;
  final VoidCallback onNowTap;
  final String departureAbbrev;
  final String arrivalAbbrev;
  final String nowLabel;

  const _DateTimeSection({
    this.date,
    this.time,
    required this.isArrival,
    required this.onTap,
    required this.onNowTap,
    required this.departureAbbrev,
    required this.arrivalAbbrev,
    required this.nowLabel,
  });

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEE dd.MM.');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = date != null ? _formatDate(date!) : 'Select date';
    final timeText = time ?? '--:--';
    final typeText = isArrival ? arrivalAbbrev : departureAbbrev;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: CupertinoColors.separator.resolveFrom(context),
            ),
          ),
        ),
        child: Row(
          children: [
            // Date, time and type display
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$dateText | $timeText',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    TextSpan(
                      text: ' $typeText',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Now button
            GestureDetector(
              onTap: onNowTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  nowLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
