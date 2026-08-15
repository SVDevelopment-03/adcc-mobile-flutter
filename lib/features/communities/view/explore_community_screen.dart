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
import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ExploreCommunityScreen extends StatefulWidget {
  final CommunityModel community;

  const ExploreCommunityScreen({
    super.key,
    required this.community,
  });

  @override
  State<ExploreCommunityScreen> createState() => _ExploreCommunityScreenState();
}

class _ExploreCommunityScreenState extends State<ExploreCommunityScreen> {
  int selectedTabIndex = 0;

  //  Local state variables
  late bool _isJoined;
  bool isLoading = false;
  CommunityModel? _apiCommunity;
  final CommunitiesService _communitiesService = CommunitiesService();

  @override
  void initState() {
    super.initState();
    _isJoined = false;
    _fetchCommunityById();
    _checkMemberStatus();
  }

  Future<void> _fetchCommunityById() async {
    setState(() => isLoading = true);

    final result = await _communitiesService.getCommunityById(
      communityId: widget.community.id,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result.success && result.data != null) {
      setState(() {
        _apiCommunity = result.data!;
      });
    } else {
      debugPrint("Failed to fetch community details");
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
      final joined = result.data ?? false;

      setState(() {
        _isJoined = joined;
        widget.community.isJoined = joined;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _apiCommunity ?? widget.community;
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      l10n.eventsTab,
      l10n.tracksTab,
      l10n.galleryTab,
      l10n.updatesTab,
    ];

    return Scaffold(
      backgroundColor: Color(0xffeaf6fb),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            CommunityDetailsHeader(
              base64Image: c.imageUrl,
              title: " ",
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 24),

            // Title + Share icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    c.title,
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1, // 100% line height
                      letterSpacing: 0,
                      color: AppColors.deepRed,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                //  SHARE ICON
                _ShareBadge(
                  onTap: () {
                    ShareHelper.share(
                      context,
                      ShareHelper.community(
                        widget.community.title,
                        widget.community.id,
                        l10n,
                      ),
                      subject: l10n.share_community_subject,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            //  Description
            Text(
              c.description.trim().isNotEmpty
                  ? c.description.trim()
                  : l10n.noDescriptionAvailable,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1, // 100% line height
                letterSpacing: 0,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 45),

            _InfoGrid(community: c),

            const SizedBox(height: 31),

            Text(
              l10n.communityHighlights,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1, // 100% line height
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 14),

            _HighlightsCard(community: c),

            const SizedBox(height: 49),

            // Tabs
            _TabsRow(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              onTap: (i) => setState(() => selectedTabIndex = i),
            ),

            const SizedBox(height: 28),

            // Tab content
            _TabContent(
              selectedTabIndex: selectedTabIndex,
              communityId: c.id,
              trackId: c.trackId,
            ),

            const SizedBox(height: 50),

            //  Dynamic button based on join status
            _BottomButton(
              title: isLoading
                  ? l10n.pleaseWait
                  : (_isJoined ? l10n.leaveCommunityTitle : l10n.join_community_button),
              onTap: isLoading ? null : _handleJoinLeave,
              isLoading: isLoading,
              isJoined: _isJoined,
            ),
          ],
        ),
      ),
    );
  }

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

      setState(() => isLoading = true);

      final result = await _communitiesService.joinCommunity(
        communityId: widget.community.id,
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.communityJoinedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );

        await _checkMemberStatus();

        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => JoinCommunity(
              community: widget.community,
            ),
          ),
        );

        if (result == true && mounted) {
          await _checkMemberStatus();
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
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => LeaveCommunity(
            community: widget.community,
          ),
        ),
      );

      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.communityLeftSuccessfully),
            backgroundColor: Colors.orange,
          ),
        );

        await _checkMemberStatus();
      }
    }
  }
}

