import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/cosmatic_imgs.dart';

class CancelRegistrationScreen extends StatefulWidget {
  final String eventId;

  const CancelRegistrationScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<CancelRegistrationScreen> createState() =>
      _CancelRegistrationScreenState();
}

class _CancelRegistrationScreenState extends State<CancelRegistrationScreen> {
  int selectedIndex = -1;
  bool isLoading = false;

  final EventsService _eventsService = EventsService();

  final List<String> reasons = const [
    "Schedule conflict",
    "Health reasons",
    "Not prepared",
    "Weather concerns",
  ];

  Future<void> _confirmCancellation() async {
    /// validation
    if (selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a reason"),
        ),
      );
      return;
    }

    if (isLoading) return;

    final reason = reasons[selectedIndex];

    setState(() => isLoading = true);

    final result = await _eventsService.cancelEvent(
      eventId: widget.eventId,
      reason: reason,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result.success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? "Cancel failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(EventsImgs.eventBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              /// background image
              Positioned(
                left: -52,
                top: 259,
                child: Image.asset(
                  "assets/images/frame_1.png",
                  width: 160,
                  fit: BoxFit.contain,
                  color: Color(0XFF1B1A6E),
                ),
              ),

              /// main content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                child: Column(
                  children: [
                    /// back button
                    Row(
                      children: [
                        _BackCircleButton(
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop(false);
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// icon
                    Center(
                      child: Image.asset(
                        "assets/icons/checkmark.gif",
                        height: 102,
                        width: 102,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Cancel Registration",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Text(
                      "Please let us know why you're\ncancelling",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal.withValues(alpha: 0.55),
                      ),
                    ),

                    const SizedBox(height: 37),

                    _ReasonBox(
                      selectedIndex: selectedIndex,
                      reasons: reasons,
                      onSelect: (i) => setState(() => selectedIndex = i),
                    ),

                    const Spacer(),

                    /// confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _confirmCancellation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF1B1A6E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          isLoading ? "Please wait..." : "Confirm Cancellation",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
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

class _BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lightDeepRed.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          height: 34,
          width: 34,
          child: Icon(
            Icons.arrow_back,
            size: 18,
            color: AppColors.deepRed,
          ),
        ),
      ),
    );
  }
}

class _ReasonBox extends StatelessWidget {
  final int selectedIndex;
  final List<String> reasons;
  final ValueChanged<int> onSelect;

  const _ReasonBox({
    required this.selectedIndex,
    required this.reasons,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: CachedNetworkImageProvider(
              EventsImgs.EventCancelBackground,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ReasonChip(
                  text: reasons[0],
                  isSelected: selectedIndex == 0,
                  onTap: () => onSelect(0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReasonChip(
                  text: reasons[1],
                  isSelected: selectedIndex == 1,
                  onTap: () => onSelect(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReasonChip(
                  text: reasons[2],
                  isSelected: selectedIndex == 2,
                  onTap: () => onSelect(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReasonChip(
                  text: reasons[3],
                  isSelected: selectedIndex == 3,
                  onTap: () => onSelect(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? const Color(0xFFD9DFFA) : Colors.white;
    final border = isSelected ? AppColors.goldenOchre : AppColors.lightBeige;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 1),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: AppColors.charcoal,
            ),
          ),
        ),
      ),
    );
  }
}
