import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JoinCommunityCard extends StatelessWidget {
  final VoidCallback onJoinTap;

  const JoinCommunityCard({super.key, required this.onJoinTap});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final imageUrl = isArabic
        ? 'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Frame-2147226359-1787479741874-972fef0ebf0e.png'
        : 'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Home-screen-footer-1785879791457-249a5505c431.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 160,
          width: double.infinity,
          child: InkWell(
            onTap: onJoinTap,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
