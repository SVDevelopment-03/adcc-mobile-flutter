import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BikeQuestionCard extends StatefulWidget {
  const BikeQuestionCard({super.key});

  @override
  State<BikeQuestionCard> createState() => _BikeQuestionCardState();
}

class _BikeQuestionCardState extends State<BikeQuestionCard> {
  bool hasBike = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 358,
        height: 73,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF5818B8),
                  borderRadius: BorderRadius.circular(8.1481),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/have_bike.png",
                    width: 22,
                    height: 22,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// Text
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.doYouHaveBike,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101828),
                  ),
                ),
              ),

              /// Toggle Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    hasBike = !hasBike;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE7E4DB),
                      width: 2,
                    ),
                  ),
                  child: hasBike
                      ? Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE7E4DB),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
