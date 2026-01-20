import 'package:flutter/cupertino.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/predefined_location.dart';
import '../../providers/booking_flow_provider.dart';
import '../../providers/locations_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/atoms/stepper_field.dart';
import '../../widgets/molecules/date_time_picker.dart';
import '../../widgets/molecules/location_input_field.dart';
import '../../widgets/organisms/map_route_preview.dart';

/// Screen for route selection (Step 1 of booking wizard) - Cupertino style.
class RouteSelectionScreen extends ConsumerStatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  ConsumerState<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends ConsumerState<RouteSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load predefined locations
    Future.microtask(() {
      ref.read(locationsProvider.notifier).loadLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);
    final locationsState = ref.watch(locationsProvider);
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.bookTransfer),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark),
          onPressed: () => _showCancelDialog(context, l10n),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: BookingProgressIndicator(
                currentStep: 0,
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Route
                    Text(
                      l10n.route,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Map preview
                    MapRoutePreview(
                      pickupLat: bookingState.pickupLocation?.lat,
                      pickupLng: bookingState.pickupLocation?.lng,
                      dropoffLat: bookingState.dropoffLocation?.lat,
                      dropoffLng: bookingState.dropoffLocation?.lng,
                      pickupAddress: bookingState.pickupLocation?.address,
                      dropoffAddress: bookingState.dropoffLocation?.address,
                      departureDate: bookingState.serviceDate,
                      departureTime: bookingState.pickupTime,
                      height: 150,
                      interactive: true,
                      onTap: () => _openFullScreenMap(context, bookingState, l10n),
                      expandLabel: l10n.expand,
                      loadingRouteLabel: l10n.loadingRoute,
                      selectLocationsLabel: l10n.selectLocationsToSeeRoute,
                      pickupMarkerTitle: l10n.pickup,
                      dropoffMarkerTitle: l10n.dropoff,
                    ),
                    const SizedBox(height: 16),
                    // Pickup location
                    LocationInputField(
                      label: l10n.pickupLocation,
                      hint: l10n.enterAddressOrSelect,
                      icon: CupertinoIcons.location,
                      selectedAddress: bookingState.pickupLocation?.address,
                      predefinedLocations: locationsState.locations,
                      currentLocationLabel: l10n.currentLocation,
                      currentLocationSubtitle: l10n.currentLocationSubtitle,
                      chooseOnMapLabel: l10n.chooseOnMap,
                      chooseOnMapSubtitle: l10n.chooseOnMapSubtitle,
                      noMatchingLocationsLabel: l10n.noMatchingLocations,
                      onPredefinedSelected: (location) {
                        _selectPickupLocation(location);
                      },
                      onCurrentLocationTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: Text(l10n.comingSoon),
                            content: Text(l10n.gpsComingSoon),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(l10n.ok),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                            ],
                          ),
                        );
                      },
                      onCustomLocationTap: () {
                        // TODO: Open map picker
                      },
                    ),
                    const SizedBox(height: 16),
                    // Dropoff location
                    LocationInputField(
                      label: l10n.dropoffLocation,
                      hint: l10n.enterAddressOrSelect,
                      icon: CupertinoIcons.placemark,
                      selectedAddress: bookingState.dropoffLocation?.address,
                      predefinedLocations: locationsState.locations,
                      chooseOnMapLabel: l10n.chooseOnMap,
                      chooseOnMapSubtitle: l10n.chooseOnMapSubtitle,
                      noMatchingLocationsLabel: l10n.noMatchingLocations,
                      onPredefinedSelected: (location) {
                        _selectDropoffLocation(location);
                      },
                      showCurrentLocation: false,
                      onCustomLocationTap: () {
                        // TODO: Open map picker
                      },
                    ),
                    const SizedBox(height: 24),
                    // Section: Date & Time
                    Text(
                      l10n.dateTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DateTimePicker(
                      dateLabel: l10n.pickupDate,
                      timeLabel: l10n.time,
                      selectedDate: bookingState.serviceDate,
                      selectedTime: bookingState.pickupTime,
                      selectDatePlaceholder: l10n.selectDate,
                      selectTimePlaceholder: l10n.selectTime,
                      cancelLabel: l10n.cancel,
                      doneLabel: l10n.done,
                      onDateChanged: (date) {
                        ref.read(bookingFlowProvider.notifier).setServiceDate(date);
                      },
                      onTimeChanged: (time) {
                        ref.read(bookingFlowProvider.notifier).setPickupTime(time);
                      },
                      firstDate: DateTime.now(),
                    ),
                    const SizedBox(height: 16),
                    // Round trip toggle
                    _CupertinoRoundTripToggle(
                      isRoundTrip: bookingState.isRoundTrip,
                      onChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setRoundTrip(value);
                      },
                      oneWayLabel: l10n.oneWay,
                      roundTripLabel: l10n.roundTrip,
                      discountBadge: l10n.discountBadge,
                    ),
                    // Return date & time (if round trip)
                    if (bookingState.isRoundTrip) ...[
                      const SizedBox(height: 16),
                      DateTimePicker(
                        dateLabel: l10n.returnDate,
                        timeLabel: l10n.time,
                        selectedDate: bookingState.returnDate,
                        selectedTime: bookingState.returnTime,
                        selectDatePlaceholder: l10n.selectDate,
                        selectTimePlaceholder: l10n.selectTime,
                        cancelLabel: l10n.cancel,
                        doneLabel: l10n.done,
                        onDateChanged: (date) {
                          ref.read(bookingFlowProvider.notifier).setReturnDate(date);
                        },
                        onTimeChanged: (time) {
                          ref.read(bookingFlowProvider.notifier).setReturnTime(time);
                        },
                        firstDate: bookingState.serviceDate ?? DateTime.now(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Section: Passengers & Luggage
                    Text(
                      l10n.passengersAndLuggage,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StepperField(
                      label: l10n.adults,
                      value: bookingState.numPassengers,
                      minValue: 1,
                      maxValue: 25,
                      icon: CupertinoIcons.person,
                      onChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setNumPassengers(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    StepperField(
                      label: l10n.children,
                      subtitle: l10n.childrenSubtitle,
                      value: bookingState.numChildren,
                      minValue: 0,
                      maxValue: 10,
                      icon: CupertinoIcons.person_2,
                      onChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setNumChildren(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    StepperField(
                      label: l10n.largeLuggage,
                      subtitle: l10n.largeLuggageSubtitle,
                      value: bookingState.numLargeLuggage,
                      minValue: 0,
                      maxValue: 20,
                      icon: CupertinoIcons.briefcase,
                      onChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setNumLargeLuggage(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    StepperField(
                      label: l10n.smallLuggage,
                      subtitle: l10n.smallLuggageSubtitle,
                      value: bookingState.numSmallLuggage,
                      minValue: 0,
                      maxValue: 20,
                      icon: CupertinoIcons.bag,
                      onChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setNumSmallLuggage(value);
                      },
                    ),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
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
              child: GradientButton(
                text: l10n.continueToVehicle,
                onPressed: bookingState.isRouteComplete
                    ? () {
                        ref.read(bookingFlowProvider.notifier).nextStep();
                        context.push('/booking/vehicle');
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPickupLocation(PredefinedLocation location) {
    ref.read(bookingFlowProvider.notifier).setPickupLocation(
          SelectedLocation.fromPredefined(location),
        );
  }

  void _selectDropoffLocation(PredefinedLocation location) {
    ref.read(bookingFlowProvider.notifier).setDropoffLocation(
          SelectedLocation.fromPredefined(location),
        );
  }

  void _openFullScreenMap(BuildContext context, BookingFlowState bookingState, AppLocalizations l10n) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenRouteMap(
          pickupLat: bookingState.pickupLocation?.lat,
          pickupLng: bookingState.pickupLocation?.lng,
          dropoffLat: bookingState.dropoffLocation?.lat,
          dropoffLng: bookingState.dropoffLocation?.lng,
          pickupAddress: bookingState.pickupLocation?.address,
          dropoffAddress: bookingState.dropoffLocation?.address,
          routePreviewTitle: l10n.routePreview,
          closeLabel: l10n.close,
          pickupLabel: l10n.pickup,
          dropoffLabel: l10n.dropoff,
          locationSelectedLabel: l10n.locationSelected,
          loadingRouteLabel: l10n.loadingRoute,
          onPickupChanged: (location) {
            ref.read(bookingFlowProvider.notifier).setPickupLocation(
                  SelectedLocation(
                    lat: location.lat,
                    lng: location.lng,
                    address: location.address,
                  ),
                );
          },
          onDropoffChanged: (location) {
            ref.read(bookingFlowProvider.notifier).setDropoffLocation(
                  SelectedLocation(
                    lat: location.lat,
                    lng: location.lng,
                    address: location.address,
                  ),
                );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.cancelBookingTitle),
        content: Text(l10n.cancelBookingMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.continueBooking),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(bookingFlowProvider.notifier).reset();
              Navigator.of(dialogContext).pop();
              context.go('/');
            },
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

class _CupertinoRoundTripToggle extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool> onChanged;
  final String oneWayLabel;
  final String roundTripLabel;
  final String discountBadge;

  const _CupertinoRoundTripToggle({
    required this.isRoundTrip,
    required this.onChanged,
    required this.oneWayLabel,
    required this.roundTripLabel,
    required this.discountBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CupertinoTripTypeButton(
              label: oneWayLabel,
              icon: CupertinoIcons.arrow_right,
              isSelected: !isRoundTrip,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _CupertinoTripTypeButton(
              label: roundTripLabel,
              icon: CupertinoIcons.arrow_2_squarepath,
              isSelected: isRoundTrip,
              onTap: () => onChanged(true),
              badge: discountBadge,
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoTripTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  const _CupertinoTripTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.systemBlue : const Color(0x00000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? CupertinoColors.white
                  : CupertinoColors.label.resolveFrom(context),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected
                      ? CupertinoColors.white
                      : CupertinoColors.label.resolveFrom(context),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CupertinoColors.white.withValues(alpha: 0.2)
                      : CupertinoColors.systemGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
