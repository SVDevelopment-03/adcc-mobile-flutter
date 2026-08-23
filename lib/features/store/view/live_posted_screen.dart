import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/widgets/adaptive_image.dart';
import 'listings_screen.dart';

class LivePostedScreen extends StatelessWidget {
  final String? title;
  final String? price;
  final String? imagePath;

  const LivePostedScreen({
    super.key,
    this.title,
    this.price,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xffedfffe),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: -36,
                top: 273,
                child: Container(
                  width: 196,
                  height: 196,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9cd9d6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 21,
                top: 36,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    padding: const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
                    decoration: BoxDecoration(
                      color: Color(0xff9cd9d6),
                      borderRadius: BorderRadius.circular(53.8462),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 13,
                      color: Color(0xFFD44838),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 70,
                child: Image.asset(
                  'assets/icons/checkmark.gif',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 238,
                left: 0,
                right: 0,
                child: Text(
                  AppLocalizations.of(context)!.your_item_is_live,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    height: 38 / 30,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Positioned(
                top: 286,
                left: 0,
                right: 0,
                child: Text(
                  AppLocalizations.of(context)!.successfully_posted_listing,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 18 / 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Positioned(
                top: 342,
                left: 16,
                right: 17,
                child: _listingCard(context),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 116,
                child: SizedBox(
                  height: 51,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListingsScreen(imagePath: imagePath),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFFD44838),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.view_listing,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 53,
                child: SizedBox(
                  height: 51,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFD44838),
                      side: const BorderSide(
                        color: Color(0xFFD44838),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.post_another_item,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 24 / 16,
                        color: Color(0xFFD44838),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listingCard(BuildContext context) {
    return Container(
      width: 357,
      height: 135,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            MarketplaceImges.marketplaceLiveCardBackground,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20.6999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 95,
            height: 87,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            child: AdaptiveImage(
              imagePath: imagePath ?? 'assets/images/no-img.jpg',
              width: 100.5,
              height: 134,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? AppLocalizations.of(context)!.trek_domane,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 23 / 18,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6),
                buildCurrencyPrice(
                  price ?? '7500',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 19 / 15,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.posted_two_mins_ago,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 14 / 11,
                    color: const Color(0xFF1A1C20).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 17),
        ],
      ),
    );
  }
}
