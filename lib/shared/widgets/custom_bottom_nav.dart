import 'package:adcc/core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.deepRed,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem("assets/icons/bottom_home.png", 0),
              _navItem("assets/icons/add_calendar.png", 1),
              _navItem("", 2, iconData: Icons.groups_rounded, iconSize: 31),
              _navItem("assets/svg/trackicon.png", 3, iconSize: 28),
              _navItem("assets/svg/bottom_pro.svg", 4, isSvg: true),
            ],
          ),
        ),
      ),
    );
  }
  Widget _navItem(
    String iconPath,
    int index, {
    bool isSvg = false,
    double iconSize = 25,
    IconData? iconData,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconData != null
              ? Icon(
                  iconData,
                  size: iconSize,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                )
              : isSvg
                  ? SvgPicture.asset(
                      iconPath,
                      height: iconSize,
                      width: iconSize,
                      colorFilter: ColorFilter.mode(
                        isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(
                      iconPath,
                      height: iconSize,
                      width: iconSize,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      colorBlendMode: BlendMode.srcIn,
                    ),

          const SizedBox(height: 6),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 12 : 0,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}
