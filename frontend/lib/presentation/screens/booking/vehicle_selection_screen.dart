import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/booking_flow_provider.dart';
import '../../providers/vehicles_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/molecules/vehicle_card.dart';

/// Screen for vehicle selection (Step 2 of booking wizard) - Cupertino style.
class VehicleSelectionScreen extends ConsumerStatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  ConsumerState<VehicleSelectionScreen> createState() =>
      _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends ConsumerState<VehicleSelectionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final bookingState = ref.read(bookingFlowProvider);
      // Total passengers = adults + toddlers (child seats) + children (boosters)
      final totalPassengers = bookingState.numPassengers +
          bookingState.numChildSeats + bookingState.numBoosterSeats;
      ref.read(availableVehiclesProvider.notifier).loadAvailableVehicles(
            numPassengers: totalPassengers,
            numLargeLuggage: bookingState.numLargeLuggage,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);
    final vehiclesState = ref.watch(availableVehiclesProvider);
    final l10n = AppLocalizations.of(context);
    // Total passengers = adults + toddlers (child seats) + children (boosters)
    final totalPassengers = bookingState.numPassengers +
        bookingState.numChildSeats + bookingState.numBoosterSeats;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.selectVehicle),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            ref.read(bookingFlowProvider.notifier).previousStep();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/booking');
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
            // Info banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      // Show detailed info if there are toddlers or children
                      (bookingState.numChildSeats > 0 || bookingState.numBoosterSeats > 0)
                          ? l10n.passengersDetailedInfo(
                              totalPassengers,
                              bookingState.numChildSeats,
                              bookingState.numBoosterSeats,
                              bookingState.numLargeLuggage,
                            )
                          : l10n.passengersAndBagsInfo(
                              totalPassengers,
                              bookingState.numLargeLuggage,
                            ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: vehiclesState.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : vehiclesState.error != null
                      ? _CupertinoErrorWidget(
                          error: vehiclesState.error!,
                          errorTitle: l10n.failedToLoadVehicles,
                          retryLabel: l10n.retry,
                          onRetry: () {
                            final bs = ref.read(bookingFlowProvider);
                            final total = bs.numPassengers +
                                bs.numChildSeats + bs.numBoosterSeats;
                            ref
                                .read(availableVehiclesProvider.notifier)
                                .loadAvailableVehicles(
                                  numPassengers: total,
                                  numLargeLuggage: bs.numLargeLuggage,
                                );
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: vehiclesState.availableClasses.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehiclesState.availableClasses[index];
                            final isSelected =
                                bookingState.selectedVehicle?.id == vehicle.id;

                            // Check both capacity AND tier level
                            final isBelowMinTier = vehicle.tierLevel < vehiclesState.minTier;
                            final isCapacityInsufficient = vehicle.maxPassengers <
                                    totalPassengers ||
                                vehicle.maxLargeLuggage <
                                    bookingState.numLargeLuggage;
                            final isDisabled = isBelowMinTier || isCapacityInsufficient;

                            String? disabledReason;
                            if (isBelowMinTier) {
                              disabledReason = l10n.notSuitableForPassengersAndBags(
                                totalPassengers,
                                bookingState.numLargeLuggage,
                              );
                            } else if (vehicle.maxPassengers < totalPassengers) {
                              disabledReason = l10n.maxPassengers(vehicle.maxPassengers);
                            } else if (vehicle.maxLargeLuggage <
                                bookingState.numLargeLuggage) {
                              disabledReason = l10n.maxLargeBags(vehicle.maxLargeLuggage);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: VehicleCard(
                                vehicle: vehicle,
                                isSelected: isSelected,
                                isDisabled: isDisabled,
                                disabledReason: disabledReason,
                                onTap: () {
                                  ref
                                      .read(bookingFlowProvider.notifier)
                                      .selectVehicle(vehicle);
                                },
                              ),
                            );
                          },
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
                  if (bookingState.selectedVehicle != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: CupertinoColors.systemGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.selectedVehicle(bookingState.selectedVehicle!.className),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.label,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  GradientButton(
                    text: l10n.continueToExtras,
                    onPressed: bookingState.isVehicleComplete
                        ? () {
                            ref.read(bookingFlowProvider.notifier).nextStep();
                            context.push('/booking/extras');
                          }
                        : null,
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
