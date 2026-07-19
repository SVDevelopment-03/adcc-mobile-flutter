import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class JoinEventHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const JoinEventHeader({
    super.key,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, 
      child: Stack(
        alignment: Alignment.center,
        children: [

         
          Positioned(
            left: 2,
            child: GestureDetector(
              onTap: onBackTap,
              child: Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0x5CC12D32),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 20, 
                  color: AppColors.deepRed, 
                ),
              ),
            ),
          ),

          /// CENTER TITLE
          const Center(
            child: Text(
              "Back to Event",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Outfit",
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}