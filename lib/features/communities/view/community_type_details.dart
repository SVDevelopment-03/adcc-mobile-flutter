import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_details_header.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_events_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_gallery_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_tracks_tab.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_updates_tab.dart';
import 'package:adcc/features/communities/sections/join_community_screen.dart';
import 'package:adcc/features/communities/sections/leavecommunity.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:adcc/l10n/app_localizations.dart';
String _distanceUnitLabel(BuildContext context) {
  final locale = Localizations.localeOf(context).languageCode;
  return locale.toLowerCase().startsWith('ar') ? 'كم' : 'km';
}
class CommunityCityDetails extends StatefulWidget {
  final CommunityModel community;

  const CommunityCityDetails({
    super.key,
    required this.community,
  });

  @override
  State<CommunityCityDetails> createState() => _CommunityCityDetailsState();
}

class _CommunityCityDetailsState extends State<CommunityCityDetails> {
  static const Color _primaryBlue = Color(0XFFF96291);
  static const Color _redAccent = Color(0xFFC12D32);
  static const Color _goldAccent = Color(0xFFCF9F0C);

  int selectedTabIndex = 0;
  bool isLoading = false;
  CommunityModel? _apiCommunity;
  //  Local variable to track join status
  late bool _isJoined;

  final CommunitiesService _communitiesService = CommunitiesService();

  // Tabs labels moved to build() to use localization
  // final List<String> tabs will be provided from build context
  @override
  void initState() {
    super.initState();
    _isJoined = false;
    _apiCommunity = widget.community;

    _fetchCommunityById();
    _checkMemberStatus();
  }

  Future<void> _fetchCommunityById() async {
    setState(() => isLoading = true);

    final communityId = widget.community.id;

    final result = await _communitiesService.getCommunityById(
      communityId: communityId,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result.data != null) {
      setState(() {
        _apiCommunity = result.data!;
      });
    }
  }

  Future<void> _checkMemberStatus() async {
    setState(() => isLoading = true);

    final result = await _communitiesService.getCommunityMemberStatus(
      communityId: widget.community.id,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result.success) {
      setState(() {
        _isJoined = result.data ?? false;
        widget.community.isJoined = _isJoined;
      });
    }
  }

