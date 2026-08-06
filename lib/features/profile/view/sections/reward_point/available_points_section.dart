import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvailablePointsSection extends StatefulWidget {
  const AvailablePointsSection({super.key});

  @override
  State<AvailablePointsSection> createState() => _AvailablePointsSectionState();
}

class _AvailablePointsSectionState extends State<AvailablePointsSection> {
  bool _loading = true;
  int _points = 0;
  int _toGold = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      final resp =
          await ApiClient.instance.get<dynamic>(ApiEndpoints.authMeStats);
      final statsMap =
          ResponseParser.extractMap(resp.data, const ['stats', 'data']) ??
              ResponseParser.extractMap(resp.data, const ['data']) ??
              <String, dynamic>{};

      final points = ResponseParser.asInt(
          statsMap['totalPoints'] ?? statsMap['points'] ?? 0);
      final goldThreshold = ResponseParser.asInt(
          statsMap['goldThreshold'] ?? statsMap['nextTierThreshold'] ?? 2000);
      final toGold = (goldThreshold - points).clamp(0, goldThreshold);
      final progress =
          goldThreshold > 0 ? (points / goldThreshold).clamp(0.0, 1.0) : 0.0;

      if (mounted)
        setState(() {
          _points = points;
          _toGold = toGold;
          _progress = progress;
          _loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 2),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  ProfileImgs.profileAvailablePointsBackground),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/icons/achive.png",
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                  color: Colors.black87,
                ),
                const SizedBox(width: 6),
                const Text(
                  "Available Points",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 1.56,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                _loading ? '...' : _points.toString(),
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13.0946,
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progress to Gold Tier",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _loading ? '...' : '$_toGold pts to go',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 11.21,
              decoration: BoxDecoration(
                color: const Color(0xFFC2C2C2),
                borderRadius: BorderRadius.circular(37041432),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(37041432),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
