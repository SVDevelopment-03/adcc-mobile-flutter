import 'package:adcc/l10n/app_localizations.dart';
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
                  color: Color.fromRGBO(82, 98, 239, 0.36),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF1B1A6E),
                ),
              ),
            ),
          ),

          /// CENTER TITLE
          Center(
            child: Text(
              AppLocalizations.of(context)!.backToEvent,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
