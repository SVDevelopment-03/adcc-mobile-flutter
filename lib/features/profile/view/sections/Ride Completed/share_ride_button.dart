import 'package:adcc/core/utils/share_helper.dart';
import 'package:flutter/material.dart';

class ShareRideButton extends StatelessWidget {
  const ShareRideButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xffC12D32),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ShareHelper.share(
            context,
            ShareHelper.ride(),
            subject: 'I just completed a ride on ADCC',
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "assets/icons/share.png",
              width: 35,
              height: 35,
            ),

            const SizedBox(width: 8),

            const Text(
              "Share Your Ride",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

          ],
        ),
      ),
    );
  }
}