import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CommunityListCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback? onTap;

  const CommunityListCard({
    super.key,
    required this.community,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 358,
      height: 286,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11.5872),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              image: const DecorationImage(
                image: CachedNetworkImageProvider(CommunitiesImgs.communitySubcardBackground),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(11.5872),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // width: 358,
                  height: 178.6592,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.4581),
                        child: AdaptiveImage(
                          imagePath:
                              community.imageUrl ?? "assets/images/no-img.jpg",
                          width:double.infinity,
                          height: 178.6592,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 13,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(
                              height: 24,
                              constraints: const BoxConstraints(minWidth: 60),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1C20)
                                    .withValues(alpha: 0.33),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _categoryLabel(community),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                  letterSpacing: 0,
                                  color: Color(0xFFC9EFEA),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: 0,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          community.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.16,
                            letterSpacing: 0,
                            color: AppColors.textDark.withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/person_sharp.png",
                              width: 13,
                              height: 13,
                              color: AppColors.charcoal.withValues(alpha: 0.70),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${_formatCount(community.membersCount ?? 0)} members',
                              style: const TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.42,
                                letterSpacing: 0,
                                color: Color(0xFF484A4D),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Image.asset(
                              "assets/icons/calender.png",
                              width: 13,
                              height: 13,
                              color: AppColors.charcoal.withValues(alpha: 0.70),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${community.eventsCount ?? 0} events',
                              style: const TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.42,
                                letterSpacing: 0,
                                color: Color(0xFF484A4D),
                              ),
                            ),
                            const Spacer(),
                            _AvatarStack(
                              countText:
                                  _formatCount(community.membersCount ?? 0),
                              avatarImageUrls: _avatarUrls(community),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> _avatarUrls(CommunityModel community) {
  final urls = <String>[];
  final logo = community.logo?.trim();
  final image = community.imageUrl?.trim();

  if (logo?.isNotEmpty == true) {
    urls.add(logo!);
  }
  if (image?.isNotEmpty == true && image != logo) {
    urls.add(image!);
  }

  return urls;
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

String _categoryLabel(CommunityModel community) {
  final text = [
    community.type,
    community.title,
    ...community.category,
  ].join(' ').toLowerCase();

  if (text.contains('women') || text.contains('she')) return 'Women';
  if (text.contains('youth')) return 'Youth';
  if (text.contains('endurance') || text.contains('desert')) {
    return 'Endurance';
  }
  if (text.contains('social') || text.contains('family')) {
    return 'Family / Social';
  }
  if (text.contains('weekend')) return 'Social';
  if (text.contains('racing') ||
      text.contains('race') ||
      text.contains('performance')) {
    return 'Racing';
  }

  if (community.category.isNotEmpty) return community.category.first;
  if (community.type.isNotEmpty) return community.type;
  return 'Racing';
}

class _AvatarStack extends StatelessWidget {
  final String countText;
  final List<String> avatarImageUrls;

  const _AvatarStack({
    required this.countText,
    this.avatarImageUrls = const [],
  });

  @override
  Widget build(BuildContext context) {
    final avatars = avatarImageUrls.take(3).toList();
    return Row(
      children: [
        SizedBox(
          width: 55,
          height: 25,
          child: Stack(
            children: List.generate(
              avatars.length,
              (index) => _AvatarCircle(
                left: index * 14.0,
                imagePath: avatars[index],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          countText,
          style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.42,
            letterSpacing: 0,
            color: Color(0XFF484A4D),
          ),
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final double left;
  final String imagePath;

  const _AvatarCircle({
    required this.left,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: SizedBox(
        height: 25,
        width: 25,
        child: ClipOval(
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}
