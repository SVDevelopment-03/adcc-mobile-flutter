import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/permission_service.dart';

/// Widget that displays a Google Map with route rendering and real-time location tracking
class RouteMapWidget extends StatefulWidget {
  /// Start location (latitude, longitude)
  final LatLng startLocation;
  
  /// End location (latitude, longitude)
  final LatLng endLocation;
  
  /// Height of the map container
  final double height;
  
  /// Callback when distance is calculated
  final ValueChanged<double>? onDistanceCalculated;

  const RouteMapWidget({
    super.key,
    required this.startLocation,
    required this.endLocation,
    this.height = 200,
    this.onDistanceCalculated,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  double _distanceToDestination = 0.0;
  Timer? _locationTimer;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Check if location permissions are granted (permissions should be requested at home screen)
    await _checkLocationPermission();
    
    // Get initial location
    await _getCurrentLocation();
    
    // Draw route
    await _drawRoute();
    
    // Start location updates
    _startLocationUpdates();
  }

  /// Checks if location permission is granted
  /// Permissions should already be requested at the home screen
  Future<void> _checkLocationPermission() async {
    bool isGranted = await PermissionService.isLocationPermissionGranted();
    
    setState(() {
      _isLocationPermissionGranted = isGranted;
    });
    
    if (!isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission is required to track your route. Please enable it in settings.',
          ),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!_isLocationPermissionGranted) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        _updateDistance();
        _updateMapCamera();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _startLocationUpdates() {
    if (!_isLocationPermissionGranted) return;

    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _getCurrentLocation();
    });
  }

  void _updateDistance() {
    if (_currentPosition == null) return;

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      widget.endLocation.latitude,
      widget.endLocation.longitude,
    );

    setState(() {
      _distanceToDestination = distance;
    });

    widget.onDistanceCalculated?.call(distance);
  }

  void _updateMapCamera() {
    if (_mapController == null || _currentPosition == null) return;

    // Calculate bounds to include both current position and route
    final bounds = LatLngBounds(
      southwest: LatLng(
        _currentPosition!.latitude < widget.startLocation.latitude
            ? _currentPosition!.latitude
            : widget.startLocation.latitude,
        _currentPosition!.longitude < widget.startLocation.longitude
            ? _currentPosition!.longitude
            : widget.startLocation.longitude,
      ),
      northeast: LatLng(
        _currentPosition!.latitude > widget.endLocation.latitude
            ? _currentPosition!.latitude
            : widget.endLocation.latitude,
        _currentPosition!.longitude > widget.endLocation.longitude
            ? _currentPosition!.longitude
            : widget.endLocation.longitude,
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  Future<void> _drawRoute() async {
    // Create a simple polyline from start to end
    // In production, you would use Google Directions API to get the actual route
    final List<LatLng> routePoints = [
      widget.startLocation,
      widget.endLocation,
    ];

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: Colors.white,
          width: 4,
        ),
      };

      _markers = {
        Marker(
          markerId: const MarkerId('start'),
          position: widget.startLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('end'),
          position: widget.endLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapCamera();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.startLocation,
                zoom: 13,
              ),
              polylines: _polylines,
              markers: _markers,
              mapType: MapType.normal,
              myLocationEnabled: _isLocationPermissionGranted,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              style: _darkMapStyle,
            ),
            // Navigation icon with distance overlay
            if (_currentPosition != null)
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 50,
                top: widget.height / 2 - 20,
                child: Column(
                  children: [
                    // Navigation icon (compass-like)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Directional arrow
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                          // Concentric circles
                          ...List.generate(2, (index) {
                            return Container(
                              width: 30 - (index * 8),
                              height: 30 - (index * 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                  style: BorderStyle.values[1], // dashed
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Distance text
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDistance(_distanceToDestination),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Location pin (user's current location)
            if (_currentPosition != null)
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 12,
                top: widget.height / 2 - 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  // Dark map style to match the design
  static const String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#1d2c4d"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#8ec3b9"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1a3646"}]
    },
    {
      "featureType": "administrative.country",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#4b6878"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#64779e"}]
    },
    {
      "featureType": "administrative.province",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#4b6878"}]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#334e87"}]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [{"color": "#023e58"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#283d6a"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#6f9ba5"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1d2c4d"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#023e58"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#3C7680"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#304a7d"}]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#98a5be"}]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1d2c4d"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#2c6675"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#255763"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#b0d5ce"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#023e58"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#98a5be"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1d2c4d"}]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [{"color": "#2c6675"}]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [{"color": "#3a4762"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#0e1626"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#4e6d70"}]
    }
  ]
  ''';
}

