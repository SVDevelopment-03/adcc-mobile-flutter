import 'package:adcc/core/utils/share_helper.dart';
import 'package:adcc/l10n/app_localizations.dart';
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
            subject: AppLocalizations.of(context)!.i_just_completed_ride,
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
            Text(
              AppLocalizations.of(context)!.share_your_ride,
              style: const TextStyle(
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
