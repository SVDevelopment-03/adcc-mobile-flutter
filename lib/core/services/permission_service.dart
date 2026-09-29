import 'dart:async';

import 'package:adcc/l10n/app_localizations.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Service to handle location permissions
class PermissionService {
  /// Requests App Tracking Transparency authorization on iOS.
  /// Returns true if the user has authorized or limited tracking.
  static Future<bool> requestAppTrackingPermission({
    Future<TrackingStatus> Function()? requestAuthorization,
  }) async {
    final status = await (requestAuthorization ??
            AppTrackingTransparency.requestTrackingAuthorization)();

    return status == TrackingStatus.authorized;
  }

  /// Shows a brief explainer before asking for ATT authorization on iOS.
  static Future<bool> requestAppTrackingPermissionWithDialog(
    BuildContext context, {
    Future<TrackingStatus> Function()? requestAuthorization,
  }) async {
    if (requestAuthorization != null) {
      return requestAppTrackingPermission(requestAuthorization: requestAuthorization);
    }

    final currentStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (currentStatus != TrackingStatus.notDetermined) {
      return currentStatus == TrackingStatus.authorized;
    }

    if (!context.mounted) return false;

    final completer = Completer<bool>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        completer.complete(false);
        return;
      }

      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Tracking permission'),
            content: const Text(
              'This app uses your data to personalize content and measure app performance. You can change this anytime in Settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Continue'),
              ),
            ],
          );
        },
      ).then((shouldContinue) {
        completer.complete(shouldContinue == true);
      });
    });

    final shouldContinue = await completer.future;
    if (!shouldContinue) {
      return false;
    }

    return requestAppTrackingPermission();
  }

  /// Requests location permission from the user
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestLocationPermission(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.location_services_disabled),
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
            SnackBar(
              content: Text(l10n.location_permissions_denied),
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
          SnackBar(
            content: Text(l10n.location_permissions_permanently_denied),
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
