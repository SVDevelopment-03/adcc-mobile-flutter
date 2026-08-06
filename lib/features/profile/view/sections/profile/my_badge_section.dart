import 'package:flutter/material.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';

class MyBadgesSection extends StatefulWidget {
  final VoidCallback? onViewAll;

  const MyBadgesSection({super.key, this.onViewAll});

  @override
  State<MyBadgesSection> createState() => _MyBadgesSectionState();
}

class _MyBadgesSectionState extends State<MyBadgesSection> {
  late final Future<List<ProfileBadgeItem>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _badgesFuture = ProfileRepository().fetchUserBadges();
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Locked';
    final d = date.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 29, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSectionHeader(
            title: 'My Badges',
            onViewAll: widget.onViewAll,
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 123,
            child: FutureBuilder<List<ProfileBadgeItem>>(
              future: _badgesFuture,
              builder: (context, snapshot) {
                final badges = snapshot.data ?? const <ProfileBadgeItem>[];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)));
                }
                if (badges.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No badges yet',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  );
                }

                final preview = badges.take(8).toList();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24, right: 16),
                  child: Row(
                    children: List.generate(preview.length, (index) {
                      final badge = preview[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            right: index == preview.length - 1 ? 0 : 20),
                        child: _BadgeItem(
                          title: badge.name,
                          subtitle: _dateLabel(badge.earnedAt),
                          earned: badge.earned,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _ProfileSectionHeader({
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 25 / 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF333333),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool earned;

  const _BadgeItem({
    required this.title,
    required this.subtitle,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: earned ? 1 : 0.45,
        child: SizedBox(
          width: 94,
          child: Column(
            children: [
              Container(
                width: 59.31,
                height: 59.31,
                decoration: BoxDecoration(
                  color: earned
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFE3E3E3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  earned ? Icons.emoji_events_outlined : Icons.lock_outline,
                  color: earned
                      ? const Color(0xFF435974)
                      : const Color(0xFF8B8B8B),
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 18 / 14,
                  letterSpacing: 0.14,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6E6E6E),
                ),
              ),
            ],
          ),
        ));
  }
}
