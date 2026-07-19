import 'package:flutter/material.dart';

class CompletedRidesCard extends StatelessWidget {
  final int rides;
  final VoidCallback? onTap;

  const CompletedRidesCard({
    super.key,
    required this.rides,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.fromLTRB(
            16,
            15,
            25,
            16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFffff),
            borderRadius: BorderRadius.circular(7.4843),
            // border: Border.all(
            //   width: 1.5424,
            //   // color: const Color(0xFFCF9F0),
            // ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// TEXT
              Text(
                "Completed Rides: $rides",
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 17.4634,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0,
                  color: Color(0xFF000000),
                ),
              ),

              /// ICON
              const Icon(
                Icons.directions_bike,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
