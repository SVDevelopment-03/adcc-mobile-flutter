import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/store/view/Screen/store_details_screen.dart';

class RecentlyPost extends StatelessWidget {
  final List<HomeStoreItemModel> items;
  final bool showFallback;

  const RecentlyPost({
    super.key,
    this.items = const [],
    this.showFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final data = items.take(3).toList();

    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Marketplace",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StoreScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      "View All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFF484A4D),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Color(0xFF484A4D),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 476,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: data
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: RecentlyPostCard(item: item),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class RecentlyPostCard extends StatelessWidget {
  static const Color _shareBlue = Color(0xFF02A1CE);
  static const Color _primaryBlue = Color(0xFF025AE8);

  final HomeStoreItemModel item;

  const RecentlyPostCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openDetails(context);
      },
      child: Container(
        width: 314,
        height: 456,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              HomeImgs.homeMarketCardBackground,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255), // 40% opacity
              BlendMode.dstOver,
            ),
            // alignment: Alignment(0, -0.9), // Move image down)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AdaptiveImage(
                    imagePath: item.image,
                    width: 290,
                    height: 351,
                    fit: BoxFit.cover,
                  ),
                ),
                // Positioned(
                //   top: 8,
                //   right: 8,
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
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.zero,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.zero,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                  children: [
                    const TextSpan(
                      text: "Posted by ",
                      style: TextStyle(
                        color: Color(0x991A1C20),
                      ),
                    ),
                    TextSpan(
                      text: item.postedBy,
                      style: const TextStyle(
                        color: Color(0xFF1A1C20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0,
                    color: _primaryBlue,
                  ),
                ),
                TextButton(
                  onPressed: () => _openDetails(context),
                  style: TextButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    if (item.id.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoreDetailsScreen(productId: item.id),
      ),
    );
  }
}
