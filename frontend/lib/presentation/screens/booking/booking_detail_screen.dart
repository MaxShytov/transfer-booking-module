import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/booking.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Screen for viewing booking details.
class BookingDetailScreen extends ConsumerStatefulWidget {
  final int bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  BookingDetail? _booking;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final booking = await ref.read(bookingRepositoryProvider).getBookingDetail(widget.bookingId);
      if (mounted) {
        setState(() {
          _booking = booking;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_booking?.bookingReference ?? l10n.reviewBooking),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _error != null
                ? _buildError(context, l10n)
                : _booking != null
                    ? _buildContent(context, l10n)
                    : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 64,
            color: CupertinoColors.systemRed,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Error',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            onPressed: _loadBooking,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final booking = _booking!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(context, booking),
          const SizedBox(height: 16),

          // Route section
          _buildSection(
            context,
            title: l10n.stepRoute,
            icon: CupertinoIcons.location,
            child: Column(
              children: [
                _buildRouteRow(
                  context,
                  icon: CupertinoIcons.location,
                  iconColor: CupertinoColors.systemGreen,
                  label: l10n.from,
                  value: booking.pickupAddress,
                ),
                const SizedBox(height: 12),
                _buildRouteRow(
                  context,
                  icon: CupertinoIcons.location_solid,
                  iconColor: CupertinoColors.systemRed,
                  label: l10n.to,
                  value: booking.dropoffAddress,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Date & Time section
          _buildSection(
            context,
            title: l10n.dateTime,
            icon: CupertinoIcons.calendar,
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    label: l10n.date,
                    value: booking.serviceDate,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    label: l10n.time,
                    value: booking.pickupTime.substring(0, 5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Vehicle & Passengers section
          _buildSection(
            context,
            title: l10n.vehicle,
            icon: CupertinoIcons.car_detailed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.vehicleClassName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(context, '${booking.numPassengers} ${l10n.passengers}'),
                    const SizedBox(width: 8),
                    if (booking.numLargeLuggage > 0)
                      _buildBadge(context, '${booking.numLargeLuggage} ${l10n.largeBags}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Flight info (if present)
          if (booking.flightNumber != null && booking.flightNumber!.isNotEmpty) ...[
            _buildSection(
              context,
              title: l10n.flightNumber,
              icon: CupertinoIcons.airplane,
              child: Text(
                booking.flightNumber!,
                style: const TextStyle(
                  fontSize: 17,
                  color: CupertinoColors.label,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Special requests (if present)
          if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) ...[
            _buildSection(
              context,
              title: l10n.specialRequests,
              icon: CupertinoIcons.doc_text,
              child: Text(
                booking.specialRequests!,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.label,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Customer section
          _buildSection(
            context,
            title: l10n.passenger,
            icon: CupertinoIcons.person,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.customerEmail,
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
                Text(
                  booking.customerPhone,
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Price section
          _buildSection(
            context,
            title: l10n.price,
            icon: CupertinoIcons.money_euro,
            child: Column(
              children: [
                if (booking.extraFeesJson.isNotEmpty) ...[
                  _buildPriceRow(context, l10n.subtotal, booking.subtotal),
                  ...booking.extraFeesJson.map((fee) => _buildPriceRow(
                        context,
                        '${fee['fee_name']} x${fee['quantity']}',
                        (fee['total_amount'] as num).toDouble(),
                      )),
                  Container(
                  height: 1,
                  color: CupertinoColors.separator.resolveFrom(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                ],
                _buildPriceRow(
                  context,
                  l10n.total,
                  booking.finalPrice,
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, BookingDetail booking) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (booking.status) {
      case 'pending':
        backgroundColor = CupertinoColors.systemYellow.withOpacity(0.2);
        textColor = CupertinoColors.systemOrange;
        icon = CupertinoIcons.clock;
        break;
      case 'confirmed':
        backgroundColor = CupertinoColors.systemBlue.withOpacity(0.2);
        textColor = CupertinoColors.systemBlue;
        icon = CupertinoIcons.checkmark_circle;
        break;
      case 'in_progress':
        backgroundColor = CupertinoColors.systemPurple.withOpacity(0.2);
        textColor = CupertinoColors.systemPurple;
        icon = CupertinoIcons.car_detailed;
        break;
      case 'completed':
        backgroundColor = CupertinoColors.systemGreen.withOpacity(0.2);
        textColor = CupertinoColors.systemGreen;
        icon = CupertinoIcons.checkmark_circle_fill;
        break;
      case 'cancelled':
        backgroundColor = CupertinoColors.systemRed.withOpacity(0.2);
        textColor = CupertinoColors.systemRed;
        icon = CupertinoIcons.xmark_circle;
        break;
      default:
        backgroundColor = CupertinoColors.systemGrey.withOpacity(0.2);
        textColor = CupertinoColors.systemGrey;
        icon = CupertinoIcons.question_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.statusDisplay,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Booking #${booking.bookingReference}',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '€${booking.finalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildRouteRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5.resolveFrom(context),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          Text(
            '€${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? CupertinoColors.systemBlue : CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
