import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:flutter/material.dart';
import 'ride_card.dart';

class HorizontalRideList extends StatelessWidget {
  final List<HomeCommunityModel> communities;
  final void Function(String communityId)? onCommunityTap;
  final bool showFallback;

  const HorizontalRideList({
    super.key,
    this.communities = const [],
    this.onCommunityTap,
    this.showFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Popular Communities",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1, // 100% line height
                letterSpacing: 0,
                color: AppColors.textDark,
              ),
            )),
        const SizedBox(height: 22),
        if (communities.isEmpty)
          const SizedBox.shrink()
        else if (communities.isNotEmpty)
          SizedBox(
            height: 363,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return RideCard(
                  image: community.image,
                  title: community.title,
                  members: '${community.members} Members',
                  buttonText: 'Explore Community',
                  onTap: () => onCommunityTap?.call(community.id),
                );
              },
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
