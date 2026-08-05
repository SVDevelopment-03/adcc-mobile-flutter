import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/models/profile_model.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/profile/view/sections/event_history/completed_event_card.dart';
import 'package:adcc/features/profile/view/sections/event_history/perfromance_insights_card.dart';
import 'package:adcc/features/profile/view/sections/event_history/upcoming_event_card_section.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';


class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({super.key});

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  final ProfileRepository _profileRepository = ProfileRepository();

  bool _isLoading = true;
  String? _errorMessage;
  ProfileModel? _profile;
  ProfilePerformanceInsights _insights = ProfilePerformanceInsights.fallback;
  List<ProfileEventHistoryItem> _completedEvents = const [];
  List<ProfileUpcomingEventItem> _upcomingEvents = const [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  double _toKmValue(String value) {
    final normalized = value.toLowerCase().replaceAll('km', '').trim();
    return double.tryParse(normalized) ?? 0;
  }

  String _summaryDistance() {
    final total = _completedEvents.fold<double>(
      0,
      (sum, event) => sum + _toKmValue(event.distance),
    );
    return '${total.toStringAsFixed(total % 1 == 0 ? 0 : 1)} km';
  }

  int _badgesEarnedCount() {
    return _completedEvents
        .where((event) => event.badgeName.trim().isNotEmpty)
        .length;
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _profileRepository.fetchProfile(),
        _profileRepository.fetchPerformanceInsights(),
        _profileRepository.fetchCompletedEvents(),
        _profileRepository.fetchActiveParticipations(),
      ]);

      if (!mounted) return;

      setState(() {
        _profile = results[0] as ProfileModel?;
        _insights = results[1] as ProfilePerformanceInsights;
        _completedEvents = results[2] as List<ProfileEventHistoryItem>;
        _upcomingEvents = results[3] as List<ProfileUpcomingEventItem>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerHeadder(
                        imagePath: 'assets/images/no-img.jpg',
                        title: 'Event History',
                        subtitle: '',
                        centerTitle: true,
                        onBackTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                      RiderStatsSection(
                        riderLevel: _profile == null
                            ? 'Rider Level: Intermediate'
                            : 'Rider Level: ${_profile!.skillLevel}',
                        badgesTitle: 'Total Events',
                        badgesValue: '${_completedEvents.length + _upcomingEvents.length}',
                        pointsTitle: 'Completed',
                        pointsValue: '${_completedEvents.length}',
                        progressTitle: 'Podium Finishes',
                        progressValue: _insights.bestCategory,
                      ),
                      const SizedBox(height: 30),
                      PerformanceInsightsCard(
                        completionRate: _insights.completionRate,
                        averageDistance: _insights.averageDistance,
                        bestCategory: _insights.bestCategory,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5257B5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryChip(
                              icon: Icons.flag_rounded,
                              title: 'Completed',
                              value: '${_completedEvents.length}',
                            ),
                            _SummaryChip(
                              icon: Icons.route_rounded,
                              title: 'Distance',
                              value: _summaryDistance(),
                            ),
                            _SummaryChip(
                              icon: Icons.emoji_events_rounded,
                              title: 'Badges',
                              value: '${_badgesEarnedCount()}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Completed Events',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                letterSpacing: 0,
                                color: AppColors.charcoal,
                              ),
                            ),
                            Row(
                              children: const [
                                Text(
                                  'View All',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: 0,
                                    color: Color(0xFF484A4D),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Color(0xFF484A4D),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (_completedEvents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No completed events yet'),
                        )
                      else
                        ..._completedEvents.map(
                          (event) => CompletedEventCard(
                            title: event.title,
                            subtitle: event.subtitle,
                            date: event.date,
                            status: event.status,
                            distance: event.distance,
                            time: event.time,
                            rank: event.rank,
                            image: event.image,
                          ),
                        ),
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              'Upcoming Events',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                letterSpacing: 0,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 392,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 2),
                              itemBuilder: (context, index) {
                                final event = _upcomingEvents[index];
                                return UpcomingEventCard(
                                  title: event.title,
                                  date: event.date,
                                  distance: event.distance,
                                  image: event.image,
                                );
                              },
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemCount: _upcomingEvents.length,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryChip({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0359E8)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }
}



