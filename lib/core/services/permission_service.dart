import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Service to handle location permissions
class PermissionService {
  /// Requests location permission from the user
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestLocationPermission(BuildContext context) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable them.'),
          ),
        );
      }
      return false;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    
    // If permission is denied, request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
            ),
          );
        }
        return false;
      }
    }

    // If permission is permanently denied, show message
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied. Please enable them in settings.',
            ),
          ),
        );
      }
      return false;
    }

    // Permission is granted
    return true;
  }

  /// Checks if location permission is already granted
  /// Returns true if permission is granted, false otherwise
  static Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Checks if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Requests permission (if needed) and returns location + city
  static Future<Map<String, dynamic>?> getLocationWithCity(
    BuildContext context,
  ) async {
    //  Ensure permission
    final hasPermission = await requestLocationPermission(context);
    if (!hasPermission) return null;

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      //  Reverse geocoding
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': place.locality ?? place.subAdministrativeArea ?? '',
        'country': place.country ?? '',
      };
    } catch (e) {
      debugPrint('Location fetch failed: $e');
      return null;
    }
  }
}

