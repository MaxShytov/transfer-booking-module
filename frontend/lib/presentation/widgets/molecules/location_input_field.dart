import 'dart:async';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/predefined_location.dart';
import '../../../data/services/google_places_service.dart';

/// Model for a custom location selected via Google Places.
class CustomLocation {
  final String address;
  final double lat;
  final double lng;
  final String? placeId;

  CustomLocation({
    required this.address,
    required this.lat,
    required this.lng,
    this.placeId,
  });
}

/// Location input field with autocomplete for predefined locations and Google Places.
/// Matches HTML prototype with underline border style.
class LocationInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData icon;
  final Color? iconColor;
  final String? selectedAddress;
  final List<PredefinedLocation> predefinedLocations;
  final ValueChanged<PredefinedLocation>? onPredefinedSelected;
  final ValueChanged<CustomLocation>? onCustomAddressSelected;
  final VoidCallback? onCurrentLocationTap;
  final VoidCallback? onCustomLocationTap;
  final bool showCurrentLocation;
  // Localized strings
  final String? currentLocationLabel;
  final String? currentLocationSubtitle;
  final String? chooseOnMapLabel;
  final String? chooseOnMapSubtitle;
  final String? noMatchingLocationsLabel;

  const LocationInputField({
    super.key,
    required this.label,
    this.hint,
    required this.icon,
    this.iconColor,
    this.selectedAddress,
    this.predefinedLocations = const [],
    this.onPredefinedSelected,
    this.onCustomAddressSelected,
    this.onCurrentLocationTap,
    this.onCustomLocationTap,
    this.showCurrentLocation = true,
    this.currentLocationLabel,
    this.currentLocationSubtitle,
    this.chooseOnMapLabel,
    this.chooseOnMapSubtitle,
    this.noMatchingLocationsLabel,
  });

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _placesService = GooglePlacesService();

  bool _showSuggestions = false;
  String _searchQuery = '';
  List<PlacePrediction> _placePredictions = [];
  bool _isLoadingPlaces = false;
  Timer? _debounceTimer;
  String? _sessionToken;

  @override
  void initState() {
    super.initState();
    if (widget.selectedAddress != null) {
      _controller.text = widget.selectedAddress!;
    }
    _focusNode.addListener(_onFocusChange);
    _generateSessionToken();
  }

  void _generateSessionToken() {
    _sessionToken = const Uuid().v4();
  }

  @override
  void didUpdateWidget(LocationInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAddress != oldWidget.selectedAddress) {
      _controller.text = widget.selectedAddress ?? '';
    }
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus) {
      // Generate new session token when focus is lost
      _generateSessionToken();
    }
  }

  List<PredefinedLocation> get _filteredLocations {
    if (_searchQuery.isEmpty) {
      return widget.predefinedLocations;
    }
    final query = _searchQuery.toLowerCase();
    return widget.predefinedLocations
        .where((loc) => loc.address.toLowerCase().contains(query))
        .toList();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Only search Google Places if query is long enough and no predefined matches
    if (value.length >= 3) {
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        _searchGooglePlaces(value);
      });
    } else {
      setState(() {
        _placePredictions = [];
        _isLoadingPlaces = false;
      });
    }
  }

  Future<void> _searchGooglePlaces(String query) async {
    if (!mounted) return;

    setState(() => _isLoadingPlaces = true);

    try {
      final predictions = await _placesService.autocomplete(
        input: query,
        sessionToken: _sessionToken,
      );

      if (mounted) {
        setState(() {
          _placePredictions = predictions;
          _isLoadingPlaces = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _placePredictions = [];
          _isLoadingPlaces = false;
        });
      }
    }
  }

  Future<void> _selectPlacePrediction(PlacePrediction prediction) async {
    // Show loading state
    _controller.text = prediction.mainText;
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);

    // Get place details to get coordinates
    final details = await _placesService.getPlaceDetails(
      placeId: prediction.placeId,
      sessionToken: _sessionToken,
    );

    if (details != null && widget.onCustomAddressSelected != null) {
      widget.onCustomAddressSelected!(CustomLocation(
        address: details.address,
        lat: details.lat,
        lng: details.lng,
        placeId: details.placeId,
      ));
      _controller.text = details.address;
    }

    // Generate new session token after selection
    _generateSessionToken();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.iconColor ?? CupertinoColors.systemBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field with underline style (matching HTML prototype)
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  widget.icon,
                  size: 24,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 15),
              // Text field
              Expanded(
                child: CupertinoTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  placeholder: widget.hint ?? 'Enter address',
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: CupertinoColors.transparent,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.label,
                  ),
                  placeholderStyle: TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.placeholderText.resolveFrom(context),
                  ),
                  onChanged: _onSearchChanged,
                  onTap: () {
                    setState(() => _showSuggestions = true);
                  },
                ),
              ),
              // Loading indicator
              if (_isLoadingPlaces)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CupertinoActivityIndicator(radius: 10),
                ),
              // Clear button
              if (widget.selectedAddress != null && !_isLoadingPlaces)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _searchQuery = '';
                      _placePredictions = [];
                    });
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 18,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                ),
            ],
          ),
        ),
        // Suggestions dropdown
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CupertinoColors.separator.resolveFrom(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                // Current location option
                if (widget.showCurrentLocation && widget.onCurrentLocationTap != null)
                  _CupertinoSuggestionTile(
                    icon: Icons.location_on_outlined,
                    iconColor: CupertinoColors.systemBlue,
                    title: widget.currentLocationLabel ?? 'Current Location',
                    subtitle: widget.currentLocationSubtitle ?? 'Use GPS to detect your location',
                    onTap: () {
                      widget.onCurrentLocationTap?.call();
                      _focusNode.unfocus();
                      setState(() => _showSuggestions = false);
                    },
                  ),
                // Custom location option (choose on map)
                if (widget.onCustomLocationTap != null)
                  _CupertinoSuggestionTile(
                    icon: Icons.map_outlined,
                    iconColor: CupertinoColors.systemOrange,
                    title: widget.chooseOnMapLabel ?? 'Choose on Map',
                    subtitle: widget.chooseOnMapSubtitle ?? 'Select a custom location on the map',
                    onTap: () {
                      widget.onCustomLocationTap?.call();
                      _focusNode.unfocus();
                      setState(() => _showSuggestions = false);
                    },
                  ),
                // Divider after special options
                if ((widget.showCurrentLocation || widget.onCustomLocationTap != null) &&
                    (_filteredLocations.isNotEmpty || _placePredictions.isNotEmpty))
                  Container(
                    height: 1,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                // Predefined locations section
                if (_filteredLocations.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'POPULAR LOCATIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ..._filteredLocations.take(5).map((location) => _CupertinoSuggestionTile(
                        icon: _getLocationIcon(location.type),
                        iconColor: CupertinoColors.systemIndigo,
                        title: location.address,
                        subtitle: location.typeDisplay,
                        onTap: () {
                          widget.onPredefinedSelected?.call(location);
                          _controller.text = location.address;
                          _focusNode.unfocus();
                          setState(() => _showSuggestions = false);
                        },
                      )),
                ],
                // Google Places predictions section
                if (_placePredictions.isNotEmpty) ...[
                  if (_filteredLocations.isNotEmpty)
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'SEARCH RESULTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ..._placePredictions.map((prediction) => _CupertinoSuggestionTile(
                        icon: Icons.place_outlined,
                        iconColor: CupertinoColors.systemGreen,
                        title: prediction.mainText,
                        subtitle: prediction.secondaryText,
                        onTap: () => _selectPlacePrediction(prediction),
                      )),
                ],
                // No results message
                if (_filteredLocations.isEmpty &&
                    _placePredictions.isEmpty &&
                    _searchQuery.length >= 3 &&
                    !_isLoadingPlaces)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.noMatchingLocationsLabel ?? 'No matching locations found',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Loading indicator for places search
                if (_isLoadingPlaces && _searchQuery.length >= 3)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getLocationIcon(String locationType) {
    switch (locationType) {
      case 'airport':
        return Icons.flight;
      case 'port':
        return Icons.water_drop;
      case 'city_center':
        return Icons.apartment;
      case 'resort':
        return Icons.wb_sunny;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.place_outlined;
    }
  }
}

class _CupertinoSuggestionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _CupertinoSuggestionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.label,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
