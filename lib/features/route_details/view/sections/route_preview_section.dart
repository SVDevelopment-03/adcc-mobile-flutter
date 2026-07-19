import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../widgets/route_map_widget.dart';

class RoutePreviewSection extends StatefulWidget {
  /// Start location (latitude, longitude)
  final LatLng? startLocation;
  
  /// End location (latitude, longitude)
  final LatLng? endLocation;
  
  final VoidCallback? onStartRide;

  const RoutePreviewSection({
    super.key,
    this.startLocation,
    this.endLocation,
    this.onStartRide,
  });

  @override
  State<RoutePreviewSection> createState() => _RoutePreviewSectionState();
}

class _RoutePreviewSectionState extends State<RoutePreviewSection> {

  LatLng get _startLocation =>
      widget.startLocation ??
      const LatLng(24.4539, 54.3773); // Abu Dhabi default

  LatLng get _endLocation =>
      widget.endLocation ??
      const LatLng(24.4812, 54.3519); // Abu Dhabi default

  void _onDistanceCalculated(double distance) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Preview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          // Google Map with route and location tracking
          RouteMapWidget(
            startLocation: _startLocation,
            endLocation: _endLocation,
            height: 200,
            onDistanceCalculated: _onDistanceCalculated,
          ),
          const SizedBox(height: 16),
          // Start Ride Button
          AppButton(
            label: 'Start Ride',
            onPressed: widget.onStartRide,
            type: AppButtonType.primary,
            backgroundColor: AppColors.deepRed,
            prefixIcon: Icons.play_arrow,
          ),
        ],
      ),
    );
  }
}

