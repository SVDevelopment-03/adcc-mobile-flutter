import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class CommunityHighlightTrackCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String iconPath;
  final Color backgroundColor;

  const CommunityHighlightTrackCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.iconPath,
    this.backgroundColor = const Color(0xFFD6F6FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 312,
      height: 252.74,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11.5872),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(11.5872),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.4581),
                  child: AdaptiveImage(
                    imagePath: imagePath,
                    width: 312,
                    height: 178.6592,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 15.69, // 15.6872 ≈ 15.69
                          fontWeight: FontWeight.w600,
                          height: 1, // 100% line height
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 7.7248),
                      Row(
                        children: [
                          Image.asset(
                            iconPath,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.42, // 17.0968 / 12 ≈ 1.42
                                letterSpacing: 0,
                                color: Color(0xFF484A4D),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
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
