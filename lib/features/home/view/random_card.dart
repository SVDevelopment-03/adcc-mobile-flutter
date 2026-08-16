import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedEventsList extends StatelessWidget {
  final List<HomeEventModel> events;
  final ValueChanged<String>? onEventTap;
  final bool showFallback;

  const FeaturedEventsList({
    super.key,
    this.events = const [],
    this.onEventTap,
    this.showFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = events.take(3).toList();
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.featured_events,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 309,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final event = data[index];
              return FeaturedEventCard(
                image: event.image,
                title: event.title,
                date: event.date,
                distance: event.distance,
                width: 358,
                height: 309,
                panelTop: 198,
                onTap: () => onEventTap?.call(event.id),
                onShare: () {
                  ShareHelper.share(
                    context,
                    ShareHelper.event(event.title, event.id, l10n),
                    subject: l10n.share_event_subject,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class FeaturedEventCard extends StatelessWidget {
  static const Color _shareBlue = Color(0xFF02A1CE);
  static const Color _chipBlue = Color(0xFF435974);
  static const Color _panelBlueTint = Color(0xFFF1F1FB);

  final String image;
  final String title;
  final String date;
  final String distance;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final double? width;
  final double height;
  final double panelTop;

  const FeaturedEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.distance,
    this.onTap,
    this.onShare,
    this.width,
    this.height = 275,
    this.panelTop = 160,
  });

  String _formatDate(String dateStr, BuildContext context) {
    try {
      final parsedDate = DateTime.parse(dateStr);
      return '${_monthName(parsedDate.month, context)} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _monthName(int month, BuildContext context) {
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
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/no-img.jpg',
                        height: height,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      image,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            // Positioned(
            //   top: 16,
            //   right: 16,
            //   child: Container(
            //     height: 25,
            //     width: 25,
            //     decoration: const BoxDecoration(
            //       color: _shareBlue,
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Icon(
            //       Icons.share,
            //       color: Colors.white,
            //       size: 15,
            //     ),
            // ),
            // ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 15,
              end: 15,
              bottom: 22,
              child: Container(
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsetsDirectional.fromSTEB(15, 9, 15, 12),
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
                    // alignment: Alignment(0, -0.9), // Move image down
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Featured Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _chipBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.featured,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Title
                    Text(
                      title,
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

                    const SizedBox(height: 6),

                    /// Date + Distance Row
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/calender.png",
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(date, context),
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
                        const SizedBox(width: 12),
                        Image.asset(
                          "assets/icons/km_empty.png",
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
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
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
