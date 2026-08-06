import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/view/explore_community_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CommunitiesAwareness extends StatefulWidget {
  final List<CommunityModel> communities;

  const CommunitiesAwareness({
    super.key,
    required this.communities,
  });

  @override
  State<CommunitiesAwareness> createState() => _CommunitiesAwarenessState();
}

class _CommunitiesAwarenessState extends State<CommunitiesAwareness> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.communities.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 335,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _buildCommunityCard(
            community: widget.communities[index],
          );
        },
      ),
    );
  }

  Widget _buildCommunityCard({
    required CommunityModel community,
  }) {
    final categoryName =
        community.category.isNotEmpty ? community.category.first : 'Community';

    final membersCount = community.membersCount ?? 0;
    final eventsCount = community.eventsCount ?? 0;
    const double cardRadius = 12;
    final formattedMembers = _formatNumber(membersCount);
    final formattedEvents = _formatNumber(eventsCount);

    return Container(
      width: 212,
      height: 335,
      decoration: BoxDecoration(
        color: const Color(0xffFFEFD7),
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
                  child: AdaptiveImage(
                    imagePath: community.imageUrl ?? 'assets/images/no-img.jpg',
                    height: 158,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15,
                        sigmaY: 15,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 11,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.33),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          categoryName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0,
                            color: Color(0xFFFFF4E3),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    community.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 7),

                  /// MEMBERS + EVENTS
                  Row(
                    children: [
                      /// MEMBERS
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/person_sharp.png",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedMembers members',
                            style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.42,
                              letterSpacing: 0,
                              color: Color(0xFF484A4D),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      /// EVENTS
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/calender.png",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedEvents events',
                            style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.42,
                              letterSpacing: 0,
                              color: Color(0xFF484A4D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// DESCRIPTION
                  Text(
                    community.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0,
                      color: Color(0xFF484A4D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// BUTTON
                  AppButton(
                    label: "Explore",
                    textStyle: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.softCream,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ExploreCommunityScreen(community: community),
                        ),
                      );
                    },
                    height: 30,
                    width: 93,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final thousands = number / 1000;
      if (thousands % 1 == 0) {
        return '${thousands.toInt()}K';
      }
      return '${thousands.toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
