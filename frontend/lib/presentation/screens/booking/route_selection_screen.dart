import 'package:flutter/cupertino.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/predefined_location.dart';
import '../../providers/booking_flow_provider.dart';
import '../../providers/locations_provider.dart';
import '../../widgets/atoms/booking_progress_indicator.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/atoms/route_card.dart';
import '../../widgets/molecules/location_input_field.dart';
import '../../widgets/molecules/luggage_card.dart';
import '../../widgets/molecules/passengers_card.dart';
import '../../widgets/molecules/travel_dates_card.dart';
import '../../widgets/molecules/trip_info_card.dart';
import '../../widgets/organisms/date_time_picker_modal.dart';
import '../../widgets/organisms/map_route_preview.dart';

/// Screen for route selection (Step 1 of booking wizard) - Cupertino style.
class RouteSelectionScreen extends ConsumerStatefulWidget {
  const RouteSelectionScreen({super.key});

  @override
  ConsumerState<RouteSelectionScreen> createState() =>
      _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends ConsumerState<RouteSelectionScreen> {
  /// Initial booking state when screen was opened, used to detect changes.
  BookingFlowState? _initialState;

  /// Scroll controller for scrolling to map.
  final ScrollController _scrollController = ScrollController();

  /// Key for map widget to scroll to.
  final GlobalKey _mapKey = GlobalKey();

  /// Route info from map
  String? _distanceText;
  String? _durationText;

  @override
  void initState() {
    super.initState();
    // Load predefined locations
    Future.microtask(() {
      ref.read(locationsProvider.notifier).loadLocations();
      // Capture initial state after provider is ready
      _initialState = ref.read(bookingFlowProvider);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Check if user has made any changes to the booking state.
  bool _hasUserMadeChanges(BookingFlowState currentState) {
    if (_initialState == null) return false;

    final initial = _initialState!;
    return currentState.pickupLocation?.address !=
            initial.pickupLocation?.address ||
        currentState.dropoffLocation?.address !=
            initial.dropoffLocation?.address ||
        currentState.serviceDate != initial.serviceDate ||
        currentState.pickupTime != initial.pickupTime ||
        currentState.isRoundTrip != initial.isRoundTrip ||
        currentState.returnDate != initial.returnDate ||
        currentState.returnTime != initial.returnTime ||
        currentState.numPassengers != initial.numPassengers ||
        currentState.numChildSeats != initial.numChildSeats ||
        currentState.numBoosterSeats != initial.numBoosterSeats ||
        currentState.numLargeLuggage != initial.numLargeLuggage ||
        currentState.numSmallLuggage != initial.numSmallLuggage ||
        currentState.numSurfboardsBikesGolf !=
            initial.numSurfboardsBikesGolf ||
        currentState.numSkiSnowboard != initial.numSkiSnowboard ||
        currentState.hasOtherSportsEquipment !=
            initial.hasOtherSportsEquipment ||
        currentState.otherSportsEquipmentDetails !=
            initial.otherSportsEquipmentDetails;
  }

  void _scrollToMap() {
    final context = _mapKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
          onPressed: () => _handleClose(context, bookingState, l10n),
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
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Your Route
                    RouteCard(
                      title: l10n.yourRoute,
                      trailing: _MapIconButton(
                        onTap: _scrollToMap,
                      ),
                      child: Stack(
                        children: [
                          // Connection line between pickup and dropoff
                          Positioned(
                            left: 12,
                            top: 40,
                            bottom: 40,
                            child: Container(
                              width: 2,
                              color: CupertinoColors.separator.resolveFrom(context),
                            ),
                          ),
                          // Location inputs
                          Column(
                            children: [
                              // Pickup location
                              Padding(
                                padding: const EdgeInsets.only(right: 70),
                                child: LocationInputField(
                                  label: l10n.pickupLocation,
                                  hint: l10n.enterAddressOrSelect,
                                  icon: CupertinoIcons.scope,
                                  iconColor: CupertinoColors.systemBlue,
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
                                  onCustomAddressSelected: (customLocation) {
                                    ref.read(bookingFlowProvider.notifier).setPickupLocation(
                                      SelectedLocation(
                                        lat: customLocation.lat,
                                        lng: customLocation.lng,
                                        address: customLocation.address,
                                      ),
                                    );
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
                              ),
                              const SizedBox(height: 15),
                              // Dropoff location
                              Padding(
                                padding: const EdgeInsets.only(right: 70),
                                child: LocationInputField(
                                  label: l10n.dropoffLocation,
                                  hint: l10n.enterAddressOrSelect,
                                  icon: CupertinoIcons.circle_fill,
                                  iconColor: const Color(0xFFDC143C),
                                  selectedAddress: bookingState.dropoffLocation?.address,
                                  predefinedLocations: locationsState.locations,
                                  chooseOnMapLabel: l10n.chooseOnMap,
                                  chooseOnMapSubtitle: l10n.chooseOnMapSubtitle,
                                  noMatchingLocationsLabel: l10n.noMatchingLocations,
                                  onPredefinedSelected: (location) {
                                    _selectDropoffLocation(location);
                                  },
                                  onCustomAddressSelected: (customLocation) {
                                    ref.read(bookingFlowProvider.notifier).setDropoffLocation(
                                      SelectedLocation(
                                        lat: customLocation.lat,
                                        lng: customLocation.lng,
                                        address: customLocation.address,
                                      ),
                                    );
                                  },
                                  showCurrentLocation: false,
                                  onCustomLocationTap: () {
                                    // TODO: Open map picker
                                  },
                                ),
                              ),
                            ],
                          ),
                          // Swap button positioned at the right side between inputs
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _SwapButton(
                                onTap: () {
                                  ref.read(bookingFlowProvider.notifier).swapLocations();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 2: Travel Dates
                    TravelDatesCard(
                      isRoundTrip: bookingState.isRoundTrip,
                      onRoundTripChanged: (value) {
                        ref.read(bookingFlowProvider.notifier).setRoundTrip(value);
                      },
                      outboundDate: bookingState.serviceDate,
                      outboundTime: bookingState.pickupTime,
                      isOutboundArrival: bookingState.isPickupTimeArrival,
                      onOutboundTap: () => _showDateTimePicker(
                        context: context,
                        l10n: l10n,
                        initialDate: bookingState.serviceDate ?? DateTime.now(),
                        initialTime: bookingState.pickupTime,
                        isArrival: bookingState.isPickupTimeArrival,
                        onResult: (result) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setServiceDate(result.date);
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setPickupTime(result.time);
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setPickupTimeMode(result.isArrival);
                        },
                      ),
                      onOutboundNowTap: () {
                        final now = DateTime.now();
                        ref.read(bookingFlowProvider.notifier).setServiceDate(
                              DateTime(now.year, now.month, now.day),
                            );
                        final nextHour = now.hour + 1;
                        final time = nextHour >= 24
                            ? '00:00'
                            : '${nextHour.toString().padLeft(2, '0')}:00';
                        ref.read(bookingFlowProvider.notifier).setPickupTime(time);
                      },
                      returnDate: bookingState.returnDate,
                      returnTime: bookingState.returnTime,
                      isReturnArrival: bookingState.isReturnTimeArrival,
                      onReturnTap: () => _showDateTimePicker(
                        context: context,
                        l10n: l10n,
                        initialDate: bookingState.returnDate ??
                            bookingState.serviceDate ??
                            DateTime.now(),
                        initialTime: bookingState.returnTime,
                        isArrival: bookingState.isReturnTimeArrival,
                        onResult: (result) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setReturnDate(result.date);
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setReturnTime(result.time);
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setReturnTimeMode(result.isArrival);
                        },
                      ),
                      onReturnNowTap: () {
                        final now = DateTime.now();
                        ref.read(bookingFlowProvider.notifier).setReturnDate(
                              DateTime(now.year, now.month, now.day),
                            );
                        final nextHour = now.hour + 1;
                        final time = nextHour >= 24
                            ? '00:00'
                            : '${nextHour.toString().padLeft(2, '0')}:00';
                        ref.read(bookingFlowProvider.notifier).setReturnTime(time);
                      },
                      durationMinutes: bookingState.durationMinutes,
                      travelDateLabel: l10n.travelDate,
                      travelDatesLabel: l10n.travelDates,
                      roundTripLabel: l10n.roundTrip,
                      discountText: l10n.discountBadge,
                      outboundLabel: l10n.outbound,
                      returnLabel: l10n.returnTrip,
                      departureAbbrev: l10n.departureAbbrev,
                      arrivalAbbrev: l10n.arrivalAbbrev,
                      nowLabel: l10n.now,
                    ),
                    const SizedBox(height: 20),

                    // Card 3: Trip Info
                    TripInfoCard(
                      distanceText: _distanceText,
                      durationText: _durationText,
                      distanceLabel: l10n.distanceLabel,
                      durationLabel: l10n.durationLabel,
                      onTap: _scrollToMap,
                    ),
                    const SizedBox(height: 20),

                    // Card 4: Passengers
                    RouteCard(
                      title: l10n.passengersCard,
                      titleIcon: CupertinoIcons.person_2,
                      child: PassengersCard(
                        adults: bookingState.numPassengers,
                        onAdultsChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumPassengers(value);
                        },
                        adultsLabel: l10n.adults,
                        childSeats: bookingState.numChildSeats,
                        onChildSeatsChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumChildSeats(value);
                        },
                        childSeatsLabel: l10n.childSeats,
                        childSeatsSubtitle: l10n.childSeatsSubtitle,
                        boosterSeats: bookingState.numBoosterSeats,
                        onBoosterSeatsChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumBoosterSeats(value);
                        },
                        boosterSeatsLabel: l10n.boosterSeats,
                        boosterSeatsSubtitle: l10n.boosterSeatsSubtitle,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 5: Luggage
                    RouteCard(
                      title: l10n.luggageCard,
                      titleIcon: CupertinoIcons.briefcase,
                      child: LuggageCard(
                        largeLuggage: bookingState.numLargeLuggage,
                        onLargeLuggageChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumLargeLuggage(value);
                        },
                        largeLabel: l10n.large,
                        largeSubtitle: l10n.largeLuggageSubtitle,
                        surfboardBikeGolf: bookingState.numSurfboardsBikesGolf,
                        onSurfboardBikeGolfChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumSurfboardsBikesGolf(value);
                        },
                        surfboardBikeGolfLabel: l10n.surfboardBikeGolf,
                        skiSnowboard: bookingState.numSkiSnowboard,
                        onSkiSnowboardChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumSkiSnowboard(value);
                        },
                        skiSnowboardLabel: l10n.skiSnowboard,
                        hasOtherSports: bookingState.hasOtherSportsEquipment,
                        otherSportsDetails:
                            bookingState.otherSportsEquipmentDetails,
                        onOtherSportsChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setOtherSportsEquipment(
                                value,
                                value
                                    ? bookingState.otherSportsEquipmentDetails
                                    : null,
                              );
                        },
                        onOtherSportsDetailsChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setOtherSportsEquipment(true, value);
                        },
                        otherSportsLabel: l10n.otherSportsEquipment,
                        otherSportsPlaceholder: l10n.otherSportsPlaceholder,
                        smallLuggage: bookingState.numSmallLuggage,
                        onSmallLuggageChanged: (value) {
                          ref
                              .read(bookingFlowProvider.notifier)
                              .setNumSmallLuggage(value);
                        },
                        smallLabel: l10n.small,
                        smallSubtitle: l10n.smallLuggageSubtitle,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 6: Map Preview (matching HTML: border-radius 20px, shadow, overflow hidden)
                    Container(
                      key: _mapKey,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: MapRoutePreview(
                        pickupLat: bookingState.pickupLocation?.lat,
                        pickupLng: bookingState.pickupLocation?.lng,
                        dropoffLat: bookingState.dropoffLocation?.lat,
                        dropoffLng: bookingState.dropoffLocation?.lng,
                        pickupAddress: bookingState.pickupLocation?.address,
                        dropoffAddress: bookingState.dropoffLocation?.address,
                        departureDate: bookingState.serviceDate,
                        departureTime: bookingState.pickupTime,
                        height: 400,
                        interactive: true,
                        onTap: () =>
                            _openFullScreenMap(context, bookingState, l10n),
                        expandLabel: l10n.expand,
                        loadingRouteLabel: l10n.loadingRoute,
                        selectLocationsLabel: l10n.selectLocationsToSeeRoute,
                        pickupMarkerTitle: l10n.pickup,
                        dropoffMarkerTitle: l10n.dropoff,
                        onRouteInfoChanged: (distance, duration, durationMinutes) {
                          setState(() {
                            _distanceText = distance;
                            _durationText = duration;
                          });
                          if (durationMinutes != null) {
                            ref.read(bookingFlowProvider.notifier).setDurationMinutes(durationMinutes);
                          }
                        },
                      ),
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

  void _showDateTimePicker({
    required BuildContext context,
    required AppLocalizations l10n,
    required DateTime initialDate,
    String? initialTime,
    required bool isArrival,
    required void Function(DateTimePickerResult) onResult,
  }) async {
    final result = await DateTimePickerModal.show(
      context: context,
      initialDate: initialDate,
      initialTime: initialTime,
      isArrival: isArrival,
      departureLabel: l10n.departure,
      arrivalLabel: l10n.arrival,
      hourLabel: l10n.hour,
      minuteLabel: l10n.minute,
      applyLabel: l10n.applyButton,
      todayLabel: l10n.today,
    );

    if (result != null) {
      onResult(result);
    }
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

  void _openFullScreenMap(
      BuildContext context, BookingFlowState bookingState, AppLocalizations l10n) {
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

  void _handleClose(
      BuildContext context, BookingFlowState currentState, AppLocalizations l10n) {
    // If user hasn't made any changes, just navigate back without dialog
    if (!_hasUserMadeChanges(currentState)) {
      ref.read(bookingFlowProvider.notifier).reset();
      context.go('/');
      return;
    }

    // Show confirmation dialog only if user has made changes
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

/// Blue map icon button for header - scrolls to map.
class _MapIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MapIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemBlue,
        ),
        child: const Icon(
          CupertinoIcons.map,
          size: 18,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}

/// Swap button for exchanging pickup and dropoff locations.
class _SwapButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SwapButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 2,
          ),
        ),
        child: Icon(
          CupertinoIcons.arrow_up_arrow_down,
          size: 28,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
      ),
    );
  }
}
