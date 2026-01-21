import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../providers/booking_flow_provider.dart';

/// Card showing booking summary - Cupertino style.
class BookingSummaryCard extends StatelessWidget {
  final BookingFlowState bookingState;
  final VoidCallback? onEditRoute;
  final VoidCallback? onEditVehicle;
  final VoidCallback? onEditExtras;
  final VoidCallback? onEditPassenger;
  // Localized strings
  final String? routeTitle;
  final String? vehicleTitle;
  final String? extrasTitle;
  final String? passengerTitle;
  final String? fromLabel;
  final String? toLabel;
  final String? editLabel;
  final String? notSelectedText;
  final String? dateNotSelectedText;
  final String? timeNotSelectedText;
  final String? roundTripLabel;
  final String? flightLabel;

  const BookingSummaryCard({
    super.key,
    required this.bookingState,
    this.onEditRoute,
    this.onEditVehicle,
    this.onEditExtras,
    this.onEditPassenger,
    this.routeTitle,
    this.vehicleTitle,
    this.extrasTitle,
    this.passengerTitle,
    this.fromLabel,
    this.toLabel,
    this.editLabel,
    this.notSelectedText,
    this.dateNotSelectedText,
    this.timeNotSelectedText,
    this.roundTripLabel,
    this.flightLabel,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, y');

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route section
            _CupertinoSummarySection(
              title: routeTitle ?? 'Route',
              icon: CupertinoIcons.map,
              onEdit: onEditRoute,
              editLabel: editLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CupertinoLocationRow(
                    label: fromLabel ?? 'From',
                    address:
                        bookingState.pickupLocation?.address ?? notSelectedText ?? 'Not selected',
                    icon: CupertinoIcons.circle,
                    iconColor: CupertinoColors.systemGreen,
                  ),
                  const SizedBox(height: 8),
                  _CupertinoLocationRow(
                    label: toLabel ?? 'To',
                    address:
                        bookingState.dropoffLocation?.address ?? notSelectedText ?? 'Not selected',
                    icon: CupertinoIcons.location_solid,
                    iconColor: CupertinoColors.systemRed,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bookingState.serviceDate != null
                            ? dateFormat.format(bookingState.serviceDate!)
                            : dateNotSelectedText ?? 'Date not selected',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        CupertinoIcons.clock,
                        size: 16,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bookingState.pickupTime ?? timeNotSelectedText ?? 'Time not selected',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.label,
                        ),
                      ),
                    ],
                  ),
                  if (bookingState.isRoundTrip) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.arrow_2_squarepath,
                            size: 14,
                            color: CupertinoColors.systemBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            roundTripLabel ?? 'Round Trip',
                            style: const TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.systemBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (bookingState.returnDate != null) ...[
                            Text(
                              ' - ${dateFormat.format(bookingState.returnDate!)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                            if (bookingState.returnTime != null)
                              Text(
                                ' ${bookingState.returnTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _CupertinoInfoChip(
                        icon: CupertinoIcons.person,
                        label: '${bookingState.numPassengers}',
                      ),
                      const SizedBox(width: 8),
                      _CupertinoInfoChip(
                        icon: CupertinoIcons.briefcase,
                        label: '${bookingState.numLargeLuggage}',
                      ),
                      const SizedBox(width: 8),
                      _CupertinoInfoChip(
                        icon: CupertinoIcons.bag,
                        label: '${bookingState.numSmallLuggage}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Vehicle section
            if (bookingState.selectedVehicle != null) ...[
              _buildDivider(context),
              _CupertinoSummarySection(
                title: vehicleTitle ?? 'Vehicle',
                icon: CupertinoIcons.car_detailed,
                onEdit: onEditVehicle,
                editLabel: editLabel,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.car_detailed,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookingState.selectedVehicle!.className,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label,
                            ),
                          ),
                          Text(
                            bookingState.selectedVehicle!.exampleVehicles,
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.secondaryLabel
                                  .resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Extras section
            if (bookingState.selectedExtras.isNotEmpty) ...[
              _buildDivider(context),
              _CupertinoSummarySection(
                title: extrasTitle ?? 'Extras',
                icon: CupertinoIcons.plus_circle,
                onEdit: onEditExtras,
                editLabel: editLabel,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bookingState.selectedExtras.map((extra) {
                    final total = extra.totalAmount;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill
                            .resolveFrom(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '€${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemBlue,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            extra.quantity > 1
                                ? '${extra.fee.feeName} x${extra.quantity}'
                                : extra.fee.feeName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            // Passenger section
            if (bookingState.passengerDetails != null) ...[
              _buildDivider(context),
              _CupertinoSummarySection(
                title: passengerTitle ?? 'Passenger',
                icon: CupertinoIcons.person_circle,
                onEdit: onEditPassenger,
                editLabel: editLabel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bookingState.passengerDetails!.firstName} ${bookingState.passengerDetails!.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.phone,
                          size: 14,
                          color:
                              CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bookingState.passengerDetails!.phone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.label,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          CupertinoIcons.mail,
                          size: 14,
                          color:
                              CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            bookingState.passengerDetails!.email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.label,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (bookingState.passengerDetails!.flightNumber != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.airplane,
                            size: 14,
                            color: CupertinoColors.secondaryLabel
                                .resolveFrom(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${flightLabel ?? "Flight"}: ${bookingState.passengerDetails!.flightNumber}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }
}

class _CupertinoSummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onEdit;
  final String? editLabel;

  const _CupertinoSummarySection({
    required this.title,
    required this.icon,
    required this.child,
    this.onEdit,
    this.editLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    fontSize: 14,
                    color: CupertinoColors.systemBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (onEdit != null)
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                onPressed: onEdit,
                child: Text(
                  editLabel ?? 'Edit',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _CupertinoLocationRow extends StatelessWidget {
  final String label;
  final String address;
  final IconData icon;
  final Color iconColor;

  const _CupertinoLocationRow({
    required this.label,
    required this.address,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CupertinoInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CupertinoInfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }
}
