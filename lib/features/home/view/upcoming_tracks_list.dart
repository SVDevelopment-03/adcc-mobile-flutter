import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/utils/date_utils.dart';

class UpcomingTracksList extends StatelessWidget {
  final List<HomeEventModel> events;
  final void Function(String eventId)? onEventTap;
  final bool showFallback;

  const UpcomingTracksList({
    super.key,
    this.events = const [],
    this.onEventTap,
    this.showFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    final uiEvents = events
        .map(
          (e) => EventModel(
            id: e.id,
            image: e.image,
            title: e.title,
            day: e.date,
            type: e.type,
          ),
        )
        .toList();

    // Card fills the screen width (minus list padding) on phones and is
    // capped on tablets, so it never runs off the right edge.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - 32).clamp(0.0, 420.0);

    return SizedBox(
      height: UpcomingEventCard.cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: uiEvents.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final ev = uiEvents[index];
          return GestureDetector(
            onTap: ev.id.isNotEmpty ? () => onEventTap?.call(ev.id) : null,
            child: UpcomingEventCard(event: ev, width: cardWidth),
          );
        },
      ),
    );
  }
}

class UpcomingEventCard extends StatelessWidget {
  static const Color _chipBlue = Color(0xFF435974);

  static const double cardHeight = 295;

  final EventModel event;
  final double width;

  const UpcomingEventCard({
    super.key,
    required this.event,
    this.width = 358,
  });

  String _formatDate(String dateStr, BuildContext context) {
    try {
      final parsedDate = DateTime.parse(dateStr);
      final l = AppLocalizations.of(context)!;
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
      return '${months[parsedDate.month - 1]} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return formatIsoDateForDisplay(dateStr, format: 'MMM d, yyyy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: cardHeight,
      child: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: event.image.startsWith('http')
                  ? Image.network(
                      event.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/no-img.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      event.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          /// SHARE BUTTON
          // Positioned(
          //   top: 17,
          //   right: 15,
          //   child: Container(
          //     height: 25,
          //     width: 25,
          //     decoration: const BoxDecoration(
          //       color: _shareBlue,
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Icon(
          //       Icons.share,
          //       size: 15,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),

          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 15,
            end: 15,
            bottom: 15,
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(
                15,
                9,
                12,
                12,
              ),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    HomeImgs.homeFeaturedEventsCardBackground,
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 255, 255, 255), // 40% opacity
                    BlendMode.dstOver,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SOCIAL BADGE
                  Container(
                      // width: 16,
                      // height: 24,
                      // alignment: Alignment.,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _chipBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12, // ≈1.33
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      )),

                  const SizedBox(height: 8),

                  /// TITLE
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      letterSpacing: 0,
                      color: AppColors.charcoal,
                    ),
                  ),

                  const SizedBox(height: 2),

                  /// DAY ROW
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/calender.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _formatDate(event.day, context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12.8226,
                            fontWeight: FontWeight.w400,
                            height: 17.0968 / 12.8226,
                            letterSpacing: 0,
                            color: Color(0xFF484A4D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EventModel {
  final String id;
  final String image;
  final String title;
  final String day;
  final String type;

  EventModel({
    this.id = '',
    required this.image,
    required this.title,
    required this.day,
    required this.type,
  });
}
