import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import 'dart:convert';

class RouteCommunitiesSection extends StatefulWidget {
  final String trackId;

  const RouteCommunitiesSection({
    super.key,
    required this.trackId,
  });

  @override
  State<RouteCommunitiesSection> createState() =>
      _RouteCommunitiesSectionState();
}

class _RouteCommunitiesSectionState extends State<RouteCommunitiesSection> {
  late Future<List<CommunityModel>> _communitiesFuture;
  final TracksService _tracksService = TracksService();

  @override
  void initState() {
    super.initState();
    _communitiesFuture =
        _tracksService.getTrackRelatedCommunities(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.communities_using_track,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 273,
            child: FutureBuilder<List<CommunityModel>>(
              future: _communitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.error_loading_communities,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                final communities = snapshot.data ?? [];

                if (communities.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_communities_for_track,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: communities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final community = communities[index];

                    return CommunityCard(
                      imagePath:
                          community.imageUrl ?? 'assets/images/no-img.jpg',
                      title: community.title,
                      subtitle: community.description.isNotEmpty
                          ? community.description
                          : AppLocalizations.of(context)!.cycling_community_subtitle(community.trackName ?? AppLocalizations.of(context)!.various_tracks),
                      members: community.membersCount != null
                          ? AppLocalizations.of(context)!.members_count(community.membersCount!.toStringAsFixed(0))
                          : AppLocalizations.of(context)!.unknown_members,
                      joined: community.isJoined,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String members;
  final bool joined;
  final VoidCallback onTap;

  const CommunityCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.members,
    required this.joined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 358,
      height: 273,
      child: Material(
        // color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11.59),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.59),
            child: Container(
              // color: const Color(0xFFFFEFD7),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(TrackImgs.trackCardBackground),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(11.59),
              ),

              child: Column(
                children: [
                  SizedBox(
                    width: 358,
                    height: 178.66,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.46),
                              topRight: Radius.circular(10.46),
                            ),
                            child: _buildImage(),
                          ),
                        ),

                        // overlay
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.10),
                          ),
                        ),

                        // Joined chip
                        if (joined)
                          const Positioned(
                            top: 13,
                            left: 12,
                            child: _JoinChip(),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 15.6872,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 10.4581,
                              fontWeight: FontWeight.w400,
                              color: Color(0xB21A1C20),
                              height: 1.25,
                            ),
                          ),
                          const Spacer(),

                          // Members row
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/per.jpg",
                                width: 16,
                                height: 16,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.groups_2_outlined,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Text(
                                members,
                                style: const TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
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
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) {
      return _placeholder();
    }

    // If base64 image
    if (imagePath.startsWith("data:image")) {
      try {
        final base64String = imagePath.split(',').last;

        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (e) {
        debugPrint("Base64 decode failed: $e");
        return _placeholder();
      }
    }

    // If network image
    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    // If local asset
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.softCream,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _JoinChip extends StatelessWidget {
  const _JoinChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        AppLocalizations.of(context)!.joinedLabel,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
