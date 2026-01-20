import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config/env_config.dart';

/// Default center point for the map
const _defaultCenter = LatLng(39.2238, 9.1217);
const _defaultZoom = 10.0;

/// A widget displaying Google Maps with route preview - Cupertino style.
class MapRoutePreview extends StatefulWidget {
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? departureDate;
  final String? departureTime; // Format: "HH:mm"
  final double height;
  final bool interactive;
  final bool showRouteInfo;
  final VoidCallback? onTap;
  // Localized strings
  final String? expandLabel;
  final String? loadingRouteLabel;
  final String? selectLocationsLabel;
  final String? pickupMarkerTitle;
  final String? dropoffMarkerTitle;

  const MapRoutePreview({
    super.key,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.pickupAddress,
    this.dropoffAddress,
    this.departureDate,
    this.departureTime,
    this.height = 200,
    this.interactive = false,
    this.showRouteInfo = true,
    this.onTap,
    this.expandLabel,
    this.loadingRouteLabel,
    this.selectLocationsLabel,
    this.pickupMarkerTitle,
    this.dropoffMarkerTitle,
  });

  bool get hasPickup => pickupLat != null && pickupLng != null;
  bool get hasDropoff => dropoffLat != null && dropoffLng != null;
  bool get hasRoute => hasPickup && hasDropoff;

  @override
  State<MapRoutePreview> createState() => _MapRoutePreviewState();
}

