import 'package:flutter/material.dart';

class RouteTitleSection extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onShare;

  const RouteTitleSection({
    super.key,
    required this.title,
    required this.status,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusChip(text: status),

          const SizedBox(height: 10),

          // Title + share
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Color( 0xFFE9FFF3),
                    borderRadius: BorderRadius.circular(34652788),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/icons/share_2.png", // apna image path
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                      color: Color(0xFF27B96A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;

  const _StatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFBE9FFF3),
          borderRadius: BorderRadius.circular(7.52),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 5.64, 7, 5.36),
          child: Center(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1,
                color: Color(0xFF267D4E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