  //  Method to refresh community data from server
  Future<void> _refreshCommunityData() async {
    await Future.wait([
      _fetchCommunityById(),
      _checkMemberStatus(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final c = _apiCommunity ?? widget.community;
    final l = AppLocalizations.of(context)!;
    final title = c.title;
    final description = c.description;

    final city = c.city?.isNotEmpty == true ? c.city! : (c.location ?? l.not_available);

    final category = c.type.isNotEmpty ? c.type : l.not_available;

    final track = c.trackName?.isNotEmpty == true ? c.trackName! : l.not_available;
    // Prepare async localized category labels
    final Future<String> localizedCategoryFuture = c.type.trim().isEmpty
        ? Future.value(l.not_available)
        : LookupService.instance
            .resolveLabels(
              ApiEndpoints.lookupTypeCommunityCategory,
              c.type.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
            )
            .then((list) => list.join(', '));

    final founded = (c.foundedYear ?? 0) > 0 ? c.foundedYear.toString() : l.not_available;

    final members = c.membersCount != null ? c.membersCount.toString() : "0";

    final events = c.eventsCount != null ? c.eventsCount.toString() : "0";
    final theme = const _CommunityDetailTheme();
    final tabs = [
      l.eventsTab,
      l.tracksTab,
      l.galleryTab,
      l.updatesTab,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              CommunitiesImgs.AllcommunityBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 16, 10, 34),
            children: [
              // TOP BANNER IMAGE
              CommunityDetailsHeader(
                base64Image: c.imageUrl,
                title: "",
                onBackTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title ,
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1, // 100% line height
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ShareBadge(
                    shareText: _shareText(c),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 32),

              FutureBuilder<String>(
                future: localizedCategoryFuture,
                builder: (context, snap) {
                  final localizedCategory = snap.connectionState == ConnectionState.done && snap.data != null
                      ? snap.data!
                      : category;

                  final localizedTrack = c.displayTrackName(Localizations.localeOf(context).languageCode).isNotEmpty
                      ? c.displayTrackName(Localizations.localeOf(context).languageCode)
                      : l.not_available;

                  return _InfoGrid(
                    city: city,
                    category: localizedCategory,
                    primaryTrack: localizedTrack,
                    founded: founded,
                    upcomingEvents: events,
                    members: members,
                    theme: theme,
                  );
                },
              ),

              const SizedBox(height: 33),

              Text(
                l.communityHighlights,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1, // 100% line height
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),

              const SizedBox(height: 16),

              _HighlightsCard(
                activeMembers: '${_formatCount(c.membersCount ?? 0)}+',
                totalDistance: c.distance != null
                    ? '${c.distance!.toStringAsFixed(1)} ${_distanceUnitLabel(context)}'
                    : l.not_available,
                avgRideRating: _avgRideRating(c),
                theme: theme,
              ),

              const SizedBox(height: 28),

              _TabsRow(
                tabs: tabs,
                selectedIndex: selectedTabIndex,
                theme: theme,
                onTap: (i) => setState(() => selectedTabIndex = i),
              ),

              const SizedBox(height: 8),

              _TabContent(
                selectedTabIndex: selectedTabIndex,
                highlightCardColor: theme.highlightCardBackground,
                communityId: c.id,
                trackId: c.trackId,
                trackIds: c.trackIds,
              ),

              const SizedBox(height: 12),

              AppButton(
                label: isLoading
                    ? l.joinChecking
                    : (_isJoined ? l.leaveCommunityTitle : l.join_community_button),
                onPressed: isLoading ? null : _handleJoinLeave,
                type: _isJoined ? AppButtonType.danger : AppButtonType.primary,
                backgroundColor: theme.actionColor,
                textColor: Colors.white,
                borderRadius: 7.48,
                height: 51,
                textStyle: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 17.46, // 17.4634 ≈ 17.46
                  fontWeight: FontWeight.w400,
                  height: 1.50, // 26.1369 / 17.4634
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _shareText(CommunityModel community) {
    final l = AppLocalizations.of(context)!;
    final title = community.title.isNotEmpty
        ? community.title
        : l.share_community_fallback_title;
    final description = community.description.isNotEmpty
        ? community.description
        : l.share_community_fallback_description;
    return '$title\n\n$description\n\n${l.share_community_footer}';
  }

  String _avgRideRating(CommunityModel community) {
    final l = AppLocalizations.of(context)!;
    final events = community.eventsCount ?? 0;
    if (events == 0) return l.not_available;

    final members = community.membersCount ?? 0;
    final distance = community.distance ?? 0.0;

    final double engagementScore =
        (members / (events * 10 + 1)).clamp(1.0, 5.0) as double;
    final double distanceScore = (distance / 20.0).clamp(1.0, 5.0) as double;

    final double rating =
        ((engagementScore + distanceScore) / 2).clamp(1.0, 5.0) as double;
    return '${rating.toStringAsFixed(1)}/5';
  }

  //  Separate method to handle join/leave logic
  Future<void> _handleJoinLeave() async {
    if (!_isJoined) {
      final isGuest = await TokenStorageService.isGuestUser();
      if (isGuest) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseSignInToJoinCommunities),
            backgroundColor: const Color(0xFF323232),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // JOIN COMMUNITY
      setState(() => isLoading = true);

      final result = await _communitiesService.joinCommunity(
        communityId: widget.community.id,
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      if (result.success) {
        // Update local state
        setState(() {
          _isJoined = true;
          widget.community.isJoined = true;
        });

        // Show success message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.communityJoinedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );

        final shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JoinCommunity(
              community: widget.community,
            ),
          ),
        );

        // If JoinCommunity returns true, refresh data
        if (shouldRefresh == true && mounted) {
          await _refreshCommunityData();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? AppLocalizations.of(context)!.joinFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // LEAVE COMMUNITY
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => LeaveCommunity(
            community: widget.community,
          ),
        ),
      );

      if (result == true && mounted) {
        // Update local state
        setState(() {
          _isJoined = false;
          widget.community.isJoined = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.communityLeftSuccessfully),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

class _ShareBadge extends StatelessWidget {
  final String shareText;

  const _ShareBadge({required this.shareText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final box = context.findRenderObject() as RenderBox?;
        final positionOrigin = box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : Rect.fromLTWH(0, 0, 1, 1);

        Share.share(
          shareText,
          subject: AppLocalizations.of(context)!.share_community_subject,
          sharePositionOrigin: positionOrigin,
        );
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 120, 161, 0.36), // #99D3B55C
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/icons/share_2.png",
          color: Color.fromRGBO(255, 120, 161, 1),
          height: 17.5,
          width: 17.5,
        ),
      ),
    );
  }
}

class _CommunityDetailTheme {
  final Color infoShellStart;
  final Color infoShellEnd;
  final Color statIconBackground;
  final Color statIconColor;
  final Color selectedTabColor;
  final Color inactiveTabColor;
  final Color actionColor;
  final Color highlightCardBackground;

  const _CommunityDetailTheme({
    this.infoShellStart = const Color(0x00000000),
    this.infoShellEnd = const Color(0x00000000),
    this.statIconBackground = const Color(0xFFF96291),
    this.statIconColor = Colors.white,
    this.selectedTabColor = _CommunityCityDetailsState._primaryBlue,
    this.inactiveTabColor = const Color.fromRGBO(249, 98, 145, 0.1),
    this.actionColor = _CommunityCityDetailsState._primaryBlue,
    this.highlightCardBackground = const Color(0xFFC9EFEA),
  });
}

String _formatCount(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

class _InfoGrid extends StatelessWidget {
  final String city;
  final String category;
  final String primaryTrack;
  final String founded;
  final String upcomingEvents;
  final String members;
  final _CommunityDetailTheme theme;

  const _InfoGrid({
    required this.city,
    required this.category,
    required this.primaryTrack,
    required this.founded,
    required this.upcomingEvents,
    required this.members,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget tile({
      required String iconPath,
      required String label,
      required String value,
      required bool tall,
    }) {
      return Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB5CB),
              Color(0xFFFFE1EA),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            SizedBox(height: tall ? 14 : 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 12.44,
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: tall ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      (
        icon: "assets/icons/city-indicator.png",
        label: l.cityLabel,
        value: city,
        tall: true
      ),
      (
        icon: "assets/icons/category-indicator.png",
        label: l.typeLabel,
        value: category,
        tall: true
      ),
      (
        icon: "assets/icons/track-indicator.png",
        label: l.trackLabel,
        value: primaryTrack,
        tall: true
      ),
      (
        icon: "assets/icons/found-indicator.png",
        label: l.foundedLabel,
        value: founded,
        tall: false
      ),
      (
        icon: "assets/icons/upcoming-indicator.png",
        label: l.upcomingEvents,
        value: upcomingEvents.padLeft(2, '0'),
        tall: false
      ),
      (
        icon: "assets/icons/member-indicator.png",
        label: l.membersLabel,
        value: _formatCount(int.tryParse(members) ?? 0),
        tall: false
      ),
    ];

    return Container(
      padding: theme.infoShellStart == Colors.transparent
          ? EdgeInsets.zero
          : const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: theme.infoShellStart == Colors.transparent
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.infoShellStart,
                  theme.infoShellEnd,
                ],
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 8,
          mainAxisExtent: 141,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return tile(
            iconPath: item.icon,
            label: item.label,
            value: item.value,
            tall: item.tall,
          );
        },
      ),
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  final String activeMembers;
  final String totalDistance;
  final String avgRideRating;
  final _CommunityDetailTheme theme;

  const _HighlightsCard({
    required this.activeMembers,
    required this.totalDistance,
    required this.avgRideRating,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget row({
      required String iconPath,
      required String label,
      required String value,
    }) {
      return Container(
        width: 358,
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          // color: theme.highlightCardBackground,
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Row(
          children: [
            /// ICON CONTAINER
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: theme.statIconBackground,
                borderRadius: BorderRadius.circular(54),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
                fit: BoxFit.contain,
                color: theme.statIconColor,
              ),
            ),

            const SizedBox(width: 9),

            /// LABEL
            SizedBox(
              width: 150,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ),

            const Spacer(),

            /// VALUE
            Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
                color: AppColors.charcoal,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        row(
          iconPath: "assets/images/active_member.png",
          label: l.activeMembersLabel,
          value: activeMembers,
        ),
        const SizedBox(height: 8),
        row(
          iconPath: "assets/images/total_distance.png",
          label: l.trackDistanceLabel,
          value: totalDistance,
        ),
        const SizedBox(height: 8),
        row(
          iconPath: "assets/images/avg_ride.png",
          label: l.averageRideRatingLabel,
          value: avgRideRating,
        ),
      ],
    );
  }
}

class _TabsRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final _CommunityDetailTheme theme;
  final ValueChanged<int> onTap;

  const _TabsRow({
    required this.tabs,
    required this.selectedIndex,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: index == 0 ? 92 : (tabs[index].length > 6 ? 117 : 90),
              height: 38,
              padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.selectedTabColor
                    : theme.inactiveTabColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43, // 20 / 14 ≈ 1.43
                  letterSpacing: 0,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final int selectedTabIndex;
  final Color highlightCardColor;
  final String communityId;
  final String? trackId;
  final List<String> trackIds;

  const _TabContent({
    required this.selectedTabIndex,
    required this.highlightCardColor,
    required this.communityId,
    required this.trackId,
    required this.trackIds,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return CommunityEventsTab(
          cardColor: highlightCardColor,
          communityId: communityId,
          trackId: trackId,
        );

      case 1:
        return CommunityTracksTab(
          cardColor: highlightCardColor,
          communityId: communityId,
          trackId: trackId,
          trackIds: trackIds,
        );

      case 2:
        return CommunityGalleryTab(communityId: communityId);

      case 3:
        return CommunityUpdatesTab(communityId: communityId);

      default:
        return const SizedBox();
    }
  }
}
