import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';
class CommunityHeader extends StatefulWidget {
  final String imagePath;
  final String title;
  final bool wantSearchBar;

  final String? searchValue;
  final ValueChanged<String>? onChangeHandler;
  final String? placeholder;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CommunityHeader({
    super.key,
    required this.imagePath,
    required this.title,
    this.wantSearchBar = true,
    this.searchValue,
    this.onChangeHandler,
    this.placeholder,
    this.showBackButton = true,
    this.onBackTap,
  });

  @override
  State<CommunityHeader> createState() => _CommunityHeaderState();
}

class _CommunityHeaderState extends State<CommunityHeader> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CommunityHeader oldWidget) {
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
      if (kDebugMode) debugPrint('[UI] CommunityHeader onBackTap provided, calling it');
      widget.onBackTap!();
      return;
    }
    if (kDebugMode) debugPrint('[UI] CommunityHeader default back - maybePop');
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 358,
      height: 306,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            /// Image
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.softCream,
                ),
              ),
            ),

            /// Gradient
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
                left: 14,
                top: 14,
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
                          size: 20,
                          color: AppColors.deepRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            /// Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                 Text(
  widget.title,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1,
    letterSpacing: 0,
  ),
),

                  if (widget.wantSearchBar) ...[
                    const SizedBox(height: 14),
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      height: 38,
      padding: const EdgeInsets.fromLTRB(14, 7, 15, 7),
      decoration: BoxDecoration(
        color: const Color(0x36FFFFFF), // #FFFFFF 21%
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// Search Icon Container
          Container(
            width: 23.5,
            height: 23.5,
            decoration: BoxDecoration(
              color: const Color(0x408C8C8C), // #8C8C8C40
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.search,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 11),

          /// Text Field
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onChangeHandler,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
               hintText: widget.placeholder ??
    AppLocalizations.of(context)!.search_track_name_hint,
hintStyle: const TextStyle(
  fontFamily: "Outfit",
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1,
  letterSpacing: -0.1,
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
