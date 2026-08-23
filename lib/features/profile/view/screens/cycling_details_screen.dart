import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/completed_rides_card.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/cycling_identity_card.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/gear_card.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/view/my_event_screen.dart';
import 'package:adcc/features/profile/view/sections/Cycling%20Details/ride_tile.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:adcc/utils/date_utils.dart';

class CyclingDetailsScreen extends StatefulWidget {
  const CyclingDetailsScreen({super.key});

  @override
  State<CyclingDetailsScreen> createState() => _CyclingDetailsScreenState();
}

class _CyclingDetailsScreenState extends State<CyclingDetailsScreen> {
  late ProfileRepository _repository;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic> _profileStats = {};
  List<Map<String, dynamic>> _completedRides = [];
  List<Map<String, dynamic>> _communities = [];
  List<StoreItemModel> _gearItems = [];
  int _earnedBadges = 0;
  double _progressPercent = 0.0;
  String _progressText = '0%';

  @override
  void initState() {
    super.initState();
    _repository = ProfileRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profileStats = await _repository.fetchProfile();
      final completedRidesModels = await _repository.fetchCompletedEvents();
      final communities = await _repository.fetchJoinedCommunities();
      final gearItems = await _repository.fetchUserStoreItems();
      final badges = await _repository.fetchUserBadges();
      final performance = await _repository.fetchPerformanceInsights();

      if (mounted) {
        setState(() {
          _profileStats = {
            'riderLevel': profileStats?.skillLevel ?? 'Intermediate',
            'totalDistance': profileStats?.km ?? '0',
            'totalRides': profileStats?.rides ?? '0',
            'totalEvents': profileStats?.events ?? '0',
          };
          final raw = performance.completionRate.replaceAll('%', '');
          final parsed = double.tryParse(raw) ?? 0.0;
          _progressPercent = (parsed / 100).clamp(0.0, 1.0);
          _progressText = performance.completionRate.isNotEmpty
              ? AppLocalizations.of(context)!
                  .completion_rate(performance.completionRate)
              : AppLocalizations.of(context)!
                  .completion_rate('${(_progressPercent * 100).round()}%');
          _completedRides = completedRidesModels
              .map((ride) => {
                    'id': ride.id,
                    'title': ride.title,
                    'distance': ride.distance,
                    'participants': '${ride.subtitle}',
                    'date': ride.date,
                    'image': ride.image,
                  })
              .toList();
          _communities = communities;
          _gearItems =
              gearItems.map((gear) => StoreItemModel.fromJson(gear)).toList();
          _earnedBadges = badges.where((badge) => badge.earned).length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.failed_to_load_cycling_details;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.05).clamp(12.0, 24.0);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.softCream,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.softCream,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? l10n.anErrorOccurred),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final riderLevel = (_profileStats['riderLevel'] ?? '').toString().trim();
    final totalDistance = _profileStats['totalDistance'] == null
        ? ''
        : '${_profileStats['totalDistance']} km';
    final totalRides = _profileStats['totalRides'] == null
        ? ''
        : '${_profileStats['totalRides']} Days';
    final badgesEarned = '$_earnedBadges';
    final visibleRides = _completedRides.where((ride) {
      final title = (ride['title'] ?? '').toString().trim();
      if (title.isEmpty) return false;
      final lower = title.toLowerCase();
      return ![
        'no event',
        'no upcoming events',
        'لا توجد أحداث',
        'لا توجد فعاليات قادمة',
      ].contains(lower);
    }).toList();
    final completedRidesCount = visibleRides.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: resolveImageProvider(ProfileImgs.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BannerHeadder(
                    imagePath: 'assets/images/badges-achiv.jpg',
                    title: l10n.myCyclingDetails,
                    subtitle: '',
                    centerTitle: true,
                    onBackTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 28),
                  RiderStatsSection(
                    riderLevel: riderLevel.isEmpty
                        ? l10n.riderLevel
                        : "${l10n.riderLevel}: $riderLevel",
                    badgesTitle: l10n.totalDistance,
                    badgesValue: totalDistance.isEmpty ? l10n.noEventsFound : totalDistance,
                    pointsTitle: l10n.totalRides,
                    pointsValue: totalRides.isEmpty ? l10n.noEventsFound : totalRides,
                    progressTitle: l10n.badgesEarned,
                    progressValue: badgesEarned,
                  ),
                  if (isArabic) const SizedBox(height: 12),
                  const SizedBox(height: 18),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 2),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 51,
                  //     child: ElevatedButton(
                  //       onPressed: () {},
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF5257B5),
                  //         elevation: 0,
                  //         padding: const EdgeInsets.symmetric(
                  //           vertical: 12,
                  //           horizontal: 15,
                  //         ),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(7.4843),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         "View Full Stats (Coming soon!)",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontFamily: 'Outfit',
                  //           fontSize: 17.4634,
                  //           fontWeight: FontWeight.w400,
                  //           height: 1.5,
                  //           letterSpacing: 0,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 40),
                  CyclingIdentityCard(
                    riderLevel: riderLevel,
                    progressPercent: _progressPercent,
                    progressText: _progressText,
                  ),
                  const SizedBox(height: 40),
                  SectionHeader(
                    title: l10n.yourRidesAndEvents,
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MYEVENET(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 31),
                  if (visibleRides.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _NoEventEmptyState(
                        title: l10n.noCompletedRidesYet,
                        subtitle: l10n.eventHistoryHint,
                      ),
                    )
                  else
                    ...visibleRides.take(3).map((ride) {
                      return Column(
                        children: [
                          RideTile(
                            title: ride['title'] ?? l10n.ride,
                            distance: ride['distance'] ?? '0 km',
                            riders: ride['participants'] ?? '0 riders',
                            date: _formatDate(ride['date'] ?? ''),
                            imagePath:
                                ride['image'] ?? 'assets/images/no-img.jpg',
                            onNavigate: () {
                              final eventId = ride['id'] as String?;
                              if (eventId != null && eventId.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EventDetailsScreen(eventId: eventId),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  const SizedBox(height: 40),
                  CompletedRidesCard(
                    rides: completedRidesCount,
                  ),
                  const SizedBox(height: 46),
                  communitiesHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _communities.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              l10n.noJoinedCommunitiesYet,
                              textAlign:
                                  isArabic ? TextAlign.right : TextAlign.left,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _communities
                                .map((community) {
                                  final label = _communityDisplayName(
                                    community,
                                    isArabic: isArabic,
                                  );
                                  if (label.isEmpty) return const SizedBox.shrink();

                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.softCream,
                                      ),
                                    ),
                                    child: Text(
                                      label,
                                      textAlign:
                                          isArabic ? TextAlign.right : TextAlign.left,
                                      textDirection: isArabic
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.charcoal,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 56),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.yourListedGear,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1,
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_gearItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(l10n.noListedGearYet),
                    )
                  else
                    SizedBox(
                      height: 312,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _gearItems
                            .map((gear) => GearCard(
                                  imagePath: gear.image,
                                  title: gear.title,
                                  price: gear.price,
                                  time: _formatDate(gear.timePosted),
                                  postedBy: gear.postedBy.isNotEmpty
                                      ? gear.postedBy
                                      : 'Unknown',
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Recent';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) return 'Today';
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays} days ago';
      if (difference.inDays < 30)
        return '${(difference.inDays / 7).floor()} weeks ago';

      return '${date.month}/${date.day}';
    } catch (_) {
      return formatIsoDateForDisplay(dateStr);
    }
  }

  Widget communitiesHeader() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment:
            isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Image.asset(
                "assets/icons/your_communities.jpg",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.your_communities,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          /// RIGHT SIDE (EXPLORE)
          // Row(
          //   children: const [
          //     Text(
          //       "Explore",
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Colors.black54,
          //       ),
          //     ),
          //     SizedBox(width: 4),
          //     Icon(
          //       Icons.chevron_right,
          //       size: 18,
          //       color: Colors.black54,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

class _NoEventEmptyState extends StatelessWidget {
  const _NoEventEmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 42,
            color: Color(0xFF5257B5),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

String _communityDisplayName(Map<String, dynamic> community,
    {bool isArabic = false}) {
  return ProfileRepository.resolveCommunityDisplayName(
    community,
    isArabic: isArabic,
  );
}
