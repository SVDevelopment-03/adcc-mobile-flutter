import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ChallengeHeader extends StatefulWidget {
  final String imagePath;
  final String title;

  final bool wantSearchBar;
  final String? searchValue;
  final ValueChanged<String>? onChangeHandler;
  final String? placeholder;

  const ChallengeHeader({
    super.key,
    required this.imagePath,
    required this.title,
    this.wantSearchBar = false,
    this.searchValue,
    this.onChangeHandler,
    this.placeholder,
  });

  @override
  State<ChallengeHeader> createState() => _ChallengeHeaderState();
}

class _ChallengeHeaderState extends State<ChallengeHeader> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(covariant ChallengeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchValue != widget.searchValue) {
      _controller.text = widget.searchValue ?? '';
    }
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 358,
      height: 242,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [

            /// BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),

           
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),

            /// BACK BUTTON (FIGMA SIZE)
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: _handleBack,
                child: Container(
                  width: 35,
                  height: 35,
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    10,
                    7.5,
                    9.5,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: AppColors.deepRed,
                  ),
                ),
              ),
            ),

            /// CONTENT
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                children: [

                  /// TITLE
                 Text(
  widget.title,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Colors.white,
  ),
),

                  const SizedBox(height: 14),

                  /// SEARCH BAR
                  if (widget.wantSearchBar)
                  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      width: 311,
      height: 38,
      padding: const EdgeInsets.fromLTRB(
        14,
        7,
        16,
        7.5,
      ),
      decoration: BoxDecoration(
        color: const Color(0x36FFFFFF), // #FFFFFF21
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// SEARCH ICON CONTAINER
          Container(
            width: 23.5,
            height: 23.5,
            decoration: BoxDecoration(
              color: const Color(0x408C8C8C), // #8C8C8C40
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Icon(
              Icons.search,
              size: 12,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 11),

          /// TEXT FIELD
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChangeHandler,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
               hintText: widget.placeholder ?? "Search events...",
hintStyle: const TextStyle(
  fontFamily: "Outfit",
  fontSize: 13,
  fontWeight: FontWeight.w400,
  height: 1.0, // 100% line height
  letterSpacing: -0.1,
  color: Colors.white,
),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}