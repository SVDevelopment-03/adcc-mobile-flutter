import 'package:flutter/material.dart';

class RideCard extends StatelessWidget {
  final String image;
  final String title;
  final String members;
  final String buttonText;
  final VoidCallback onTap;

  const RideCard({
    super.key,
    required this.image,
    required this.title,
    required this.members,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      height: 373,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0DDAF),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: image.startsWith('http')
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/family_ride.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    image,
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
                    Color(0x00000000),
                    Color(0xCC000000),
                  ],
                  stops: [0.45, 1],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 92,
            child: Text(
              title.replaceAll('\n', ' '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 71,
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/person_sharp.png",
                  width: 18,
                  height: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  members,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 22,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF435974),
                  borderRadius: BorderRadius.circular(9.1),
                ),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
