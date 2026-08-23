import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/repositories/communities_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MyCommunitiesSection extends StatefulWidget {
  final VoidCallback? onViewAll;

  const MyCommunitiesSection({super.key, this.onViewAll});

  @override
  State<MyCommunitiesSection> createState() => _MyCommunitiesSectionState();
}

class _MyCommunitiesSectionState extends State<MyCommunitiesSection>
    with WidgetsBindingObserver {
  late CommunitiesRepository _communitiesRepository;
  late Future<List<CommunityModel>> _communitiesFuture;
  String? _currentLocaleCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _communitiesRepository = CommunitiesRepository(
      apiClient: ApiClient.instance,
    );
    _communitiesFuture = _communitiesRepository.getMyJoinedCommunities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_currentLocaleCode == null) {
      _currentLocaleCode = localeCode;
      return;
    }

    if (_currentLocaleCode != localeCode) {
      _currentLocaleCode = localeCode;
      // Locale changed — clear lookup cache and refresh communities
      try {
        LookupService.instance.clearCache();
      } catch (_) {}
      _refreshCommunities();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _refreshCommunities();
    }
  }

  void _refreshCommunities() {
    setState(() {
      _communitiesFuture = _communitiesRepository.getMyJoinedCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSectionHeader(
            title: AppLocalizations.of(context)!.myCommunitiesTitle,
            onViewAll: widget.onViewAll,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<CommunityModel>>(
            future: _communitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 363,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 363,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.failed_to_load_communities,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final communities = snapshot.data ?? [];

              if (communities.isEmpty) {
                return SizedBox(
                  height: 363,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.noJoinedCommunitiesYet,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 363,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: communities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _CommunityCard(community: communities[index]);
                  },
                ),
              );
            },
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.view_all_label,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
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

class _CommunityCard extends StatelessWidget {
  final CommunityModel community;

  const _CommunityCard({required this.community});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 260,
        height: 363,
        child: Stack(
          children: [
            Positioned.fill(
              child: community.imageUrl != null
                  ? Image.network(
                      community.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color.fromARGB(255, 135, 126, 169),
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      color: const Color.fromARGB(255, 135, 126, 169),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.80),
                    ],
                    stops: const [0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 94,
              child: Text(
                  community.displayTitle(Localizations.localeOf(context).languageCode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 23 / 18,
                    color: Colors.white,
                  ),
                ),
            ),
            Positioned(
              left: 16,
              bottom: 72,
              child: Row(
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${community.membersCount ?? 0} ${AppLocalizations.of(context)!.membersLabel}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 16 / 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5257B5),
                  borderRadius: BorderRadius.circular(9.12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.exploreCommunityButton,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                    color: Colors.white,
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
