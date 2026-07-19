import 'dart:convert';

import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:flutter/material.dart';

class MyJoinedEventsSection extends StatefulWidget {
  final VoidCallback? onViewAll;

  const MyJoinedEventsSection({super.key, this.onViewAll});

  @override
  State<MyJoinedEventsSection> createState() => _MyJoinedEventsSectionState();
}

class _MyJoinedEventsSectionState extends State<MyJoinedEventsSection> {
  late final ProfileRepository _profileRepository;
  late Future<List<ProfileUpcomingEventItem>> _joinedEventsFuture;

  @override
  void initState() {
    super.initState();
    _profileRepository = ProfileRepository(apiClient: ApiClient.instance);
    _joinedEventsFuture = _profileRepository.fetchActiveParticipations();
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty || rawDate == '—') return '—';

    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return rawDate;
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
      color: Color(0xFFebf4ff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSectionHeader(
            title: 'Joined Events',
            onViewAll: widget.onViewAll,
          ),
          const SizedBox(height: 17),
          FutureBuilder<List<ProfileUpcomingEventItem>>(
            future: _joinedEventsFuture,
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
                return SizedBox(
                  height: 309,
                  child: Center(
                    child: Text(
                      'No joined events yet',
                      style: TextStyle(color: Colors.grey.shade600),
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
                      imageProvider: _resolveImage(event.image),
                      eventId: event.id,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsScreen(eventId: event.id),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Geist',
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
  final ImageProvider imageProvider;
  final String eventId;
  final VoidCallback onTap;

  const _EventCard({
    required this.title,
    required this.date,
    required this.distance,
    required this.imageProvider,
    required this.eventId,
    required this.onTap,
  });

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
                      color: const Color(0xFFFFC9C9),
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
                      color: const Color(0xFF435974),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Registered',
                      style: TextStyle(
                        fontFamily: 'Geist',
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
                      ShareHelper.share(
                        context,
                        ShareHelper.event(title, eventId),
                        subject: 'Check out this event on ADCC',
                      );
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0359E8),
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
                    height: 100,
                    padding: const EdgeInsets.fromLTRB(15, 39, 15, 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E5FB),
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
                                  fontFamily: 'Geist',
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
                                fontFamily: 'Geist',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                height: 16 / 11,
                                color: Color(0xFF333333),
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
