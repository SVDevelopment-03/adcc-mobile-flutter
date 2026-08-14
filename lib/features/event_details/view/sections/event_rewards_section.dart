import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/core/theme/app_colors.dart';

class EventRewardSection extends StatelessWidget {
  final List<EventRewardItem> rewards;

  const EventRewardSection({
    super.key,
    required this.rewards,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            AppLocalizations.of(context)!.rewardsAndBadges,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          /// Rewards Row
          Row(
            children: rewards.map((r) {
              return Padding(
                padding: const EdgeInsets.only(right: 28),
                child: _RewardItemCard(item: r),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class EventRewardItem {
  final String iconPath;
  final String label;

  const EventRewardItem({
    required this.iconPath,
    required this.label,
  });
}

class _RewardItemCard extends StatelessWidget {
  final EventRewardItem item;

  const _RewardItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Circle icon
        Container(
          height: 62,
          width: 62,
          decoration: const BoxDecoration(
            color: Color(0xFFCECBED),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: _buildIconWidget(item.iconPath),
          ),
        ),

        const SizedBox(height: 10),

        /// Label
        SizedBox(
          width: 80,
          child: Text(
            item.label,
            maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconWidget(String iconPath) {
    final trimmedValue = iconPath.trim();
    if (trimmedValue.isEmpty) {
      return const Icon(
        Icons.emoji_events_outlined,
        size: 26,
        color: Colors.white,
      );
    }

    if (trimmedValue.startsWith('http')) {
      return Image.network(
        trimmedValue,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.emoji_events_outlined,
            size: 26,
            color: Colors.white,
          );
        },
      );
    }

    if (trimmedValue.contains('/') || trimmedValue.contains('.')) {
      return Image.asset(
        trimmedValue,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.emoji_events_outlined,
            size: 26,
            color: Colors.white,
          );
        },
      );
    }

    return Text(
      trimmedValue,
      style: const TextStyle(
        fontSize: 28,
        height: 1,
      ),
    );
  }
}
