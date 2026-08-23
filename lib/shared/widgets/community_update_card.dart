import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/utils/date_utils.dart';

class CommunityUpdateCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String locationTime;
  final String postImage;
  final int likes;
  final int commentsCount;
  final bool likedByMe;
  final String caption;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTap;

  const CommunityUpdateCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.locationTime,
    required this.postImage,
    required this.likes,
    this.commentsCount = 0,
    this.likedByMe = false,
    required this.caption,
    this.onLikeTap,
    this.onCommentTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4A017),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: AdaptiveImage(
                    imagePath: profileImage,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      () {
                        final raw = locationTime.trim();
                        if (raw.isEmpty) return raw;
                        // Preserve any leading location part before a separator like '•'
                        if (raw.contains('•')) {
                          final parts = raw.split('•');
                          final prefix = parts.sublist(0, parts.length - 1).join(' • ').trim();
                          final last = parts.last.trim();
                          final formatted = formatIsoDateForDisplay(last);
                          return prefix.isEmpty ? formatted : '$prefix • $formatted';
                        }
                        // If it's likely an ISO date, format it; otherwise strip time portion if present
                        if (raw.contains('T')) return formatIsoDateForDisplay(raw);
                        return raw;
                      }(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                        letterSpacing: 0,
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AdaptiveImage(
              imagePath: postImage,
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                onPressed: onLikeTap,
                icon: Icon(
                  likedByMe ? Icons.favorite : Icons.favorite_border,
                  size: 26,
                  color: likedByMe ? const Color(0xFFD53030) : const Color(0xFF4B4B4B),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                onPressed: onCommentTap,
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  size: 26,
                  color: Color(0xFF4B4B4B),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$commentsCount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.send_outlined,
                size: 26,
                color: Color(0xFF4B4B4B),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0,
                color: AppColors.textDark,
              ),
              children: [
                TextSpan(
                  text: '$name ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: caption,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }}