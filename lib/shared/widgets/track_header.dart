import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';
class TrackHeader extends StatefulWidget {
  final String imagePath;
  final String title;
  final String? subtitle;

  final bool wantSearchBar;
  final String? searchValue;
  final ValueChanged<String>? onChangeHandler;
  final String? placeholder;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  const TrackHeader({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.wantSearchBar = false,
    this.searchValue,
    this.onChangeHandler,
    this.placeholder,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  State<TrackHeader> createState() => _TrackHeaderState();
}

class _TrackHeaderState extends State<TrackHeader> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(covariant TrackHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchValue != oldWidget.searchValue) {
      _searchController.text = widget.searchValue ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (widget.onBackTap != null) {
      widget.onBackTap!();
      return;
    }
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
        borderRadius: BorderRadius.circular(12), //  radius 12
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(color: AppColors.softCream);
                },
              ),
            ),

            // Gradient Overlay
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

            // Back Button
            if (widget.showBackButton)
              Positioned(
                top: 14,
                left: 14,
                child: SafeArea(
                  bottom: false,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _handleBack,
                      child: const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  if (widget.wantSearchBar) ...[
                    const SizedBox(height: 14),
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      width: 311,
      height: 38,
      padding: const EdgeInsets.fromLTRB(14, 7, 15, 7.5),
      decoration: BoxDecoration(
        color: const Color(0x36FFFFFF), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        
          Container(
            width: 23.5,
            height: 23.5,
            padding: const EdgeInsets.fromLTRB(
              5.4231,
              5.0615,
              5.0615,
              4.2179,
            ),
            decoration: BoxDecoration(
              color: const Color(0x408C8C8C), 
              borderRadius: BorderRadius.circular(36.1539),
            ),
            child: const Icon(
              Icons.search,
              size: 12,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onChangeHandler,
              cursorColor: Colors.white,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -0.1,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: widget.placeholder ??
                    "Search tracks, city, distance or terrain...",
                hintStyle: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: -0.1,
                  color: Colors.white,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
