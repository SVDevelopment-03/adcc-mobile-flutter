import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/challenges/view/widgets/my_challenge_card.dart';
import 'package:adcc/features/challenges/repositories/challenges_repository.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['Completed', 'Upcoming', 'Cancelled'];

  final ChallengesRepository _repository = ChallengesRepository();

  List<MyChallengeCardData> _completedChallenges = const [];
  List<MyChallengeCardData> _upcomingChallenges = const [];
  List<MyChallengeCardData> _cancelledChallenges = const [];

  bool _isLoading = false;

  List<MyChallengeCardData> get _visibleCards {
    if (_selectedTab == 0) return _completedChallenges;
    if (_selectedTab == 1) return _upcomingChallenges;
    if (_selectedTab == 2) return _cancelledChallenges;
    return _completedChallenges;
  }

  @override
  void initState() {
    super.initState();
    _loadChallengesForTab(_selectedTab);
  }

  Future<void> _loadChallengesForTab(int tabIndex) async {
    setState(() => _isLoading = true);
    String? status;
    if (tabIndex == 0) status = 'completed';
    if (tabIndex == 1) status = 'upcoming';
    if (tabIndex == 2) status = 'cancelled';

    final list =
        await _repository.fetchChallenges(status: status, page: 1, limit: 50);

    final mapped = list.map((c) => _mapChallengeToCard(c)).toList();

    setState(() {
      if (tabIndex == 0) _completedChallenges = mapped;
      if (tabIndex == 1) _upcomingChallenges = mapped;
      if (tabIndex == 2) _cancelledChallenges = mapped;
      _isLoading = false;
    });
  }

  MyChallengeCardData _mapChallengeToCard(ChallengeModel c) {
    final progressLabel = '${c.progress} / ${c.target} ${c.unit}'.trim();
    final progressVal = c.target > 0 ? (c.progress / c.target) : 0.0;
    final imagePath =
        c.image.startsWith('http') ? 'assets/images/no-img.jpg' : c.image;

    return MyChallengeCardData(
      status: c.status,
      title: c.title,
      description: c.description,
      progressLabel: progressLabel,
      progress: progressVal.clamp(0.0, 1.0),
      rewardPoints: c.points,
      daysLeft: c.daysLeft,
      participants: c.participants,
      imagePath: imagePath,
    );
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
          child: Column(
            children: [
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Color(0x59C12D32),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.deepRed,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'My challenges',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 28 / 22,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _TopTabs(
                tabs: _tabs,
                selectedTab: _selectedTab,
                onTabTap: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                  _loadChallengesForTab(index);
                },
              ),
              const SizedBox(height: 14),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _visibleCards.isEmpty
                        ? const Center(
                            child: Text(
                              'No challenges yet',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0x80000000),
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemBuilder: (_, index) {
                              return MyChallengeCard(
                                  data: _visibleCards[index]);
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 20),
                            itemCount: _visibleCards.length,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabTap,
  });

  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                child: SizedBox(
                  height: 28,
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedTab == index
                            ? AppColors.deepRed
                            : Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 3,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: selectedTab == 0
                  ? Alignment.centerLeft
                  : selectedTab == 1
                      ? Alignment.center
                      : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: (MediaQuery.sizeOf(context).width - 32) / 3,
                height: 3,
                color: AppColors.deepRed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
