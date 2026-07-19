import 'package:adcc/features/challenges/models/challenge_model.dart';
import 'package:adcc/features/challenges/repositories/challenges_repository.dart';
import 'package:adcc/features/profile/view/sections/my_challenges/challenge_card.dart';
import 'package:flutter/material.dart';


class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ChallengesRepository _challengesRepository = ChallengesRepository();

  bool _isLoading = true;
  String? _errorMessage;
  List<ChallengeModel> _challenges = const [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadChallenges();
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose();
  }

  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final challenges = await _challengesRepository.fetchChallenges();
      if (!mounted) return;
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<ChallengeModel> _filterByTab(int index) {
    final status = switch (index) {
      0 => 'completed',
      1 => 'upcoming',
      _ => 'cancelled',
    };

    return _challenges
        .where((challenge) => challenge.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF3FF),
        elevation: 0,
        centerTitle: true,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 38,
              width: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFA8C4F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF4A5F7A),
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          'My challenges',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF4A5F7A),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: const Color(0xFF4A5F7A),
                  unselectedLabelColor: const Color(0xFF7A7A7A),
                  labelStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: 'Completed'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ChallengeList(challenges: _filterByTab(0)),
                      ChallengeList(challenges: _filterByTab(1)),
                      ChallengeList(challenges: _filterByTab(2)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class ChallengeList extends StatelessWidget {
  final List<ChallengeModel> challenges;

  const ChallengeList({super.key, required this.challenges});

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const Center(child: Text('No challenges found'));
    }

    return PageView.builder(
      controller: PageController(viewportFraction: 0.88),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ChallengeCard(
                title: challenge.title,
                description: challenge.description,
                image: challenge.image,
                status: challenge.status.toUpperCase(),
                progressText:
                    '${challenge.progress} / ${challenge.target} ${challenge.unit}',
                progress: challenge.target == 0
                    ? 0
                    : challenge.progress / challenge.target,
                daysLeft: '${challenge.daysLeft} days left',
                participants: '${challenge.participants}',
              ),
            ),
          ),
        );
      },
    );
  }
}