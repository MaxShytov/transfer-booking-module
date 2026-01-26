import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../../../data/models/vehicle_class.dart';

/// Card for vehicle selection - Cupertino style.
class VehicleCard extends StatelessWidget {
  final VehicleClass vehicle;
  final bool isSelected;
  final bool isDisabled;
  final String? disabledReason;
  final double? price;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.isSelected = false,
    this.isDisabled = false,
    this.disabledReason,
    this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.separator.resolveFrom(context),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: CupertinoColors.systemBlue.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: name + price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.className,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.label,
                            ),
                          ),
                          if (vehicle.exampleVehicles.isNotEmpty)
                            Text(
                              vehicle.exampleVehicles,
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel
                                    .resolveFrom(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (price != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '€${price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? CupertinoColors.white
                                : CupertinoColors.systemBlue,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Capacity info
                Row(
                  children: [
                    _CupertinoCapacityBadge(
                      icon: Icons.person_outline,
                      value: vehicle.maxPassengers,
                      label: 'passengers',
                    ),
                    const SizedBox(width: 12),
                    _CupertinoCapacityBadge(
                      icon: Icons.work_outline,
                      value: vehicle.maxLargeLuggage,
                      label: 'large bags',
                    ),
                    const SizedBox(width: 12),
                    _CupertinoCapacityBadge(
                      icon: Icons.luggage,
                      value: vehicle.maxSmallLuggage,
                      label: 'small bags',
                    ),
                  ],
                ),
                // Disabled reason
                if (isDisabled && disabledReason != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: CupertinoColors.systemRed,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            disabledReason!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Selected indicator
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: CupertinoColors.systemBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Selected',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoCapacityBadge extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _CupertinoCapacityBadge({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.label,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
          ),
        ),
      ],
    );
  }
}

/// Compact vehicle card for summary display - Cupertino style.
class VehicleCardCompact extends StatelessWidget {
  final VehicleClass vehicle;
  final double? price;

  const VehicleCardCompact({
    super.key,
    required this.vehicle,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
      ),
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
              Icons.directions_car,
              color: CupertinoColors.systemBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.className,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
                Text(
                  '${vehicle.maxPassengers} pax, ${vehicle.maxLargeLuggage} large bags',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          if (price != null)
            Text(
              '€${price!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemBlue,
              ),
            ),
        ],
      ),
    );
  }
}
