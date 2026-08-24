import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/route_details/view/sections/route_communities_section.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/route_details/view/sections/route_events_section.dart';
import 'package:adcc/features/routes/Models/event_model.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'sections/route_header_section.dart';
import 'sections/route_title_section.dart';
import 'sections/route_description_section.dart';
import 'sections/route_details_grid_section.dart';
import 'sections/route_facilities_section.dart';
import 'sections/route_safety_section.dart';
import 'sections/route_photos_section.dart';
import 'sections/route_action_buttons_section.dart';

class RouteDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;

  const RouteDetailsScreen({
    super.key,
    required this.routeData,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final TracksService _tracksService = TracksService();

  TrackModel? _track;
  bool _isLoadingTrack = false;

  List<EventModel> _trackEvents = [];
  bool _isLoadingEvents = false;

  @override
  void initState() {
    super.initState();
    _loadTrackDetails();
    _loadTrackEvents();
  }

  Future<void> _loadTrackDetails() async {
    final trackId = widget.routeData['id']?.toString() ??
        widget.routeData['_id']?.toString();

    if (trackId == null || trackId.isEmpty) return;

    setState(() => _isLoadingTrack = true);

    try {
      final track = await _tracksService.getTrackById(trackId);
      if (mounted) {
        setState(() {
          _track = track;
          _isLoadingTrack = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTrack = false);
      }
    }
  }

  Future<void> _loadTrackEvents() async {
    final trackId = widget.routeData['id']?.toString() ??
        widget.routeData['_id']?.toString();

    if (trackId == null || trackId.isEmpty) return;

    setState(() => _isLoadingEvents = true);

    try {
      final events = await _tracksService.getTrackRelatedEvents(trackId);

      if (mounted) {
        setState(() {
          _trackEvents = events;
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingEvents = false);
      }
    }
  }

  String _getFacilityIcon(String facility) {
    final normalized = facility.toLowerCase();

    if (normalized.contains('water')) {
      return 'assets/icons/lightning_emoji.png';
    }
    if (normalized.contains('light')) {
      return 'assets/icons/light-icon.png';
    }
    if (normalized.contains('parking')) {
      return 'assets/icons/parking-icon.png';
    }
    if (normalized.contains('restroom')) {
      return 'assets/icons/toilets.png';
    }
    if (normalized.contains('cafe') || normalized.contains('coffee')) {
      return 'assets/icons/event_track.png';
    }
    if (normalized.contains('bike') ||
        normalized.contains('rent') ||
        normalized.contains('rental')) {
      return 'assets/icons/type.png';
    }
    if (normalized.contains('first') ||
        normalized.contains('aid') ||
        normalized.contains('medical')) {
      return 'assets/icons/medical-icon.png';
    }
    if (normalized.contains('changing') || normalized.contains('room')) {
      return 'assets/icons/loop-track.png';
    }

    return 'assets/icons/parking.png';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingTrack || _track == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(TrackImgs.trackBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFF09902),
            ),
          ),
        ),
      );
    }

    final routeDetails = {
      'distance': "${_track!.distance ?? 0} km",
      'elevation': (_track!.elevation ?? '').toString(),
      'type': (_track!.type ?? '').toString(),
      'avg_time': (_track!.avgtime ?? '').toString(),
      'pace': _resolvePaceLabel(),
    };

    final facilities = _track!.facilities
        .map((facility) => {
              "icon": _getFacilityIcon(facility),
              "label": facility,
            })
        .toList();

    final List<String> photos = [];

    if (_track!.galleryImages.isNotEmpty) {
      photos.addAll(_track!.galleryImages);
    } else if (_track!.image.isNotEmpty) {
      photos.add(_track!.image);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(TrackImgs.trackBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              RouteHeaderSection(
                imagePath: _track!.image,
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: 16),
              RouteTitleSection(
                title: _track!.title,
                status: _track!.status,
                onShare: () {
                  ShareHelper.share(
                    context,
                    ShareHelper.route(_track!.title, _track!.id, AppLocalizations.of(context)!),
                    subject: AppLocalizations.of(context)!.share_route_subject,
                  );
                },
              ),
              const SizedBox(height: 9),
              RouteDescriptionSection(
                description: _track!.description,
              ),
              const SizedBox(height: 24),
              RouteDetailsGridSection(routeDetails: routeDetails),
              const SizedBox(height: 40),
              RouteFacilitiesSection(facilities: facilities),
              const SizedBox(height: 24),

              //TODO: Implement the onOpenLinkMyRide and onOpenMaps callbacks
              // RouteActionButtonsSection(
              //   onOpenLinkMyRide: () {},
              //   onOpenMaps: () {},
              // ),
              const SizedBox(height: 42),
              RoutePhotosSection(photoPaths: photos),
              const SizedBox(height: 36),
              _buildEventsSection(),
              const SizedBox(height: 24),
              RouteCommunitiesSection(
                trackId: _track!.id,
              ),
              const SizedBox(height: 24),
              RouteSafetySection(
                safetyMessage: _track!.safetyNotes,
                helmetRequired: _track!.helmetRequired,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _resolvePaceLabel() {
    final l10n = AppLocalizations.of(context)!;
    final pace = _track!.pace.trim();
    if (pace.isNotEmpty) {
      return pace;
    }

    final difficulty = _track!.difficulty.trim().toLowerCase();
    if (difficulty.contains('beginner')) {
      return l10n.pace_beginner_casual;
    }
    if (difficulty.contains('intermediate')) {
      return l10n.pace_beginner_casual;
    }
    if (difficulty.contains('advanced') || difficulty.contains('hard')) {
      return l10n.pace_fast_challenging;
    }

    return l10n.pace_beginner_casual;
  }

  Widget _buildEventsSection() {
    if (_isLoadingEvents) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0XFF27B96A),
          ),
        ),
      );
    }

    if (_trackEvents.isEmpty) return const SizedBox.shrink();

    return RouteEventsSection(
      events: _trackEvents,
      onShareTap: (event) {
        ShareHelper.share(
          context,
          ShareHelper.event(event.title, event.id, AppLocalizations.of(context)!),
          subject: AppLocalizations.of(context)!.share_event_subject,
        );
      },
      onTapEvent: (event) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(eventId: event.id),
          ),
        );
      },
    );
  }
}
