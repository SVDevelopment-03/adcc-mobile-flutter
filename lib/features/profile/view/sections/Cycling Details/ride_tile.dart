import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RideTile extends StatelessWidget {
  final String title;
  final String distance;
  final String riders;
  final String date;
  final String imagePath;
  final VoidCallback? onNavigate;

  const RideTile({
    super.key,
    required this.title,
    required this.distance,
    required this.riders,
    required this.date,
    required this.imagePath,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Container(
        width: double.infinity,
        height: 134,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            /// IMAGE
            Padding(
              padding: const EdgeInsets.all(9),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        width: 105,
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/no-img.jpg',
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        width: 105,
                        height: 105,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            /// RIGHT SIDE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// DISTANCE + RIDERS
                    Row(
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        /// DISTANCE IMAGE
                        Image.asset(
                          "assets/icons/km_rides.jpg",
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0,
                            color: AppColors.charcoal,
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// RIDERS IMAGE
                        Image.asset(
                          "assets/icons/rides.jpg",
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 4),

                        Text(
                          riders,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.16,
                            letterSpacing: 0,
                            color: AppColors.charcoal,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),

                    /// BUTTON + DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        SizedBox(
                          // width: 137,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: onNavigate,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color(0xFF5257B5),
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                elevation: MaterialStateProperty.all(0),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(
                                    10,
                                    2,
                                    10,
                                    2,
                                  ),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.navigate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  // height: 1.5,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              )),
                        ),

                        /// DATE
                        Text(
                          date,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: 0,
                            color: AppColors.charcoal,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
