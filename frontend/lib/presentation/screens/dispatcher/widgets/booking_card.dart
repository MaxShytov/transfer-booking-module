import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/dispatcher_models.dart';
import 'status_badge.dart';

/// Booking card widget for dispatcher list view.
class BookingCard extends StatelessWidget {
  final DispatcherBooking booking;
  final bool isSelected;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 3 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Reference + Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingReference,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    _formatTime(booking.pickupTime),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Route info
              _RouteInfo(
                pickup: booking.pickupAddress,
                dropoff: booking.dropoffAddress,
              ),
              const SizedBox(height: 8),

              // Customer & passengers
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.customerName,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.people,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${booking.numPassengers}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (booking.numLargeLuggage > 0 ||
                      booking.numSmallLuggage > 0) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.luggage,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${booking.numLargeLuggage + booking.numSmallLuggage}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Status row
              Row(
                children: [
                  StatusBadge(status: booking.status, isCompact: true),
                  const SizedBox(width: 6),
                  PaymentStatusBadge(
                    paymentStatus: booking.paymentStatus,
                    isCompact: true,
                  ),
                  const Spacer(),
                  Text(
                    '${booking.finalPrice.toStringAsFixed(0)} ${booking.currency}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),

              // Driver info (if assigned)
              if (booking.hasDriver) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.drive_eta,
                      size: 14,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.assignedDriverName ?? 'Водитель назначен',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ] else if (booking.status != 'cancelled' &&
                  booking.status != 'completed') ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Без водителя',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Round trip indicator
              if (booking.isRoundTrip) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.sync,
                      size: 12,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Туда-обратно',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                    if (booking.returnDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(booking.returnDate!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // Time comes as "HH:MM:SS", return "HH:MM"
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd.MM').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

/// Route info widget showing pickup -> dropoff.
class _RouteInfo extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const _RouteInfo({
    required this.pickup,
    required this.dropoff,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pickup,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Container(
          width: 1,
          height: 8,
          margin: const EdgeInsets.only(left: 3.5),
          color: Colors.grey.shade300,
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                dropoff,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
