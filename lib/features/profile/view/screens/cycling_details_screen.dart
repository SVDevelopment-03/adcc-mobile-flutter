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
              ? '${performance.completionRate} completion'
              : '${(_progressPercent * 100).round()}% completion';
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
          _error = 'Failed to load cycling details';
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

    final riderLevel = _profileStats['riderLevel'] ?? 'Intermediate';
    final totalDistance = '${_profileStats['totalDistance'] ?? '0'} km';
    final totalRides = '${_profileStats['totalRides'] ?? '0'} Days';
    final badgesEarned = '$_earnedBadges';
    final completedRidesCount = _completedRides.length;

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
                    riderLevel: "${l10n.riderLevel}: $riderLevel",
                    badgesTitle: l10n.totalDistance,
                    badgesValue: totalDistance,
                    pointsTitle: l10n.totalRides,
                    pointsValue: totalRides,
                    progressTitle: l10n.badgesEarned,
                    progressValue: "$badgesEarned",
                  ),
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
                  if (_completedRides.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(l10n.noCompletedRidesYet),
                    )
                  else
                    ..._completedRides.take(3).map((ride) {
                      return Column(
                        children: [
                          RideTile(
                            title: ride['title'] ?? 'Ride',
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
                            child: Text(l10n.noJoinedCommunitiesYet),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: _communities
                                .map((community) => communityChip(
                                      _communityDisplayName(community),
                                    ))
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
      return dateStr;
    }
  }

  Widget communitiesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/your_communities.jpg",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
              Text(
                "Your Communities",
                style: TextStyle(
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

Widget communityChip(String text) {
  return Container(
    constraints: const BoxConstraints(minHeight: 38),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0,
        color: AppColors.charcoal,
      ),
    ),
  );
}

String _communityDisplayName(Map<String, dynamic> community) {
  final nested = community['community'];
  final candidates = <dynamic>[
    community['name'],
    community['title'],
    community['communityName'],
    community['label'],
    community['slug'],
    community['nameEn'],
    community['nameAr'],
    if (nested is Map<String, dynamic>) nested['name'],
    if (nested is Map<String, dynamic>) nested['title'],
    if (nested is Map<String, dynamic>) nested['communityName'],
  ];

  for (final value in candidates) {
    final text = ResponseParser.asString(value);
    if (text.isNotEmpty) return text;
  }

  return 'Community';
}
