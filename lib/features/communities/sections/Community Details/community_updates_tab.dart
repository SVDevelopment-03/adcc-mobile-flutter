import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/notifications/models/notification_item_model.dart';
import 'package:adcc/features/notifications/repositories/notifications_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityUpdatesTab extends StatefulWidget {
  final String? communityId;

  const CommunityUpdatesTab({super.key, this.communityId});

  @override
  State<CommunityUpdatesTab> createState() => _CommunityUpdatesTabState();
}

class _CommunityUpdatesTabState extends State<CommunityUpdatesTab> {
  late final NotificationsRepository _repository;
  late Future<List<NotificationItemModel>> _future;

  @override
  void initState() {
    super.initState();
    _repository = NotificationsRepository();
    _future = _loadNotifications();
  }

  Future<List<NotificationItemModel>> _loadNotifications() async {
    final communityId = widget.communityId?.trim() ?? '';
    if (communityId.isEmpty) return const [];

    final notifications = await _repository.fetchInbox();
    return notifications.where((item) {
      final type = item.type?.trim().toLowerCase();
      if (type != 'community') return false;

      final rawCommunityId = (item.data ?? const {})['communityId'];
      final value = rawCommunityId == null ? null : rawCommunityId.toString();
      return value == communityId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationItemModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data ?? const <NotificationItemModel>[];

        if (items.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Text(AppLocalizations.of(context)!.community_no_updates),
            ),
          );
        }

        return SizedBox(
          height: 300,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final dateLabel = item.createdAt != null
                  ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}'
                  : 'Community';

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.deepRed,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.title.isNotEmpty ? item.title : 'Community update',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.body,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: AppColors.textDark,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dateLabel,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
