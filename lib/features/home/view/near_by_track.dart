import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/section_header.dart';
import '../../routes/view/track_near_you_all.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'dart:ui';

class NearbyTracksSection extends StatelessWidget {
  final List<HomeTrackModel> tracks;
  final bool showFallback;

  const NearbyTracksSection({
    super.key,
    this.tracks = const [],
    this.showFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    final data = tracks;
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        /// HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: AppLocalizations.of(context)!.nearbyTracks,
            onViewAll: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TrackNearAllPage()),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        /// TRACK LIST
        SizedBox(
          height: 323,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return NearbyTrackCard(track: data[index]);
            },
          ),
        ),
      ],
    );
  }
}

class NearbyTrackCard extends StatelessWidget {
  final HomeTrackModel track;

  const NearbyTrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (track.id.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RouteDetailsScreen(
                  routeData: {'id': track.id},
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 286,
          height: 303,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: CachedNetworkImageProvider(
                HomeImgs.homeNeatbyTracksBackground,
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromARGB(255, 255, 255, 255), // 40% opacity
                BlendMode.dstOver,
              ),
              // alignment: Alignment(0, -0.9), // Move image down
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
          /// IMAGE AREA
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: AdaptiveImage(
                  imagePath: track.image,
                  width: 286,
                  height: 229,
                  fit: BoxFit.cover,
                ),
              ),

              /// LEVEL BADGE
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 15,
                top: 14,
                child: _Badge(
                  text: track.level,
                  width: 143,
                ),
              ),

              /// STATUS BADGE
              Positioned.directional(
                textDirection: Directionality.of(context),
                end: 15,
                top: 14,
                child: _Badge(
                  text: track.status,
                  width: 67,
                ),
              ),
            ],
          ),

              /// INFO SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: 0,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        /// LOCATION ICON
                        Image.asset(
                          "assets/icons/location.png",
                          width: 16,
                          height: 16,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          track.location,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0, // 100% line height
                            letterSpacing: 0,
                            color: AppColors.textDark.withValues(alpha: 0.8),
                          ),
                        ),

                        const Spacer(),

                        /// DISTANCE ICON
                        Image.asset(
                          "assets/icons/km.png",
                          width: 16,
                          height: 16,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          track.distance,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: 0,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double width;

  const _Badge({
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          width: width,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x26000000), // #000000 - 15%
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
