import 'package:adcc/features/challenges/view/sections/Challenge%20Screen/challenge_header.dart';
import 'package:adcc/features/challenges/viewmodels/challenges_view_model.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/category_selector.dart';
import 'sections/Challenge Screen/active_challenges_section.dart';
import 'sections/recent_challenges_section.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int selectedFilterIndex = 0;
  String searchQuery = '';
  final ChallengesViewModel _viewModel = ChallengesViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    // Load active challenges by default (uses API status filter)
    _viewModel.loadChallenges(status: 'active');
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _viewModel.byStatus('active');
    final upcoming = _viewModel.byStatus('upcoming');
    final completed = _viewModel.byStatus('completed');

    final filterTabs = [
      'Active (${active.length})',
      'Upcoming (${upcoming.length})',
      'Completed (${completed.length})',
    ];

    final selectedList = selectedFilterIndex == 0
        ? active
        : selectedFilterIndex == 1
            ? upcoming
            : completed;
    final visibleChallenges = _viewModel.searchIn(selectedList, searchQuery);

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Back Button

              const SizedBox(height: 8),

              // Main Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // ChallengeHeader(
                    //   imagePath: 'assets/images/no-img.jpg',
                    //   title: 'Challenges',
                    //   wantSearchBar: true,
                    //   searchValue: searchQuery,
                    //   placeholder: 'Search events...',
                    //   onChangeHandler: (value) {
                    //     setState(() {
                    //       searchQuery = value;
                    //     });
                    //   },
                    // ),

                    const SizedBox(height: 34),

                    // Filter Tabs
                    CategorySelector(
                      categories: filterTabs,
                      selectedIndex: selectedFilterIndex,
                      onSelected: (index) async {
                        setState(() {
                          selectedFilterIndex = index;
                        });

                        // Fetch filtered challenges from API using status
                        final status = index == 0
                            ? 'active'
                            : index == 1
                                ? 'upcoming'
                                : 'completed';

                        await _viewModel.loadChallenges(status: status);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Active Challenges Section (shown when Active tab is selected)
                    if (_viewModel.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      ActiveChallengesSection(challenges: visibleChallenges),
                      const SizedBox(height: 32),
                    ],

                    RecentChallengesSection(recent: completed),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
