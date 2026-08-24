import 'dart:convert';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:adcc/utils/date_utils.dart';

class MyJoinedEventsSection extends StatefulWidget {
  final VoidCallback? onViewAll;

  const MyJoinedEventsSection({super.key, this.onViewAll});

  @override
  State<MyJoinedEventsSection> createState() => _MyJoinedEventsSectionState();
}

class _MyJoinedEventsSectionState extends State<MyJoinedEventsSection> {
  late final ProfileRepository _profileRepository;

  @override
  void initState() {
    super.initState();
    _profileRepository = ProfileRepository(apiClient: ApiClient.instance);
  }

  Future<List<ProfileUpcomingEventItem>> _joinedEventsFuture(BuildContext context) {
    return _profileRepository.fetchActiveParticipations(
      locale: Localizations.localeOf(context).languageCode,
    );
  }

  AppLocalizations? _l10n(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty || rawDate == '—') return '—';

    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      final l = _l10n(context);
      if (l == null) return '${parsed.day} ${parsed.month} ${parsed.year}';

      final months = [
        l.month_short_jan,
        l.month_short_feb,
        l.month_short_mar,
        l.month_short_apr,
        l.month_short_may,
        l.month_short_jun,
        l.month_short_jul,
        l.month_short_aug,
        l.month_short_sep,
        l.month_short_oct,
        l.month_short_nov,
        l.month_short_dec,
      ];
      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return formatIsoDateForDisplay(rawDate, format: 'd MMM yyyy');
    }
  }

  ImageProvider _resolveImage(String? imageValue) {
    final raw = imageValue?.trim();
    if (raw == null || raw.isEmpty) {
      return const AssetImage('assets/images/no-img.jpg');
    }

    if (raw.startsWith('http')) {
      return NetworkImage(raw);
    }

    try {
      final cleaned = raw.contains('base64,') ? raw.split('base64,').last : raw;
      return MemoryImage(base64Decode(cleaned));
    } catch (_) {
      return const AssetImage('assets/images/no-img.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSectionHeader(
            title: _l10n(context)?.joinedEvents ?? 'Joined Events',
            onViewAll: widget.onViewAll,
          ),
          const SizedBox(height: 17),
          FutureBuilder<List<ProfileUpcomingEventItem>>(
            future: _joinedEventsFuture(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 309,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 309,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)?.failedToLoadJoinedEvents ??
                              'Failed to load joined events',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final events = (snapshot.data ?? []).take(5).toList();

              if (events.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _l10n(context)?.no_joined_events_yet ?? 'No joined events yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 309,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _EventCard(
                      title: event.title,
                      date: _formatDate(event.date),
                      distance: event.distance,
                      trackName: event.trackName.isNotEmpty
                          ? event.trackName
                          : (_l10n(context)?.various_tracks ?? 'Various tracks'),
                      imageProvider: _resolveImage(event.image),
                      eventId: event.id,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EventDetailsScreen(eventId: event.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _ProfileSectionHeader({
    required this.title,
    this.onViewAll,
  });

  AppLocalizations? _l10n(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 25 / 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _l10n(context)?.view_all_label ?? 'View all',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF333333),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String distance;
  final String trackName;
  final ImageProvider imageProvider;
  final String eventId;
  final VoidCallback onTap;

  const _EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.distance,
    required this.trackName,
    required this.imageProvider,
    required this.eventId,
    required this.onTap,
  });

  AppLocalizations? _l10n(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 358,
        height: 309,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color.fromARGB(255, 201, 224, 255),
                    ),
                  ),
                ),
                Positioned(
                  top: 9,
                  left: 16,
                  child: Container(
                    width: 90,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5257B5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.registeredLabel ?? 'Registered',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 17,
                  right: 15,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
                      final shareText = l10n != null
                          ? ShareHelper.event(title, eventId, l10n)
                          : 'Event: $title\nID: $eventId';

                      ShareHelper.share(
                        context,
                        shareText,
                        subject: l10n?.share_event_subject ?? 'Share event',
                      );
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5257B5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: 11,
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.fromLTRB(15, 39, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          ProfileImgs.profileEventCardBackground,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            height: 20 / 17,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 14,
                              color: Color(0xFF333333),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  height: 16 / 11,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.route_rounded,
                              size: 14,
                              color: Color(0xFF333333),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              distance,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                height: 16 / 11,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Color(0xFF333333),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                trackName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  height: 16 / 11,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
