import 'package:flutter/cupertino.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/price_breakdown.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_flow_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/organisms/booking_summary_card.dart';
import '../../widgets/organisms/price_breakdown_card.dart';

/// Screen for reviewing and confirming booking (Step 5) - Cupertino style.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _termsAccepted = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);
    final authState = ref.watch(authStateProvider);
    final showDetailedBreakdown = authState.user?.canSeeDetailedPricing ?? false;
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.reviewBooking),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () {
            ref.read(bookingFlowProvider.notifier).previousStep();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/booking/passenger');
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
              child: bookingState.isCalculating
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CupertinoActivityIndicator(radius: 16),
                          const SizedBox(height: 16),
                          Text(
                            l10n.calculatingPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    )
                  : bookingState.error != null
                      ? _CupertinoErrorWidget(
                          error: bookingState.error!,
                          errorTitle: l10n.failedToCalculatePrice,
                          retryLabel: l10n.retry,
                          onRetry: () {
                            ref
                                .read(bookingFlowProvider.notifier)
                                .calculatePrice();
                          },
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookingSummaryCard(
                                bookingState: bookingState,
                                onEditRoute: () => _goToStep(0),
                                onEditVehicle: () => _goToStep(1),
                                onEditExtras: () => _goToStep(2),
                                onEditPassenger: () => _goToStep(3),
                                routeTitle: l10n.stepRoute,
                                vehicleTitle: l10n.vehicle,
                                extrasTitle: l10n.extras,
                                passengerTitle: l10n.passenger,
                                fromLabel: l10n.from,
                                toLabel: l10n.to,
                                editLabel: l10n.edit,
                                notSelectedText: l10n.notSelected,
                                dateNotSelectedText: l10n.dateNotSelected,
                                timeNotSelectedText: l10n.timeNotSelected,
                                roundTripLabel: l10n.roundTrip,
                                flightLabel: l10n.flightNumber,
                              ),
                              const SizedBox(height: 16),
                              if (bookingState.priceCalculation != null)
                                PriceBreakdownCard(
                                  breakdown: _convertToPriceBreakdown(bookingState),
                                  showDetailedBreakdown: showDetailedBreakdown,
                                  priceBreakdownTitle: l10n.priceBreakdown,
                                  priceTitle: l10n.price,
                                  pricingTypeLabel: l10n.pricingType,
                                  fixedRouteLabel: l10n.fixedRoute,
                                  distanceBasedLabel: l10n.distanceBased,
                                  routeLabel: l10n.stepRoute,
                                  distanceLabel: l10n.distance,
                                  basePriceLabel: l10n.basePrice,
                                  multipliersAppliedLabel: l10n.multipliersApplied,
                                  vehicleMultiplierLabel: l10n.vehicleMultiplier('{name}'),
                                  passengersMultiplierLabel: l10n.passengersMultiplier(0).replaceAll('0', '{count}'),
                                  seasonMultiplierLabel: l10n.seasonMultiplierNamed('{name}'),
                                  timeMultiplierLabel: l10n.timeMultiplierNamed('{name}'),
                                  subtotalLabel: l10n.subtotal,
                                  extraServicesLabel: l10n.extraServices,
                                  extrasTotalLabel: l10n.extrasTotal,
                                  totalLabel: l10n.total,
                                  calculationFormulaLabel: l10n.calculationFormula,
                                  formulaText: l10n.formulaText,
                                  passengersText: l10n.passengers,
                                  includesExtrasText: l10n.includesExtras(0).replaceAll('0', '{count}'),
                                ),
                              const SizedBox(height: 24),
                              _CupertinoTermsCheckbox(
                                value: _termsAccepted,
                                onChanged: (value) {
                                  setState(() => _termsAccepted = value);
                                },
                                agreeText: l10n.agreeToTermsPart1,
                                termsText: l10n.termsAndConditions,
                                andText: l10n.andConnector,
                                privacyText: l10n.privacyPolicy,
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
            ),
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
                  if (bookingState.priceCalculation != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.totalPrice,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.secondaryLabel
                                      .resolveFrom(context),
                                ),
                              ),
                              Text(
                                '€${bookingState.priceCalculation!.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ],
                          ),
                          if (bookingState.isRoundTrip)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGreen
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.checkmark_circle_fill,
                                    size: 16,
                                    color: CupertinoColors.systemGreen,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.discountOff,
                                    style: const TextStyle(
                                      color: CupertinoColors.systemGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  GradientButton(
                    text: l10n.confirmBooking,
                    onPressed: _canSubmit() ? () => _submitBooking(l10n) : null,
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _termsAccepted &&
        !_isSubmitting &&
        ref.read(bookingFlowProvider).priceCalculation != null;
  }

  void _goToStep(int stepIndex) {
    final steps = [
      '/booking/route',
      '/booking/vehicle',
      '/booking/extras',
      '/booking/passenger',
    ];

    if (stepIndex < steps.length) {
      context.go(steps[stepIndex]);
    }
  }

  Future<void> _submitBooking(AppLocalizations l10n) async {
    setState(() => _isSubmitting = true);

    try {
      final bookingState = ref.read(bookingFlowProvider);
      final authState = ref.read(authStateProvider);
      final passenger = bookingState.passengerDetails!;
      final priceCalculation = bookingState.priceCalculation!;

      // Create booking via API
      final bookingResponse = await ref.read(bookingRepositoryProvider).createBooking(
        // Route
        pickupAddress: bookingState.pickupLocation!.address,
        pickupLat: bookingState.pickupLocation!.lat,
        pickupLng: bookingState.pickupLocation!.lng,
        dropoffAddress: bookingState.dropoffLocation!.address,
        dropoffLat: bookingState.dropoffLocation!.lat,
        dropoffLng: bookingState.dropoffLocation!.lng,
        serviceDate: bookingState.serviceDate!,
        pickupTime: bookingState.pickupTime!,
        // Round trip
        isRoundTrip: bookingState.isRoundTrip,
        returnDate: bookingState.returnDate,
        returnTime: bookingState.returnTime,
        // Passengers & luggage
        numPassengers: bookingState.numPassengers,
        numChildren: bookingState.numChildren,
        numLargeLuggage: bookingState.numLargeLuggage,
        numSmallLuggage: bookingState.numSmallLuggage,
        // Vehicle
        vehicleClassId: bookingState.selectedVehicle!.id,
        // Pricing
        priceCalculation: priceCalculation,
        // Customer
        customerFirstName: passenger.firstName,
        customerLastName: passenger.lastName,
        customerPhone: passenger.phone,
        customerEmail: passenger.email,
        // Trip details
        flightNumber: passenger.flightNumber,
        returnFlightNumber: passenger.returnFlightNumber,
        specialRequests: passenger.specialRequests,
      );

      // Save phone number to user profile if it changed
      final passengerPhone = passenger.phone;
      final currentUserPhone = authState.user?.phone;

      if (passengerPhone.isNotEmpty && passengerPhone != currentUserPhone) {
        await ref.read(authStateProvider.notifier).updateProfile(
          phone: passengerPhone,
        );
      }

      if (mounted) {
        await showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => CupertinoAlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: CupertinoColors.systemGreen,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Flexible(child: Text(l10n.bookingConfirmed)),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.bookingConfirmedMessage),
                  const SizedBox(height: 12),
                  Text(
                    'Ref: ${bookingResponse.bookingReference}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  ref.read(bookingFlowProvider.notifier).reset();
                  Navigator.pop(ctx);
                  context.go('/');
                },
                child: Text(l10n.done),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(l10n.bookingFailed),
            content: Text('Error: $e'),
            actions: [
              CupertinoDialogAction(
                child: Text(l10n.ok),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  PriceBreakdown _convertToPriceBreakdown(BookingFlowState state) {
    final calc = state.priceCalculation!;
    return PriceBreakdown(
      pricingType: calc.routeType,
      routeName: calc.routeName,
      distanceKm: calc.distanceKm,
      basePrice: calc.basePrice,
      vehicleClassName: state.selectedVehicle?.className ?? 'Standard',
      vehicleMultiplier: calc.vehicleMultiplier,
      passengerCount: state.numPassengers,
      passengerMultiplier: calc.passengerMultiplier,
      seasonName: calc.seasonalMultiplierLabel,
      seasonalMultiplier: calc.seasonalMultiplier,
      timeSlotName: calc.timeMultiplierLabel,
      timeMultiplier: calc.timeMultiplier,
      subtotal: calc.subtotal,
      extraFees: calc.extraFees
          .map((f) => ExtraFeeItem(
                id: f.feeCode,
                name: f.feeName,
                price: f.unitAmount,
                quantity: f.quantity,
                total: f.totalAmount,
              ))
          .toList(),
      extraFeesTotal: calc.extraFeesTotal,
      finalPrice: calc.finalPrice,
    );
  }
}

class _CupertinoTermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String agreeText;
  final String termsText;
  final String andText;
  final String privacyText;

  const _CupertinoTermsCheckbox({
    required this.value,
    required this.onChanged,
    required this.agreeText,
    required this.termsText,
    required this.andText,
    required this.privacyText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CupertinoCheckbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.label,
                  ),
                  children: [
                    TextSpan(text: agreeText),
                    TextSpan(
                      text: termsText,
                      style: const TextStyle(
                        color: CupertinoColors.systemBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: andText),
                    TextSpan(
                      text: privacyText,
                      style: const TextStyle(
                        color: CupertinoColors.systemBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
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
              CupertinoIcons.exclamationmark_circle,
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
                  const Icon(CupertinoIcons.refresh),
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
