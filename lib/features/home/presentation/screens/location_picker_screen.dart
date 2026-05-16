import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class PickedLocation {
  final String name;
  final double latitude;
  final double longitude;

  const PickedLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationPickerScreen extends StatefulWidget {
  final PickedLocation? initialLocation;

  const LocationPickerScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const LatLng _defaultCenter = LatLng(48.8566, 2.3522);

  final _mapController = MapController();
  final _searchController = TextEditingController();

  PickedLocation? _selectedLocation;
  bool _isSearching = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _searchController.text = widget.initialLocation?.name ?? '';
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchByName() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _isSearching) {
      return;
    }

    setState(() => _isSearching = true);

    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        _showMessage('Aucun lieu trouve');
        return;
      }

      final location = locations.first;
      _selectLocation(
        LatLng(location.latitude, location.longitude),
        name: query,
        moveMap: true,
      );
    } catch (_) {
      _showMessage('Impossible de trouver ce lieu');
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _useCurrentPosition() async {
    if (_isLocating) {
      return;
    }

    setState(() => _isLocating = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Active la localisation du telephone');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Permission de localisation refusee');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      await _selectLocation(
        LatLng(position.latitude, position.longitude),
        moveMap: true,
      );
    } catch (_) {
      _showMessage('Impossible de recuperer ta position');
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  Future<void> _selectLocation(
    LatLng point, {
    String? name,
    bool moveMap = false,
  }) async {
    final resolvedName = name ?? await _resolveLocationName(point);

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedLocation = PickedLocation(
        name: resolvedName,
        latitude: point.latitude,
        longitude: point.longitude,
      );
      _searchController.text = resolvedName;
    });

    if (moveMap) {
      _mapController.move(point, 16);
    }
  }

  Future<String> _resolveLocationName(LatLng point) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isEmpty) {
        return 'Lieu selectionne';
      }

      final placemark = placemarks.first;
      final parts = [
        placemark.name,
        placemark.street,
        placemark.locality,
      ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();

      return parts.isEmpty ? 'Lieu selectionne' : parts.join(', ');
    } catch (_) {
      return 'Lieu selectionne';
    }
  }

  void _confirmLocation() {
    final selectedLocation = _selectedLocation;
    if (selectedLocation == null) {
      _showMessage('Selectionne un lieu');
      return;
    }

    Navigator.of(context).pop(selectedLocation);
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocation = _selectedLocation;
    final center = selectedLocation == null
        ? _defaultCenter
        : LatLng(selectedLocation.latitude, selectedLocation.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un lieu'),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text('Valider'),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: selectedLocation == null ? 13 : 16,
                minZoom: 3,
                maxZoom: 19,
                onTap: (_, point) => _selectLocation(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.where_u_drink.app',
                ),
                if (selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 48,
                        height: 48,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: _SearchPanel(
                controller: _searchController,
                isSearching: _isSearching,
                onSearch: _searchByName,
                onUseCurrentPosition: _useCurrentPosition,
                isLocating: _isLocating,
              ),
            ),
            if (selectedLocation != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: _SelectedLocationPanel(
                  location: selectedLocation,
                  onConfirm: _confirmLocation,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final bool isLocating;
  final VoidCallback onSearch;
  final VoidCallback onUseCurrentPosition;

  const _SearchPanel({
    required this.controller,
    required this.isSearching,
    required this.isLocating,
    required this.onSearch,
    required this.onUseCurrentPosition,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearch(),
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Nom du bar ou adresse',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: isSearching ? null : onSearch,
              icon: isSearching
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              tooltip: 'Rechercher',
            ),
            IconButton.filled(
              onPressed: isLocating ? null : onUseCurrentPosition,
              icon: isLocating
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              tooltip: 'Ma position',
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedLocationPanel extends StatelessWidget {
  final PickedLocation location;
  final VoidCallback onConfirm;

  const _SelectedLocationPanel({
    required this.location,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.location_pin, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    location.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: onConfirm,
              child: const Text('Choisir'),
            ),
          ],
        ),
      ),
    );
  }
}
