// import 'package:flutter/material.dart';

// class ShareAchievementsButton extends StatelessWidget {
//   const ShareAchievementsButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2),
//       child: SizedBox(
//         width: double.infinity,
//         height: 51,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFC12D32),
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: () {},
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/icons/share_2.png',
//                 width: 20,
//                 height: 20,
//                 fit: BoxFit.contain,
//                 color: Colors.white,
//               ),
//               const SizedBox(width: 7.2443),
//               Text(
//                 "Share My Achievements",
//                 style: const TextStyle(
//                   fontFamily: 'Outfit',
//                   fontSize: 14.5157,
//                   fontWeight: FontWeight.w400,
//                   height: 21.7735 / 14.5157, // ≈1.5
//                   letterSpacing: 0,
//                   color: Colors.white,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ShareAchievementsButton extends StatelessWidget {
  const ShareAchievementsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5257B5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          ShareHelper.share(
            context,
            ShareHelper.achievements(AppLocalizations.of(context)!),
            subject: AppLocalizations.of(context)!.check_out_my_achievements,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/share_2.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: Colors.white,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),

            //TODO: Add the text "Share My Achievements" next to the icon
            // const SizedBox(width: 8),
            // const Text(
            //   "Share My Achievements Coming soon!",
            //   style: TextStyle(
            //     fontFamily: 'Outfit',
            //     fontSize: 15,
            //     fontWeight: FontWeight.w500,
            //     height: 1.5,
            //     letterSpacing: 0,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
