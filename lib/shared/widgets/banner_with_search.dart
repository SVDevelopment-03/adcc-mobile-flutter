import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BannerWithSearch extends StatefulWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final bool wantSearchBar;
  final String? searchValue;
  final ValueChanged<String>? onChangeHandler;
  final String? placeholder;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  const BannerWithSearch({
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
  State<BannerWithSearch> createState() => _BannerWithSearchState();
}

class _BannerWithSearchState extends State<BannerWithSearch> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(BannerWithSearch oldWidget) {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            widget.imagePath,
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 400,
                color: AppColors.softCream,
              );
            },
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
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Subtitle
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

                // Search Bar
                if (widget.wantSearchBar) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.23),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _searchController,
                      onChanged: widget.onChangeHandler,
                      decoration: InputDecoration(
                        hintText: widget.placeholder ?? 'Search...',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
