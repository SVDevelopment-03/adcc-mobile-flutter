import 'dart:ui';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/challenges/view/challenge_details_screen.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import 'package:adcc/features/challenges/repositories/challenges_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';
  final ChallengesRepository _repository = ChallengesRepository();
  bool _isLoading = true;
  bool _isLoadingLeaderboard = true;
  List<ChallengeModel> _challenges = const [];
  List<Map<String, String>> _topRiders = const [];

  @override
  void initState() {
    super.initState();
    _loadChallenges();
    _loadLeaderboard();
  }

  Future<void> _loadChallenges() async {
    setState(() => _isLoading = true);
    final list = await _repository.fetchChallenges();
    if (!mounted) return;
    setState(() {
      _challenges = list;
      _isLoading = false;
    });
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoadingLeaderboard = true);
    final riders = await _repository.fetchLeaderboard(limit: 10);
    if (!mounted) return;
    setState(() {
      _topRiders = riders;
      _isLoadingLeaderboard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              ChallengeImges.challengeBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _ChallengesTopBlock(
                selectedTab: _selectedTab,
                searchValue: _searchQuery,
                onSearchChanged: (value) =>
                    setState(() => _searchQuery = value),
                onTabChanged: (index) => setState(() => _selectedTab = index),
                heroChallenge:
                    _challenges.isNotEmpty ? _challenges.first : null,
              ),
              if (_selectedTab == 0) ...[
                const SizedBox(height: 27),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.challenge_active_challenges,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                ),
                const SizedBox(height: 19),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  _ActiveChallengesCarousel(
                    challenges: _challenges.where((c) {
                      if (_searchQuery.trim().isEmpty) {
                        return c.status == 'active';
                      }
                      final q = _searchQuery.trim().toLowerCase();
                      return (c.title.toLowerCase() +
                                  ' ' +
                                  c.description.toLowerCase())
                              .contains(q) &&
                          c.status == 'active';
                    }).toList(),
                  ),
                const SizedBox(height: 50),
                if (!_isLoading)
                  _RecentChallengesList(
                    recentChallenges: () {
                      final recent = _challenges
                          .where((c) => c.status != 'active')
                          .toList();
                      if (recent.isNotEmpty) return recent;
                      return _challenges.take(3).toList();
                    }(),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(height: 50),
                const _ProgressConnectCard(),
                const SizedBox(height: 34),
              ] else ...[
                const SizedBox(height: 34),
                _LeaderboardContent(
                  searchQuery: _searchQuery,
                  isLoading: _isLoadingLeaderboard,
                  riders: _topRiders,
                ),
                const SizedBox(height: 34),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengesTopBlock extends StatelessWidget {
  const _ChallengesTopBlock({
    required this.selectedTab,
    required this.searchValue,
    required this.onSearchChanged,
    required this.onTabChanged,
    this.heroChallenge,
  });

  final int selectedTab;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onTabChanged;
  final ChallengeModel? heroChallenge;

  @override
  Widget build(BuildContext context) {
    // if (selectedTab == 1) {
    //   return _LeaderboardTopBlock(
    //     selectedTab: selectedTab,
    //     searchValue: searchValue,
    //     onSearchChanged: onSearchChanged,
    //     onTabChanged: onTabChanged,
    //     heroChallenge: heroChallenge,
    //   );
    // }

    return SizedBox(
      height: 330,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 285,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      ChallengeImges.challengeheaderbackground),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 16,
            top: 67,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 147,
            left: 0,
            right: 0,
            child: Text(
              AppLocalizations.of(context)!.challenge_active_challenges,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 197,
            child: _ChallengeSearchField(
              value: searchValue,
              onChanged: onSearchChanged,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 254,
            child: _ChallengeTabsCard(
              selectedTab: selectedTab,
              onTabChanged: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardHeroCard extends StatelessWidget {
  const _LeaderboardHeroCard({this.hero});

  final ChallengeModel? hero;

  @override
  Widget build(BuildContext context) {
    final image = hero?.image ?? 'assets/images/Rectangle22.png';
    final title = hero?.title ?? AppLocalizations.of(context)!.challenge_active_challenges;

    return Container(
      height: 250,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image.startsWith('http')
              ? Image.network(image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/Rectangle22.png',
                      fit: BoxFit.cover))
              : Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xE6000000),
                ],
                stops: [0.2725, 1],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 74,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.27,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeSearchField extends StatefulWidget {
  const _ChallengeSearchField({
    required this.value,
    required this.onChanged,
    this.hintText = '',
    this.sigma = 5,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;
  final double sigma;

  @override
  State<_ChallengeSearchField> createState() => _ChallengeSearchFieldState();
}

class _ChallengeSearchFieldState extends State<_ChallengeSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _ChallengeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.sigma, sigmaY: widget.sigma),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.21),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 23.5,
                height: 23.5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(Icons.search, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: -0.1,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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

class _ChallengeTabsCard extends StatelessWidget {
  const _ChallengeTabsCard({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF094AAD);

    return Container(
      height: 94,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 25),
      decoration: BoxDecoration(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabLabel(
                  title: AppLocalizations.of(context)!.challenge_active_challenges,
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged(0),
                ),
              ),
              Expanded(
                child: _TabLabel(
                  title: AppLocalizations.of(context)!.challenge_leaderboard,
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: selectedTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineChallengeTabs extends StatelessWidget {
  const _InlineChallengeTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabLabel(
                  title: AppLocalizations.of(context)!.challenge_active_challenges,
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged(0),
                ),
              ),
              Expanded(
                child: _TabLabel(
                  title: AppLocalizations.of(context)!.challenge_leaderboard,
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9DAF4),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: selectedTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Color(0xFF094AAD),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.25,
          color: isSelected
              ? const Color(0xFF094AAD)
              : Colors.black.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _ActiveChallengesCarousel extends StatelessWidget {
  const _ActiveChallengesCarousel({required this.challenges});

  final List<ChallengeModel> challenges;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return SizedBox(
        height: 140,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.challenge_no_active_challenges,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5565),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 435,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        physics: const BouncingScrollPhysics(),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                final id = challenges[index].id;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChallengeDetailsScreen(
                      challengeId: id,
                    ),
                  ),
                );
              },
              child: _ActiveChallengeCard(data: challenges[index]),
            ),
          );
        },
      ),
    );
  }
}

class _ActiveChallengeCard extends StatelessWidget {
  const _ActiveChallengeCard({required this.data});

  final ChallengeModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 435,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFFC9DAF4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: data.image.startsWith('http')
                ? Image.network(
                    data.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/no-img.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    data.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/no-img.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Positioned(
            left: 15,
            right: 16,
            bottom: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 1,
                        color: const Color(0xFFC9DAF4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _ChallengeMeta(
                            icon: Icons.schedule_rounded,
                            text: AppLocalizations.of(context)!
                                .challenge_days_left(data.daysLeft),
                          ),
                          const SizedBox(width: 13),
                          _ChallengeMeta(
                            icon: Icons.groups_rounded,
                            text: '${data.participants}',
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeMeta extends StatelessWidget {
  const _ChallengeMeta({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 15.5),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14.1,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RecentChallengesList extends StatelessWidget {
  const _RecentChallengesList({required this.recentChallenges});

  final List<ChallengeModel> recentChallenges;

  @override
  Widget build(BuildContext context) {
    if (recentChallenges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(AppLocalizations.of(context)!.challenge_no_recent_challenges),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.challenge_recent_challenges,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(height: 20),
          for (final recent in recentChallenges) ...[
            _RecentChallengeTile(challenge: recent),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RecentChallengeTile extends StatelessWidget {
  const _RecentChallengeTile({required this.challenge});

  final ChallengeModel challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC9DAF4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 63.6,
            height: 63.6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    ChallengeImges.challengeIconBackground),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Center(
              child: challenge.image.startsWith('http')
                  ? Image.network(
                      challenge.image,
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.directions_bike_rounded,
                        color: Color(0xFF1A1C20),
                        size: 30,
                      ),
                    )
                  : Image.asset(
                      'assets/images/ride.png',
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.directions_bike_rounded,
                        color: Color(0xFF1A1C20),
                        size: 30,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  challenge.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.28,
                    color: Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressConnectCard extends StatelessWidget {
  const _ProgressConnectCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // TODO: Handle banner tap
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 155,
            width: double.infinity,
            child: Image.network(
              ChallengeImges.challengeProgressConnectBackground,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF094AAD),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.challenge_connect_devices,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  const _LeaderboardContent({
    required this.searchQuery,
    required this.riders,
    required this.isLoading,
  });

  final String searchQuery;
  final bool isLoading;
  final List<Map<String, String>> riders;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? riders
        : riders.where((rider) {
            final name = (rider['name'] ?? '').toLowerCase();
            final team = (rider['team'] ?? '').toLowerCase();
            return name.contains(query) || team.contains(query);
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.challenge_top_riders_this_month,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.challenge_no_riders_found,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5565),
                  ),
                ),
              ),
            )
          else
            for (final rider in filtered) ...[
              _RiderRow(data: rider),
              const SizedBox(height: 12),
            ],
          const SizedBox(height: 16),
          const _DecemberStatsCard(),
        ],
      ),
    );
  }
}

class _RiderRow extends StatelessWidget {
  const _RiderRow({required this.data});

  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFC9DAF4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFF094AAD),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data['team'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xCC333333),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            data['time'] ?? '',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1C20),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecemberStatsCard extends StatefulWidget {
  const _DecemberStatsCard();

  @override
  State<_DecemberStatsCard> createState() => _DecemberStatsCardState();
}

class _DecemberStatsCardState extends State<_DecemberStatsCard> {
  bool _loading = true;
  int _totalKm = 0;
  int _rides = 0;
  int _rankChange = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final resp = await ApiClient.instance
          .get<dynamic>(ApiEndpoints.authMeMonthlyStats);
      final statsMap = ResponseParser.extractMap(resp.data, const ['data']) ??
          <String, dynamic>{};

      setState(() {
        _totalKm = ResponseParser.asInt(
            statsMap['totalDistanceKm'] ?? statsMap['totalDistance'] ?? 0);
        _rides = ResponseParser.asInt(
            statsMap['totalRides'] ?? statsMap['rides'] ?? 0);
        _rankChange = ResponseParser.asInt(
            statsMap['rankChange'] ?? statsMap['rank_change'] ?? 0);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> _months = [
      l10n.month_january,
      l10n.month_february,
      l10n.month_march,
      l10n.month_april,
      l10n.month_may,
      l10n.month_june,
      l10n.month_july,
      l10n.month_august,
      l10n.month_september,
      l10n.month_october,
      l10n.month_november,
      l10n.month_december,
    ];
    final monthName = _months[DateTime.now().month - 1];
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 165),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF91A7CA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.track_changes,
                        size: 22, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!
                          .challenge_your_month_stats(monthName),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _StatBox(
                            label: AppLocalizations.of(context)!.challenge_total_km,
                            value: '$_totalKm')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: AppLocalizations.of(context)!.challenge_rides,
                            value: '$_rides')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: AppLocalizations.of(context)!.challenge_rank_change,
                            value: '$_rankChange')),
                  ],
                ),
              ],
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC9DAF4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Removed static challenge data — leaderboard now reads from API top performers.
