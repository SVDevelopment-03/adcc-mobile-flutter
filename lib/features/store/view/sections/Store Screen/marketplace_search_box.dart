import 'package:flutter/material.dart';

class MarketplaceSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MarketplaceSearchBox({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 359,
      height: 45,
      padding: const EdgeInsets.fromLTRB(
        11.9863,
        12,
        100,
        12.0165,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0x1A111827),
          width: 1.1659,
        ),
      ),
      child: Row(
        children: [

          /// Search Icon
          Image.asset(
            "assets/icons/search.png",
            height: 19.9835,
            width: 19.9835,
            color: const Color(0xFF6B7280),
          ),

          const SizedBox(width: 8),

          /// TextField
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
decoration: const InputDecoration(
  hintText: "Search marketplace...",
  hintStyle: TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: Color(0x80111827), // 50% opacity
  ),
  border: InputBorder.none,
  isCollapsed: true,
),
            ),
          ),
        ],
      ),
    );
  }
}