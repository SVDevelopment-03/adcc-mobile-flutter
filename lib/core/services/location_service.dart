import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'permission_service.dart';
import 'location_storage_service.dart';

class LocationService {
  static Future<void> fetchAndSaveLocation(BuildContext context) async {
    final hasPermission =
        await PermissionService.requestLocationPermission(context);

    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final city = place.locality ?? '';

      await LocationStorageService.saveLocation(
        city: city,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }
}
