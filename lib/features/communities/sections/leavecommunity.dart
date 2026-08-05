// features/communities/sections/leave_community_screen.dart

import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class LeaveCommunity extends StatefulWidget {
  final CommunityModel community;

  const LeaveCommunity({
    super.key,
    required this.community,
  });

  @override
  State<LeaveCommunity> createState() => _LeaveCommunityState();
}

class _LeaveCommunityState extends State<LeaveCommunity> {
  final CommunitiesService _communitiesService = CommunitiesService();

  bool isLoading = false;
  int selectedReasonIndex = 3;
  final TextEditingController feedbackController = TextEditingController();

  late CommunityModel _community;

  final List<String> reasons = const [
    "Not Active Anymore",
    "Schedule Conflict",
    "Community Not Matching My Interest",
    "Found Another Community",
    "Temporary Break",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _community = widget.community;
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> _leaveCommunity() async {
    if (selectedReasonIndex == -1) {
      _showSnackBar(
        message: "Please select a reason for leaving",
        isError: true,
      );
      return;
    }

    setState(() => isLoading = true);

    final reason = reasons[selectedReasonIndex];
    final feedback = feedbackController.text.trim();

    final result = await _communitiesService.leaveCommunity(
      communityId: _community.id,
      reason: reason,
      feedback: feedback.isEmpty ? null : feedback,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result.success) {
      _showSnackBar(
        message: "You have left the community",
        isError: false,
      );

      Navigator.pop(context, true);
    } else {
      _showSnackBar(
        message: result.message ?? "Failed to leave community",
        isError: true,
      );
    }
  }

  void _showSnackBar({required String message, required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(92, 255, 114, 243),
                      borderRadius: BorderRadius.circular(53.8462),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 15,
                      color: Color(0XFFF96291),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Center(
                child: Image.asset(
                  "assets/icons/checkmark.gif",
                  height: 181,
                  width: 181,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Leave Community",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "We're sorry to see you go.\nYour feedback helps us improve.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.28,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Reason:",
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),

              const SizedBox(height: 12),

              /// REASONS LIST
              ...List.generate(reasons.length, (index) {
                final isSelected = selectedReasonIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ReasonTile(
                    title: reasons[index],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedReasonIndex = index;
                      });
                    },
                  ),
                );
              }),

              const SizedBox(height: 28),

              const Text(
                "Additional feedback",
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 14),

              /// FEEDBACK BOX
              Container(
                height: 103,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(9.94958),
                ),
                child: TextField(
                  controller: feedbackController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Tell Us More....",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              AppButton(
                label: isLoading ? "Leaving..." : "Back to Home",
                onPressed: isLoading ? null : _leaveCommunity,
                type: AppButtonType.primary,
                backgroundColor: const Color(0XFFF96291),
                textColor: Colors.white,
                borderRadius: 12,
                height: 51,
                textStyle: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFF) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(9.9),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0359E8) : const Color(0xFFFFFFFF),
            width: isSelected ? 1 : 0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD9D9D9)
                      : const Color(0xFFD9D9D9),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0359E8),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
