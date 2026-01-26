import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/extra_fee.dart';
import '../../providers/booking_flow_provider.dart';
import '../../providers/extra_fees_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/molecules/extra_fee_tile.dart';

/// Screen for extras selection (Step 3 of booking wizard) - Cupertino style.
class ExtrasSelectionScreen extends ConsumerStatefulWidget {
  const ExtrasSelectionScreen({super.key});

  @override
  ConsumerState<ExtrasSelectionScreen> createState() =>
      _ExtrasSelectionScreenState();
}

class _ExtrasSelectionScreenState extends ConsumerState<ExtrasSelectionScreen> {
  bool _hasAutoAddedSeats = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(extraFeesProvider.notifier).loadExtraFees();
    });
  }

  /// Auto-add child seats and boosters based on passenger selections
  void _autoAddChildSeatsAndBoosters(List<ExtraFee> optionalFees) {
    if (_hasAutoAddedSeats) return;

    final bookingState = ref.read(bookingFlowProvider);

    _hasAutoAddedSeats = true;

    // Find child seat fee (common codes: child_seat, childseat, baby_seat)
    ExtraFee? childSeatFee;
    for (final fee in optionalFees) {
      final code = fee.feeCode.toLowerCase();
      final name = fee.feeName.toLowerCase();
      if (code.contains('child_seat') ||
          code.contains('childseat') ||
          code.contains('baby_seat') ||
          code.contains('babyseat') ||
          name.contains('child seat') ||
          name.contains('baby seat')) {
        childSeatFee = fee;
        break;
      }
    }

    // Find booster seat fee (common codes: booster, booster_seat)
    ExtraFee? boosterFee;
    for (final fee in optionalFees) {
      final code = fee.feeCode.toLowerCase();
      final name = fee.feeName.toLowerCase();
      if (code.contains('booster') || name.contains('booster')) {
        boosterFee = fee;
        break;
      }
    }

    // Auto-add child seats if needed
    if (bookingState.numChildSeats > 0 && childSeatFee != null) {
      ref.read(bookingFlowProvider.notifier).setExtraQuantity(
            childSeatFee,
            bookingState.numChildSeats,
          );
    }

    // Auto-add boosters if needed
    if (bookingState.numBoosterSeats > 0 && boosterFee != null) {
      ref.read(bookingFlowProvider.notifier).setExtraQuantity(
            boosterFee,
            bookingState.numBoosterSeats,
          );
    }
  }

  /// Check if fee is a child seat
  bool _isChildSeatFee(ExtraFee fee) {
    final code = fee.feeCode.toLowerCase();
    final name = fee.feeName.toLowerCase();
    return code.contains('child_seat') ||
        code.contains('childseat') ||
        code.contains('baby_seat') ||
        code.contains('babyseat') ||
        name.contains('child seat') ||
        name.contains('baby seat');
  }

  /// Check if fee is a booster seat
  bool _isBoosterSeatFee(ExtraFee fee) {
    final code = fee.feeCode.toLowerCase();
    final name = fee.feeName.toLowerCase();
    return code.contains('booster') || name.contains('booster');
  }

  /// Get minimum quantity for a fee based on passenger selections
  /// Returns the required minimum for child seats and boosters
  int _getMinQuantityForFee(ExtraFee fee, dynamic bookingState) {
    if (_isChildSeatFee(fee)) {
      return bookingState.numChildSeats;
    }
    if (_isBoosterSeatFee(fee)) {
      return bookingState.numBoosterSeats;
    }
    return 0;
  }

  /// Get hint text for minimum quantity requirement
  String? _getMinQuantityHint(ExtraFee fee, dynamic bookingState, AppLocalizations l10n) {
    if (_isChildSeatFee(fee) && bookingState.numChildSeats > 0) {
      return l10n.minChildSeatsRequired(bookingState.numChildSeats);
    }
    if (_isBoosterSeatFee(fee) && bookingState.numBoosterSeats > 0) {
      return l10n.minBoosterSeatsRequired(bookingState.numBoosterSeats);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);
    final feesState = ref.watch(extraFeesProvider);
    final l10n = AppLocalizations.of(context);

    // Auto-add child seats and boosters when fees are loaded
    if (feesState.optionalFees.isNotEmpty && !_hasAutoAddedSeats) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoAddChildSeatsAndBoosters(feesState.optionalFees);
      });
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.extraServices),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            ref.read(bookingFlowProvider.notifier).previousStep();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/booking/vehicle');
            }
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: BookingProgressIndicator(
                currentStep: bookingState.currentStep.index,
                totalSteps: 5,
                stepLabels: [
                  l10n.stepRoute,
                  l10n.stepVehicle,
                  l10n.stepExtras,
                  l10n.stepDetails,
                  l10n.stepReview,
                ],
              ),
            ),
            Expanded(
              child: feesState.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : feesState.error != null
                      ? _CupertinoErrorWidget(
                          error: feesState.error!,
                          errorTitle: l10n.failedToLoadExtras,
                          retryLabel: l10n.retry,
                          onRetry: () {
                            ref.read(extraFeesProvider.notifier).loadExtraFees();
                          },
                        )
                      : feesState.fees.isEmpty
                          ? _CupertinoEmptyWidget(
                              title: l10n.noExtrasAvailable,
                              subtitle: l10n.continueToNextStep,
                            )
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                if (feesState.optionalFees.isNotEmpty) ...[
                                  Text(
                                    l10n.optionalServices,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.optionalServicesSubtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel
                                          .resolveFrom(context),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...feesState.optionalFees.map((fee) {
                                    final isSelected = ref
                                        .read(bookingFlowProvider.notifier)
                                        .isExtraSelected(fee.feeCode);
                                    final quantity = ref
                                        .read(bookingFlowProvider.notifier)
                                        .getExtraQuantity(fee.feeCode);

                                    // Determine minimum quantity for child seats and boosters
                                    final minQuantity = _getMinQuantityForFee(fee, bookingState);
                                    final minQuantityHint = _getMinQuantityHint(fee, bookingState, l10n);

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: ExtraFeeTile(
                                        fee: fee,
                                        isSelected: isSelected,
                                        quantity: isSelected ? quantity : 1,
                                        minQuantity: minQuantity,
                                        minQuantityHint: minQuantityHint,
                                        onToggle: minQuantity > 0
                                            ? null // Disable toggle if required by passenger count
                                            : (selected) {
                                                ref
                                                    .read(bookingFlowProvider.notifier)
                                                    .toggleExtra(fee);
                                              },
                                        onQuantityChanged: (qty) {
                                          ref
                                              .read(bookingFlowProvider.notifier)
                                              .setExtraQuantity(fee, qty);
                                        },
                                      ),
                                    );
                                  }),
                                ],
                                if (feesState.mandatoryFees.isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  Text(
                                    l10n.includedServices,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.includedServicesSubtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.secondaryLabel
                                          .resolveFrom(context),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...feesState.mandatoryFees.map((fee) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: _CupertinoMandatoryFeeInfo(fee: fee),
                                      )),
                                ],
                                const SizedBox(height: 100),
                              ],
                            ),
            ),
            // Bottom navigation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bookingState.selectedExtras.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.selectedExtras,
                            style: const TextStyle(
                              fontSize: 15,
                              color: CupertinoColors.label,
                            ),
                          ),
                          Text(
                            '+€${bookingState.extraFeesTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () {
                            ref.read(bookingFlowProvider.notifier).nextStep();
                            context.push('/booking/passenger');
                          },
                          child: Text(
                            l10n.skip,
                            style: const TextStyle(
                              color: CupertinoColors.systemBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GradientButton(
                          text: l10n.continueButton,
                          onPressed: () {
                            ref.read(bookingFlowProvider.notifier).nextStep();
                            context.push('/booking/passenger');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoMandatoryFeeInfo extends StatelessWidget {
  final dynamic fee;

  const _CupertinoMandatoryFeeInfo({required this.fee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fee.feeName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
                if (fee.description.isNotEmpty)
                  Text(
                    fee.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '€${fee.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoErrorWidget extends StatelessWidget {
  final String error;
  final String errorTitle;
  final String retryLabel;
  final VoidCallback onRetry;

  const _CupertinoErrorWidget({
    required this.error,
    required this.errorTitle,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 16),
            Text(
              errorTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(retryLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoEmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CupertinoEmptyWidget({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: CupertinoColors.systemBlue.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
