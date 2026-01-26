import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/price_breakdown.dart';

/// Price breakdown card widget - Cupertino style.
///
/// Shows detailed breakdown for admin/manager users,
/// or simple total for regular customers.
class PriceBreakdownCard extends StatelessWidget {
  final PriceBreakdown breakdown;
  final bool showDetailedBreakdown;
  // Localized strings
  final String? priceBreakdownTitle;
  final String? priceTitle;
  final String? pricingTypeLabel;
  final String? fixedRouteLabel;
  final String? distanceBasedLabel;
  final String? routeLabel;
  final String? distanceLabel;
  final String? basePriceLabel;
  final String? multipliersAppliedLabel;
  final String? vehicleMultiplierLabel;
  final String? passengersMultiplierLabel;
  final String? seasonMultiplierLabel;
  final String? timeMultiplierLabel;
  final String? subtotalLabel;
  final String? extraServicesLabel;
  final String? extrasTotalLabel;
  final String? totalLabel;
  final String? calculationFormulaLabel;
  final String? formulaText;
  final String? passengersText;
  final String? includesExtrasText;

  const PriceBreakdownCard({
    super.key,
    required this.breakdown,
    required this.showDetailedBreakdown,
    this.priceBreakdownTitle,
    this.priceTitle,
    this.pricingTypeLabel,
    this.fixedRouteLabel,
    this.distanceBasedLabel,
    this.routeLabel,
    this.distanceLabel,
    this.basePriceLabel,
    this.multipliersAppliedLabel,
    this.vehicleMultiplierLabel,
    this.passengersMultiplierLabel,
    this.seasonMultiplierLabel,
    this.timeMultiplierLabel,
    this.subtotalLabel,
    this.extraServicesLabel,
    this.extrasTotalLabel,
    this.totalLabel,
    this.calculationFormulaLabel,
    this.formulaText,
    this.passengersText,
    this.includesExtrasText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: CupertinoColors.systemBlue,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  showDetailedBreakdown ? (priceBreakdownTitle ?? 'Price Breakdown') : (priceTitle ?? 'Price'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
            _buildDivider(context),

            if (showDetailedBreakdown)
              _buildDetailedBreakdown(context)
            else
              _buildSimplePrice(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }

  /// Detailed breakdown for Admin/Manager.
  Widget _buildDetailedBreakdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pricing type
        _buildInfoRow(
          context,
          label: pricingTypeLabel ?? 'Pricing Type',
          value: breakdown.isFixedRoute ? (fixedRouteLabel ?? 'Fixed Route') : (distanceBasedLabel ?? 'Distance Based'),
          icon: Icons.map_outlined,
        ),

        if (breakdown.routeName != null)
          _buildInfoRow(
            context,
            label: routeLabel ?? 'Route',
            value: breakdown.routeName!,
            icon: Icons.location_on_outlined,
          ),

        if (breakdown.distanceKm != null)
          _buildInfoRow(
            context,
            label: distanceLabel ?? 'Distance',
            value: '${breakdown.distanceKm!.toStringAsFixed(1)} km',
            icon: Icons.arrow_forward,
          ),

        _buildDivider(context),

        // Base price
        _buildPriceRow(
          context,
          label: basePriceLabel ?? 'Base Price',
          value: breakdown.basePrice,
          color: AppColors.priceBase,
          isBold: true,
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Multipliers section
        Text(
          multipliersAppliedLabel ?? 'Multipliers Applied',
          style: TextStyle(
            fontSize: 13,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        _buildMultiplierRow(
          context,
          label: vehicleMultiplierLabel != null
              ? vehicleMultiplierLabel!.replaceAll('{name}', breakdown.vehicleClassName)
              : 'Vehicle (${breakdown.vehicleClassName})',
          multiplier: breakdown.vehicleMultiplier,
        ),
        _buildMultiplierRow(
          context,
          label: passengersMultiplierLabel != null
              ? passengersMultiplierLabel!.replaceAll('{count}', breakdown.passengerCount.toString())
              : 'Passengers (${breakdown.passengerCount})',
          multiplier: breakdown.passengerMultiplier,
        ),
        _buildMultiplierRow(
          context,
          label: seasonMultiplierLabel != null
              ? (breakdown.seasonName != null
                  ? seasonMultiplierLabel!.replaceAll('{name}', breakdown.seasonName!)
                  : seasonMultiplierLabel!.replaceAll(' ({name})', ''))
              : 'Season${breakdown.seasonName != null ? " (${breakdown.seasonName})" : ""}',
          multiplier: breakdown.seasonalMultiplier,
        ),
        _buildMultiplierRow(
          context,
          label: timeMultiplierLabel != null
              ? (breakdown.timeSlotName != null
                  ? timeMultiplierLabel!.replaceAll('{name}', breakdown.timeSlotName!)
                  : timeMultiplierLabel!.replaceAll(' ({name})', ''))
              : 'Time${breakdown.timeSlotName != null ? " (${breakdown.timeSlotName})" : ""}',
          multiplier: breakdown.timeMultiplier,
        ),

        _buildDivider(context),

        // Subtotal
        _buildPriceRow(
          context,
          label: subtotalLabel ?? 'Subtotal',
          value: breakdown.subtotal,
          color: AppColors.priceMultiplier,
        ),

        // Extra fees
        if (breakdown.extraFees.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            extraServicesLabel ?? 'Extra Services',
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          ...breakdown.extraFees.map((fee) => _buildExtraFeeRow(context, fee)),
          _buildPriceRow(
            context,
            label: extrasTotalLabel ?? 'Extras Total',
            value: breakdown.extraFeesTotal,
            color: AppColors.priceExtra,
          ),
        ],

        _buildDivider(context),

        // Final price
        _buildPriceRow(
          context,
          label: totalLabel ?? 'TOTAL',
          value: breakdown.finalPrice,
          color: AppColors.priceFinal,
          isBold: true,
          isLarge: true,
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Formula explanation
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(
                color: CupertinoColors.systemBlue.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                calculationFormulaLabel ?? 'Calculation Formula',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                formulaText ?? '(Base × Vehicle × Passengers × Season × Time) + Extras',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                '(€${breakdown.basePrice.toStringAsFixed(2)} × ${breakdown.vehicleMultiplier} × ${breakdown.passengerMultiplier} × ${breakdown.seasonalMultiplier} × ${breakdown.timeMultiplier}) + €${breakdown.extraFeesTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Simple price display for customers.
  Widget _buildSimplePrice(BuildContext context) {
    return Column(
      children: [
        // Final price - big and prominent
        Text(
          '€${breakdown.finalPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.priceFinal,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        // Brief info
        Text(
          '${breakdown.vehicleClassName} • ${breakdown.passengerCount} ${passengersText ?? "passengers"}',
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),

        if (breakdown.extraFees.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            includesExtrasText != null
                ? includesExtrasText!.replaceAll('{count}', breakdown.extraFees.length.toString())
                : 'Includes ${breakdown.extraFees.length} extra service(s)',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.label,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String label,
    required double value,
    required Color color,
    bool isBold = false,
    bool isLarge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              fontSize: isLarge ? 16 : 14,
              color: CupertinoColors.label,
            ),
          ),
          Text(
            '€${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isLarge ? 20 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplierRow(
    BuildContext context, {
    required String label,
    required double multiplier,
  }) {
    final isActive = multiplier != 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? CupertinoColors.label
                  : CupertinoColors.secondaryLabel.resolveFrom(context),
              fontSize: 13,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.priceMultiplier.withValues(alpha: 0.1)
                  : CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '×${multiplier.toStringAsFixed(2)}',
              style: TextStyle(
                color: isActive
                    ? AppColors.priceMultiplier
                    : CupertinoColors.secondaryLabel.resolveFrom(context),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraFeeRow(BuildContext context, ExtraFeeItem fee) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${fee.name}${fee.quantity > 1 ? " (×${fee.quantity})" : ""}',
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.label,
              ),
            ),
          ),
          Text(
            '+€${fee.total.toStringAsFixed(2)}',
            style: TextStyle(
              color: AppColors.priceExtra,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
