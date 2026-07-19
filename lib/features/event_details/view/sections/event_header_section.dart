import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
class EventHeader extends StatefulWidget {
  final String imagePath;
  final String title;
  final String? subtitle;

  final bool wantSearchBar;
  final String? searchValue;
  final ValueChanged<String>? onChangeHandler;
  final String? placeholder;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  const EventHeader({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.wantSearchBar = false,
    this.searchValue,
    this.onChangeHandler,
    this.placeholder,
    this.showBackButton = true,
    this.onBackTap,
  });

  @override
  State<EventHeader> createState() => _EventHeaderState();
}

class _EventHeaderState extends State<EventHeader> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(covariant EventHeader oldWidget) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 306,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [

              /// Background Image
              Positioned.fill(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(color: AppColors.softCream);
                  },
                ),
              ),

              /// Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),

              /// Back Button
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

              /// Bottom Content
              Positioned(
                left: 24,
                right: 24,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    /// Title
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),

                    /// Subtitle
                    if (widget.subtitle != null &&
                        widget.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],

                    /// Search Bar
                    if (widget.wantSearchBar) ...[
                      const SizedBox(height: 14),

                    ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      width: 311,
      height: 38,
      padding: const EdgeInsets.fromLTRB(14, 7, 60, 7.5),
      decoration: BoxDecoration(
        color: const Color(0x36FFFFFF), // #FFFFFF21
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// Search Icon Container
          Container(
            height: 23.5,
            width: 23.5,
            decoration: BoxDecoration(
              color: const Color(0x408C8C8C), // #8C8C8C40
              borderRadius: BorderRadius.circular(36.15),
            ),
            child: const Icon(
              Icons.search,
              size: 12,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 11),

          /// TextField
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onChangeHandler,
              cursorColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.1,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder ??
                    "Search events, communities, cities, or tracks...",
                hintStyle: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
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