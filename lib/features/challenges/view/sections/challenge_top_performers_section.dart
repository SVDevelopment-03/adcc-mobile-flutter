import 'package:flutter/material.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:adcc/shared/widgets/app_button.dart';

class ChallengeTopPerformersSection extends StatelessWidget {
  final List<Map<String, dynamic>> performers;
  final VoidCallback onViewAll;
  final VoidCallback? onJoin;
  final VoidCallback? onMarkComplete;

  const ChallengeTopPerformersSection({
    super.key,
    required this.performers,
    required this.onViewAll,
    this.onJoin,
    this.onMarkComplete,
  });

  String _extractValue(String valueString) {
    final parts = valueString.split(' ');
    return parts.isNotEmpty ? parts[0] : valueString;
  }

  String _extractUnit(String valueString) {
    final parts = valueString.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  Widget _buildPerformerRow(
      Map<String, dynamic> performer, bool isLast) {
    return Column(
      children: [
        SizedBox(
          height: 85,
          child: Row(
            children: [
              /// AVATAR + BADGE
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/cycle.png",
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  /// TROPHY BADGE
                  Positioned(
                    top: -3.98,
                    left: 27.98,
                    child: Container(
                      width: 23.99,
                      height: 23.99,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFD4AF37),
                            Color(0xFFB8941E),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/trophy.png",
                          width: 13,
                          height: 13,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              /// NAME + RANK
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
  performer['name'],
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),
const SizedBox(height: 4),
Text(
  "Rank #${performer['rank']}",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
                  ],
                ),
              ),

              /// VALUE
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 Text(
  _extractValue(performer['value']),
  textAlign: TextAlign.right,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),
const SizedBox(height: 4),
Text(
  _extractUnit(performer['value']),
  textAlign: TextAlign.right,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
                ],
              ),
            ],
          ),
        ),

        if (!isLast)
          const Divider(
            color: Colors.white,
            height: 1,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          SectionHeader(
            title: 'Top Performers',
            onViewAll: onViewAll,
            showViewAll: true,
          ),

          const SizedBox(height: 23),

          /// PERFORMERS CARD
          Container(
            width: 358,
            height: 260,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD4AF37),
                  Color(0xFFB8941E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.4),
              border: Border.all(
                color: Colors.white,
                width: 1.1659,
              ),
            ),
            child: Column(
              children: performers.asMap().entries.map((entry) {
                final index = entry.key;
                final performer = entry.value;
                final isLast = index == performers.length - 1;

                return _buildPerformerRow(performer, isLast);
              }).toList(),
            ),
          ),

          if (onJoin != null || onMarkComplete != null) ...[
            const SizedBox(height: 40),

            /// JOIN BUTTON
            if (onJoin != null)
              AppButton(
  label: "Join Challenge",
  onPressed: onJoin!,
  type: AppButtonType.primary,
  backgroundColor: AppColors.deepRed,
  textColor: Colors.white,
  width: double.infinity,
  height: 50,
  borderRadius: 12,
  textStyle: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 17.46,
    fontWeight: FontWeight.w400,
    height: 1.5, // 26.13px line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),

            const SizedBox(height: 25),

            /// MARK COMPLETE
          AppButton(
  label: "Mark as complete",
  onPressed: onMarkComplete ?? () {},
  type: AppButtonType.secondary,
  borderColor: AppColors.deepRed,
  textColor: AppColors.deepRed,
  backgroundColor: Colors.transparent,
  width: double.infinity,
  height: 50,
  borderRadius: 12,
  textStyle: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5, // 24px line height
    letterSpacing: 0,
    color: AppColors.deepRed,
  ),
),

            const SizedBox(height: 25),
          ],
        ],
      ),
    );
  }
}