class _MapRoutePreviewState extends State<MapRoutePreview> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
  String? _distanceText;
  String? _durationText;
  String? _durationInTrafficText;

  @override
  void initState() {
    super.initState();
    if (widget.hasRoute) {
      _fetchRoute();
    }
  }

  @override
  void didUpdateWidget(MapRoutePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    final routeChanged = widget.pickupLat != oldWidget.pickupLat ||
        widget.pickupLng != oldWidget.pickupLng ||
        widget.dropoffLat != oldWidget.dropoffLat ||
        widget.dropoffLng != oldWidget.dropoffLng;
    final timeChanged = widget.departureDate != oldWidget.departureDate ||
        widget.departureTime != oldWidget.departureTime;

    if (routeChanged || timeChanged) {
      _updateCamera();
      if (widget.hasRoute) {
        _fetchRoute();
      } else {
        setState(() {
          _routePoints = [];
          _distanceText = null;
          _durationText = null;
          _durationInTrafficText = null;
        });
      }
    }
  }

  /// Calculate departure time in seconds since epoch for traffic prediction
  int? _getDepartureTimeSeconds() {
    if (widget.departureDate == null || widget.departureTime == null) {
      return null;
    }

    final timeParts = widget.departureTime!.split(':');
    if (timeParts.length != 2) return null;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return null;

    final departureDateTime = DateTime(
      widget.departureDate!.year,
      widget.departureDate!.month,
      widget.departureDate!.day,
      hour,
      minute,
    );

    // Only use departure_time if it's in the future
    if (departureDateTime.isAfter(DateTime.now())) {
      return departureDateTime.millisecondsSinceEpoch ~/ 1000;
    }
    return null;
  }

  Future<void> _fetchRoute() async {
    if (!widget.hasRoute) return;

    setState(() => _isLoadingRoute = true);

    try {
      final polylinePoints = PolylinePoints();
      final departureTime = _getDepartureTimeSeconds();

      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: EnvConfig.googleMapsApiKey,
        request: PolylineRequest(
          origin: PointLatLng(widget.pickupLat!, widget.pickupLng!),
          destination: PointLatLng(widget.dropoffLat!, widget.dropoffLng!),
          mode: TravelMode.driving,
          departureTime: departureTime,
        ),
      );

      if (result.points.isNotEmpty && mounted) {
        setState(() {
          _routePoints = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          _distanceText = result.distanceTexts?.isNotEmpty == true
              ? result.distanceTexts!.first
              : null;
          _durationText = result.durationTexts?.isNotEmpty == true
              ? result.durationTexts!.first
              : null;
          // Duration in traffic is typically returned when departure_time is set
          _durationInTrafficText = _durationText;
          _isLoadingRoute = false;
        });
        // Update camera to fit the route after polyline is loaded
        _updateCamera();
      } else {
        _useFallbackRoute();
      }
    } catch (e) {
      _useFallbackRoute();
    }
  }

  void _useFallbackRoute() {
    // Note: This fallback uses a straight line because Google Directions API
    // is not enabled or the API key doesn't have permission.
    // To show real routes, enable Directions API in Google Cloud Console.
    if (mounted && widget.hasRoute) {
      // Calculate approximate distance using Haversine formula
      final distance = _calculateStraightLineDistance();

      setState(() {
        _routePoints = [
          LatLng(widget.pickupLat!, widget.pickupLng!),
          LatLng(widget.dropoffLat!, widget.dropoffLng!),
        ];
        _distanceText = '~${distance.toStringAsFixed(1)} km';
        _durationText = '~${(distance / 50 * 60).round()} min';
        _durationInTrafficText = null;
        _isLoadingRoute = false;
      });
      // Update camera to fit the route
      _updateCamera();
    }
  }

  double _calculateStraightLineDistance() {
    const double earthRadius = 6371; // km
    final dLat = (widget.dropoffLat! - widget.pickupLat!) * math.pi / 180;
    final dLon = (widget.dropoffLng! - widget.pickupLng!) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(widget.pickupLat! * math.pi / 180) *
            math.cos(widget.dropoffLat! * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _updateCamera() async {
    if (!_controller.isCompleted) return;

    final controller = await _controller.future;

    if (widget.hasRoute) {
      // Calculate bounds from route points if available, otherwise use pickup/dropoff
      LatLngBounds bounds;
      if (_routePoints.length > 2) {
        // Use polyline bounds for better fit
        double minLat = _routePoints.first.latitude;
        double maxLat = _routePoints.first.latitude;
        double minLng = _routePoints.first.longitude;
        double maxLng = _routePoints.first.longitude;

        for (final point in _routePoints) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLng) minLng = point.longitude;
          if (point.longitude > maxLng) maxLng = point.longitude;
        }

        bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(
            widget.pickupLat! < widget.dropoffLat!
                ? widget.pickupLat!
                : widget.dropoffLat!,
            widget.pickupLng! < widget.dropoffLng!
                ? widget.pickupLng!
                : widget.dropoffLng!,
          ),
          northeast: LatLng(
            widget.pickupLat! > widget.dropoffLat!
                ? widget.pickupLat!
                : widget.dropoffLat!,
            widget.pickupLng! > widget.dropoffLng!
                ? widget.pickupLng!
                : widget.dropoffLng!,
          ),
        );
      }
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else if (widget.hasPickup) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(widget.pickupLat!, widget.pickupLng!),
        14,
      ));
    } else if (widget.hasDropoff) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(widget.dropoffLat!, widget.dropoffLng!),
        14,
      ));
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (widget.hasPickup) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(widget.pickupLat!, widget.pickupLng!),
        infoWindow: InfoWindow(
          title: widget.pickupMarkerTitle ?? 'Pickup',
          snippet: widget.pickupAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    if (widget.hasDropoff) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(widget.dropoffLat!, widget.dropoffLng!),
        infoWindow: InfoWindow(
          title: widget.dropoffMarkerTitle ?? 'Dropoff',
          snippet: widget.dropoffAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_routePoints.isEmpty) return {};

    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints,
        color: CupertinoColors.systemBlue,
        width: 4,
      ),
    };
  }

  LatLng _getInitialCenter() {
    if (widget.hasRoute) {
      return LatLng(
        (widget.pickupLat! + widget.dropoffLat!) / 2,
        (widget.pickupLng! + widget.dropoffLng!) / 2,
      );
    } else if (widget.hasPickup) {
      return LatLng(widget.pickupLat!, widget.pickupLng!);
    } else if (widget.hasDropoff) {
      return LatLng(widget.dropoffLat!, widget.dropoffLng!);
    }
    return _defaultCenter;
  }

  double _getInitialZoom() {
    if (widget.hasRoute) return 8;
    if (widget.hasPickup || widget.hasDropoff) return 14;
    return _defaultZoom;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.interactive ? widget.onTap : null,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _getInitialCenter(),
                  zoom: _getInitialZoom(),
                ),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    _updateCamera,
                  );
                },
                markers: _buildMarkers(),
                polylines: _buildPolylines(),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: widget.interactive,
                zoomGesturesEnabled: widget.interactive,
                tiltGesturesEnabled: false,
                // Disabled lite mode to show polylines properly
                liteModeEnabled: false,
              ),
              // Tap overlay for interactive maps
              if (widget.interactive && widget.onTap != null)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context)
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.fullscreen,
                          size: 16,
                          color: CupertinoColors.systemBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.expandLabel ?? 'Expand',
                          style: const TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Route info badge (distance & duration)
              if (widget.showRouteInfo &&
                  widget.hasRoute &&
                  !_isLoadingRoute &&
                  (_distanceText != null || _durationText != null))
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context)
                          .withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_distanceText != null) ...[
                          const Icon(
                            CupertinoIcons.map,
                            size: 14,
                            color: CupertinoColors.systemBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _distanceText!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                        if (_distanceText != null && _durationText != null)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 1,
                            height: 14,
                            color: CupertinoColors.separator,
                          ),
                        if (_durationText != null) ...[
                          const Icon(
                            CupertinoIcons.clock,
                            size: 14,
                            color: CupertinoColors.systemGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _durationText!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              // Loading route indicator
              if (_isLoadingRoute)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context)
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CupertinoActivityIndicator(radius: 6),
                        const SizedBox(width: 6),
                        Text(
                          widget.loadingRouteLabel ?? 'Loading route...',
                          style: const TextStyle(
                            fontSize: 11,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Empty state overlay
              if (!widget.hasPickup && !widget.hasDropoff)
                Container(
                  color: CupertinoColors.systemBackground
                      .resolveFrom(context)
                      .withValues(alpha: 0.7),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          size: 40,
                          color: CupertinoColors.systemBlue.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.selectLocationsLabel ?? 'Select locations to see route',
                          style: TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.secondaryLabel
                                .resolveFrom(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen map for route selection - Cupertino style.
class FullScreenMapPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final bool isPickup;
  final ValueChanged<MapLocation>? onLocationSelected;
  // Localized strings
  final String? selectPickupLocationTitle;
  final String? selectDropoffLocationTitle;
  final String? pickupLocationLabel;
  final String? dropoffLocationLabel;
  final String? moveMapLabel;
  final String? confirmPickupLabel;
  final String? confirmDropoffLabel;

  const FullScreenMapPicker({
    super.key,
    this.initialLat,
    this.initialLng,
    this.isPickup = true,
    this.onLocationSelected,
    this.selectPickupLocationTitle,
    this.selectDropoffLocationTitle,
    this.pickupLocationLabel,
    this.dropoffLocationLabel,
    this.moveMapLabel,
    this.confirmPickupLabel,
    this.confirmDropoffLabel,
  });

  @override
  State<FullScreenMapPicker> createState() => _FullScreenMapPickerState();
}

class _FullScreenMapPickerState extends State<FullScreenMapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _selectedPosition;
  late String _address;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _address = widget.moveMapLabel ?? 'Move the map to select location';
    _selectedPosition = widget.initialLat != null && widget.initialLng != null
        ? LatLng(widget.initialLat!, widget.initialLng!)
        : _defaultCenter;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedPosition = position.target;
    });
  }

  void _onCameraIdle() {
    _reverseGeocode();
  }

  Future<void> _reverseGeocode() async {
    if (_selectedPosition == null) return;

    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
      _address =
          '${_selectedPosition!.latitude.toStringAsFixed(5)}, ${_selectedPosition!.longitude.toStringAsFixed(5)}';
    });
  }

  void _confirmSelection() {
    if (_selectedPosition == null) return;

    widget.onLocationSelected?.call(MapLocation(
      lat: _selectedPosition!.latitude,
      lng: _selectedPosition!.longitude,
      address: _address,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final markerColor =
        widget.isPickup ? CupertinoColors.systemGreen : CupertinoColors.systemRed;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.isPickup
              ? (widget.selectPickupLocationTitle ?? 'Select Pickup Location')
              : (widget.selectDropoffLocationTitle ?? 'Select Dropoff Location'),
        ),
      ),
      child: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition ?? _defaultCenter,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
          ),
          // Center marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Icon(
                CupertinoIcons.placemark_fill,
                size: 48,
                color: markerColor,
              ),
            ),
          ),
          // Address card
          Positioned(
            left: 16,
            right: 16,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isPickup
                        ? CupertinoIcons.location
                        : CupertinoIcons.placemark,
                    color: markerColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.isPickup
                              ? (widget.pickupLocationLabel ?? 'Pickup Location')
                              : (widget.dropoffLocationLabel ?? 'Dropoff Location'),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                CupertinoColors.secondaryLabel.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_isLoading)
                          const CupertinoActivityIndicator(radius: 8)
                        else
                          Text(
                            _address,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.label,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Confirm button
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: CupertinoButton(
              color: markerColor,
              borderRadius: BorderRadius.circular(12),
              onPressed: _confirmSelection,
              child: Text(
                widget.isPickup
                    ? (widget.confirmPickupLabel ?? 'Confirm Pickup')
                    : (widget.confirmDropoffLabel ?? 'Confirm Dropoff'),
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Location data from map selection.
class MapLocation {
  final double lat;
  final double lng;
  final String address;

  const MapLocation({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

/// Full-screen map showing the complete route - Cupertino style.
class FullScreenRouteMap extends StatefulWidget {
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? pickupAddress;
  final String? dropoffAddress;
  final ValueChanged<MapLocation>? onPickupChanged;
  final ValueChanged<MapLocation>? onDropoffChanged;
  // Localized strings
  final String? routePreviewTitle;
  final String? closeLabel;
  final String? pickupLabel;
  final String? dropoffLabel;
  final String? locationSelectedLabel;
  final String? loadingRouteLabel;

  const FullScreenRouteMap({
    super.key,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.pickupAddress,
    this.dropoffAddress,
    this.onPickupChanged,
    this.onDropoffChanged,
    this.routePreviewTitle,
    this.closeLabel,
    this.pickupLabel,
    this.dropoffLabel,
    this.locationSelectedLabel,
    this.loadingRouteLabel,
  });

  bool get hasPickup => pickupLat != null && pickupLng != null;
  bool get hasDropoff => dropoffLat != null && dropoffLng != null;
  bool get hasRoute => hasPickup && hasDropoff;

  @override
  State<FullScreenRouteMap> createState() => _FullScreenRouteMapState();
}

class _FullScreenRouteMapState extends State<FullScreenRouteMap> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
  double? _distanceKm;
  String? _duration;

  @override
  void initState() {
    super.initState();
    if (widget.hasRoute) {
      _fetchRoute();
    }
  }

  Future<void> _fetchRoute() async {
    if (!widget.hasRoute) return;

    setState(() {
      _isLoadingRoute = true;
    });

    try {
      // Use Google Directions API via flutter_polyline_points
      final polylinePoints = PolylinePoints();
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: EnvConfig.googleMapsApiKey,
        request: PolylineRequest(
          origin: PointLatLng(widget.pickupLat!, widget.pickupLng!),
          destination: PointLatLng(widget.dropoffLat!, widget.dropoffLng!),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        final points = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Parse distance and duration from result
        double? distance;
        String? duration;

        if (result.distanceTexts != null && result.distanceTexts!.isNotEmpty) {
          final distanceText = result.distanceTexts!.first;
          // Parse "XX.X km" format
          final match = RegExp(r'([\d.]+)').firstMatch(distanceText);
          if (match != null) {
            distance = double.tryParse(match.group(1)!);
          }
        }

        if (result.durationTexts != null && result.durationTexts!.isNotEmpty) {
          duration = result.durationTexts!.first;
        }

        if (mounted) {
          setState(() {
            _routePoints = points;
            _distanceKm = distance ?? _calculateDistance(
              LatLng(widget.pickupLat!, widget.pickupLng!),
              LatLng(widget.dropoffLat!, widget.dropoffLng!),
            );
            _duration = duration ?? '${(_distanceKm! / 50 * 60).round()} min';
            _isLoadingRoute = false;
          });
        }
      } else {
        _useStraightLine();
      }
    } catch (e) {
      _useStraightLine();
    }

    _fitBounds();
  }

  void _useStraightLine() {
    final distance = _calculateDistance(
      LatLng(widget.pickupLat!, widget.pickupLng!),
      LatLng(widget.dropoffLat!, widget.dropoffLng!),
    );

    if (mounted) {
      setState(() {
        _routePoints = [
          LatLng(widget.pickupLat!, widget.pickupLng!),
          LatLng(widget.dropoffLat!, widget.dropoffLng!),
        ];
        _distanceKm = distance;
        _duration = '${(distance / 50 * 60).round()} min';
        _isLoadingRoute = false;
      });
    }
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    // Haversine formula
    const double earthRadius = 6371;
    final dLat = (p2.latitude - p1.latitude) * math.pi / 180;
    final dLon = (p2.longitude - p1.longitude) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(p1.latitude * math.pi / 180) *
            math.cos(p2.latitude * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _fitBounds() async {
    if (!_controller.isCompleted || !widget.hasRoute) return;

    final controller = await _controller.future;
    final bounds = LatLngBounds(
      southwest: LatLng(
        widget.pickupLat! < widget.dropoffLat! ? widget.pickupLat! : widget.dropoffLat!,
        widget.pickupLng! < widget.dropoffLng! ? widget.pickupLng! : widget.dropoffLng!,
      ),
      northeast: LatLng(
        widget.pickupLat! > widget.dropoffLat! ? widget.pickupLat! : widget.dropoffLat!,
        widget.pickupLng! > widget.dropoffLng! ? widget.pickupLng! : widget.dropoffLng!,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (widget.hasPickup) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(widget.pickupLat!, widget.pickupLng!),
        infoWindow: InfoWindow(
          title: widget.pickupLabel ?? 'Pickup',
          snippet: widget.pickupAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    if (widget.hasDropoff) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(widget.dropoffLat!, widget.dropoffLng!),
        infoWindow: InfoWindow(
          title: widget.dropoffLabel ?? 'Dropoff',
          snippet: widget.dropoffAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_routePoints.isEmpty) return {};

    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints,
        color: CupertinoColors.systemBlue,
        width: 5,
      ),
    };
  }

  LatLng _getInitialCenter() {
    if (widget.hasRoute) {
      return LatLng(
        (widget.pickupLat! + widget.dropoffLat!) / 2,
        (widget.pickupLng! + widget.dropoffLng!) / 2,
      );
    } else if (widget.hasPickup) {
      return LatLng(widget.pickupLat!, widget.pickupLng!);
    } else if (widget.hasDropoff) {
      return LatLng(widget.dropoffLat!, widget.dropoffLng!);
    }
    return _defaultCenter;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.routePreviewTitle ?? 'Route Preview'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(widget.closeLabel ?? 'Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _getInitialCenter(),
              zoom: widget.hasRoute ? 10 : 14,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
              Future.delayed(const Duration(milliseconds: 300), _fitBounds);
            },
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
          ),
          // Route info card
          if (widget.hasRoute)
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pickup
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.circle_fill,
                          size: 12,
                          color: CupertinoColors.systemGreen,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.pickupLabel ?? 'Pickup',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: CupertinoColors.secondaryLabel
                                      .resolveFrom(context),
                                ),
                              ),
                              Text(
                                widget.pickupAddress ?? (widget.locationSelectedLabel ?? 'Location selected'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.label,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 2,
                            height: 24,
                            color: CupertinoColors.separator.resolveFrom(context),
                          ),
                          const SizedBox(width: 22),
                          if (_isLoadingRoute)
                            const CupertinoActivityIndicator(radius: 8)
                          else if (_distanceKm != null && _duration != null)
                            Text(
                              '${_distanceKm!.toStringAsFixed(1)} km • $_duration',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel
                                    .resolveFrom(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Dropoff
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.placemark_fill,
                          size: 12,
                          color: CupertinoColors.systemRed,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dropoffLabel ?? 'Dropoff',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: CupertinoColors.secondaryLabel
                                      .resolveFrom(context),
                                ),
                              ),
                              Text(
                                widget.dropoffAddress ?? (widget.locationSelectedLabel ?? 'Location selected'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.label,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Loading overlay
          if (_isLoadingRoute)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CupertinoActivityIndicator(radius: 8),
                      const SizedBox(width: 8),
                      Text(
                        widget.loadingRouteLabel ?? 'Loading route...',
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.label,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
