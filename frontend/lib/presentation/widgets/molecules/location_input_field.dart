import 'package:flutter/cupertino.dart';

import '../../../data/models/predefined_location.dart';

/// Location input field with autocomplete for predefined locations - Cupertino style.
class LocationInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData icon;
  final String? selectedAddress;
  final List<PredefinedLocation> predefinedLocations;
  final ValueChanged<PredefinedLocation>? onPredefinedSelected;
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
    this.selectedAddress,
    this.predefinedLocations = const [],
    this.onPredefinedSelected,
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
  bool _showSuggestions = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.selectedAddress != null) {
      _controller.text = widget.selectedAddress!;
    }
    _focusNode.addListener(_onFocusChange);
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

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
        // Input field
        CupertinoTextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: widget.hint ?? 'Enter address or select from list',
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              widget.icon,
              size: 20,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          suffix: widget.selectedAddress != null
              ? CupertinoButton(
                  padding: const EdgeInsets.only(right: 8),
                  minimumSize: Size.zero,
                  onPressed: () {
                    _controller.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 18,
                    color: CupertinoColors.tertiaryLabel,
                  ),
                )
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
            borderRadius: BorderRadius.circular(10),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          onTap: () {
            setState(() => _showSuggestions = true);
          },
        ),
        // Suggestions dropdown
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
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
                    icon: CupertinoIcons.location,
                    iconColor: CupertinoColors.systemBlue,
                    title: widget.currentLocationLabel ?? 'Current Location',
                    subtitle: widget.currentLocationSubtitle ?? 'Use GPS to detect your location',
                    onTap: () {
                      widget.onCurrentLocationTap?.call();
                      _focusNode.unfocus();
                      setState(() => _showSuggestions = false);
                    },
                  ),
                // Custom location option
                if (widget.onCustomLocationTap != null)
                  _CupertinoSuggestionTile(
                    icon: CupertinoIcons.map,
                    iconColor: CupertinoColors.systemOrange,
                    title: widget.chooseOnMapLabel ?? 'Choose on Map',
                    subtitle: widget.chooseOnMapSubtitle ?? 'Select a custom location on the map',
                    onTap: () {
                      widget.onCustomLocationTap?.call();
                      _focusNode.unfocus();
                      setState(() => _showSuggestions = false);
                    },
                  ),
                // Divider
                if ((widget.showCurrentLocation || widget.onCustomLocationTap != null) &&
                    _filteredLocations.isNotEmpty)
                  Container(
                    height: 1,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                // Predefined locations
                ..._filteredLocations.map((location) => _CupertinoSuggestionTile(
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
                // No results
                if (_filteredLocations.isEmpty && _searchQuery.isNotEmpty)
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
        return CupertinoIcons.airplane;
      case 'port':
        return CupertinoIcons.drop;
      case 'city_center':
        return CupertinoIcons.building_2_fill;
      case 'resort':
        return CupertinoIcons.sun_max;
      case 'hotel':
        return CupertinoIcons.bed_double;
      default:
        return CupertinoIcons.placemark;
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
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
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
