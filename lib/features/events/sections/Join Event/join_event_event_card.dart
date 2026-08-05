import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:flutter/material.dart';

class JoinEventEventCard extends StatelessWidget {
  final Event? event;
  final bool isJoined;

  const JoinEventEventCard({
    super.key,
    this.event,
    this.isJoined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 357,
        height: 226,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1FB),
          borderRadius: BorderRadius.circular(20.6999),
          border: Border.all(
            color: const Color(0xFFffffff),
            width: 1.5083,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 27,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImage(),
              ),
            ),
            Positioned(
              left: 130,
              top: 31,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event?.title.trim().isNotEmpty == true
                        ? event!.title
                        : 'Test demo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event?.address?.trim().isNotEmpty == true
                        ? event!.address!
                        : (event?.city?.trim().isNotEmpty == true
                            ? event!.city!
                            : 'test demo'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              top: 138,
              child: _smallCard(
                iconPath: 'assets/icons/clock.png',
                title: 'When',
                value: _whenText,
              ),
            ),
            Positioned(
              left: 184,
              top: 138,
              child: _smallCard(
                iconPath: 'assets/icons/distance.png',
                title: 'Location',
                value: event?.city?.trim().isNotEmpty == true
                    ? event!.city!
                    : 'Abu Dhabi',
              ),
            ),
            if (isJoined)
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Joined',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166534),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = event?.mainImage?.trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return Image.network(
          imageUrl,
          width: 100.905,
          height: 87,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/no-img.jpg',
            width: 100.905,
            height: 87,
            fit: BoxFit.cover,
          ),
        );
      }

      return Image.asset(
        imageUrl,
        width: 100.905,
        height: 87,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/no-img.jpg',
          width: 100.905,
          height: 87,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      'assets/images/no-img.jpg',
      width: 100.905,
      height: 87,
      fit: BoxFit.cover,
    );
  }

  String get _whenText {
    final date = event?.formattedDate?.trim();
    final time = event?.formattedTime?.trim() ?? event?.eventTime?.trim();

    if (date != null && date.isNotEmpty && time != null && time.isNotEmpty) {
      return '$date • $time';
    }

    if (date != null && date.isNotEmpty) {
      return date;
    }

    return '18 July 2026';
  }

  Widget _smallCard({
    required String iconPath,
    required String title,
    required String value,
  }) {
    return Container(
      width: 157,
      constraints: const BoxConstraints(minHeight: 65),
      padding: const EdgeInsets.only(
        top: 10.0234,
        right: 5,
        bottom: 6.4766,
        left: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(13.2955),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 16,
            height: 16,
            color: AppColors.deepRed,
          ),
          const SizedBox(width: 8.8637),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