class _ShareBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _ShareBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xff96d7eb), // #99D3B55C
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/icons/share_2.png",
          height: 17.5,
          width: 17.5,
          color: Color(0xff02A1CE),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final CommunityModel community;

  const _InfoGrid({required this.community});

  @override
  Widget build(BuildContext context) {
    final c = community;

    Widget tile({
      required String iconPath,
      required String label,
      required String value,
    }) {
      return Container(
        padding: const EdgeInsets.all(19),
        // height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                iconPath,
                height: 25,
                width: 25,
                color: Color(0xFFB11212),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 12.44, // 12.437 ≈ 12.44
                  fontWeight: FontWeight.w400,
                  height: 1, // 100% line height
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1, // 100% line height
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.85,
      children: [
        tile(
          iconPath: "assets/icons/city.png",
          label: AppLocalizations.of(context)!.cityLabel,
          value: (c.location ?? "Abu Dhabi"),
        ),
        tile(
          iconPath: "assets/icons/category.png",
          label: AppLocalizations.of(context)!.category,
          value: c.type.isEmpty ? "—" : c.type,
        ),
        tile(
          iconPath: "assets/icons/primary_tracks.png",
          label: AppLocalizations.of(context)!.primary_track,
          value: (c.trackName ?? "—"),
        ),
        tile(
          iconPath: "assets/icons/founded.png",
          label: AppLocalizations.of(context)!.foundedLabel,
          value: (c.foundedYear ?? 0) > 0 ? c.foundedYear.toString() : "—",
        ),
        tile(
          iconPath: "assets/icons/upcoming_events.png",
          label: AppLocalizations.of(context)!.upcomingEvents,
          value: "${c.eventsCount ?? 0}",
        ),
        tile(
          iconPath: "assets/icons/members.png",
          label: AppLocalizations.of(context)!.members,
          value: "${c.membersCount ?? 0}",
        ),
      ],
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  final CommunityModel community;

  const _HighlightsCard({required this.community});

  @override
  Widget build(BuildContext context) {
    final c = community;

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
          // color: const Color(0xFFFFF3E2),
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Row(
          children: [
            /// ICON CONTAINER
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF02a2cf),
                borderRadius: BorderRadius.circular(54),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
                fit: BoxFit.contain,
                color: Colors.white,
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
          label: AppLocalizations.of(context)!.activeMembersLabel,
          value: "${c.membersCount ?? 0}+",
        ),
        const SizedBox(height: 10),
        row(
          iconPath: "assets/images/total_distance.png",
          label: AppLocalizations.of(context)!.trackDistanceLabel,
          value: c.distance != null
              ? '${c.distance!.toStringAsFixed(1)} Km'
              : 'N/A',
        ),
        const SizedBox(height: 10),
        row(
          iconPath: "assets/images/avg_ride.png",
          label: AppLocalizations.of(context)!.founded_year,
          value: (c.foundedYear ?? 0) > 0 ? c.foundedYear.toString() : 'N/A',
        ),
      ],
    );
  }
}

class _TabsRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _TabsRow({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
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
              width: 82,
              height: 38,
              padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
              decoration: BoxDecoration(
                color:
                    isSelected ? Color(0xff02a2cf) : const Color(0xFF1A1C201A),
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
  final String communityId;
  final String? trackId;

  const _TabContent({
    required this.selectedTabIndex,
    required this.communityId,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return CommunityEventsTab(trackId: trackId);

      case 1:
        return CommunityTracksTab(trackId: trackId);

      case 2:
        return CommunityGalleryTab(communityId: communityId);

      case 3:
        return CommunityUpdatesTab(communityId: communityId);

      default:
        return const SizedBox();
    }
  }
}

class _BottomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isJoined;

  const _BottomButton({
    required this.title,
    required this.onTap,
    required this.isLoading,
    required this.isJoined,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isJoined ? const Color(0xFFB11212) : const Color(0xFFB11212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 17.46, // 17.4634 ≈ 17.46
                  fontWeight: FontWeight.w400,
                  height: 1.5, // 26.1369 / 17.4634 ≈ 1.5
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
