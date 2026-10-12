import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Design icons, in tab order: Home, Events, Communities, Tracks, Profile.
  // Four of the supplied SVGs only wrap a bitmap, which flutter_svg cannot
  // tint, so their bitmaps are used directly; Communities is a true vector.
  static const List<String> _icons = [
    'assets/svg/menu/menu-home.png',
    'assets/svg/menu/menu-calendar.png',
    'assets/svg/menu/menu-community.svg',
    'assets/svg/menu/menu-track.png',
    'assets/svg/menu/menu-profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3B7791), Color(0xFF339FCF)],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              for (int i = 0; i < _icons.length; i++) _navItem(_icons[i], i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(String iconPath, int index) {
    final bool isSelected = currentIndex == index;
    final Color color =
        isSelected ? Colors.white : Colors.white.withValues(alpha: 0.55);
    const double size = 26;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconPath.endsWith('.svg')
                ? SvgPicture.asset(
                    iconPath,
                    width: size,
                    height: size,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  )
                : Image.asset(
                    iconPath,
                    width: size,
                    height: size,
                    color: color,
                    colorBlendMode: BlendMode.srcIn,
                    filterQuality: FilterQuality.medium,
                  ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 14 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
