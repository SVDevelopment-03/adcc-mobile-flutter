import 'dart:convert';
import 'dart:typed_data';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SpecialRideCard extends StatelessWidget {
  static const double _cardHeight = 329;

  final String imagePath;
  final String title;
  final String date;
  final String? time;
  final String? distance;
  final String? location;
  final String? venue;
  final String? riders;
  final String? eventType;
  final String? groupName;
  final String? city;
  final String? eventId;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final VoidCallback? onOpen;
  final double width;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color shareBackgroundColor;
  final Color shareIconColor;

  const SpecialRideCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    this.time,
    this.distance,
    this.location,
    this.venue,
    this.riders,
    this.eventType,
    this.groupName,
    this.city,
    this.eventId,
    this.onShare,
    this.onTap,
    this.onOpen,
    this.width = 358,
    this.badgeColor = const Color(0xFFE7E4DB),
    this.badgeTextColor = Colors.black,
    this.shareBackgroundColor = const Color(0XFF7F318C),
    this.shareIconColor = Colors.white,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  bool get _isBase64Image => imagePath.startsWith('data:image/');

  Uint8List _base64Decode(String dataUri) {
    final base64String =
        dataUri.contains(',') ? dataUri.split(',')[1] : dataUri;
    return base64Decode(base64String);
  }

  Widget _buildImage() {
    if (_isBase64Image) {
      try {
        return Image.memory(
          _base64Decode(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (_) {
        return _imageFallback();
      }
    }

    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _imageFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.error_outline, size: 48, color: Colors.grey),
    );
  }

  void _openDetails(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

    final id = eventId ?? '';
    if (id.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: id),
      ),
    );
  }

  Widget _chip(String text, {double? maxWidth}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF381D8C),
              Color(0xFF7F318C),
            ],
          ),
          borderRadius: BorderRadius.circular(4.97),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 9.94,
            fontWeight: FontWeight.w400,
            height: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _metaItem({
    required Widget icon,
    required String text,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 13, height: 13, child: FittedBox(child: icon)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12.82,
                fontWeight: FontWeight.w400,
                height: 1.3,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeText = (eventType ?? 'Race').trim();
    final cityText = (city ?? location ?? 'Abu Dhabi').trim();
    final rawDistance = (distance ?? '42').trim();
    final distanceText = rawDistance.toLowerCase().contains('km')
        ? rawDistance
        : '$rawDistance km';
    final groupText = groupName?.trim();

    return GestureDetector(
      onTap: () => _openDetails(context),
      child: SizedBox(
        width: width,
        height: _cardHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(),
              Positioned(
                left: 15,
                top: 14,
                child: IntrinsicWidth(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width - 80),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        typeText.isEmpty ? 'Race' : typeText,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.05,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 15,
                top: 17,
                child: InkWell(
                  onTap: onShare,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: shareBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.share,
                      size: 15,
                      color: shareIconColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                bottom: 17,
                child: Container(
                  height: 148,
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      image: CachedNetworkImageProvider(
                        EventsImgs.EventCardDetailBackground,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: onOpen,
                            child: _chip('Open', maxWidth: 66),
                          ),
                          if (groupText != null && groupText.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _chip(groupText, maxWidth: 180),
                          ],
                        ],
                      ),
                      const SizedBox(height: 11),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          _metaItem(
                            icon: Image.asset('assets/icons/calender.png'),
                            text: date,
                            flex: 5,
                          ),
                          const SizedBox(width: 12),
                          _metaItem(
                            icon: const Icon(Icons.access_time_filled),
                            text: time ?? '5:30 AM',
                            flex: 4,
                          ),
                          const SizedBox(width: 12),
                          _metaItem(
                            icon: Image.asset('assets/icons/km_fill.png'),
                            text: distanceText,
                            flex: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          _metaItem(
                            icon: const Icon(Icons.location_on),
                            text: cityText.isEmpty ? 'Abu Dhabi' : cityText,
                            flex: 5,
                          ),
                          const SizedBox(width: 12),
                          _metaItem(
                            icon: Image.asset('assets/icons/routes_icons.png'),
                            text: venue ?? 'Yas Marina Circuit',
                            flex: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
