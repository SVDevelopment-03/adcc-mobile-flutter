import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/store_item_model.dart';
import '../../repositories/store_repository.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String productId;

  const StoreDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  bool _isLoading = true;
  int _currentImageIndex = 0;
  Map<String, dynamic>? _productData;
  final StoreRepository _storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    final item = await _storeRepository.fetchItemById(widget.productId);

    if (item != null) {
      setState(() {
        _productData = _toScreenMap(item);
        _isLoading = false;
      });
      return;
    }
    // No item found — leave _productData null so UI shows the "Go Back" page.
    setState(() {
      _productData = null;
      _isLoading = false;
    });
  }

  Map<String, dynamic> _toScreenMap(StoreItemModel item) {
    return {
      'id': item.id,
      'image': item.image,
      'gallery': item.gallery,
      'title': item.title,
      'location': item.location,
      'timePosted': item.timePosted,
      'currentPrice': item.price,
      'originalPrice': null,
      'sellerName': item.postedBy,
      if (item.phoneNumber != null) 'phoneNumber': item.phoneNumber,
      if (item.details.isNotEmpty) 'productDetails': item.details,
      'description': item.description,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_productData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.common_go_back),
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                MarketplaceImges.marketplaceBackground,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 31, 16, 0),
                      height: 414,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildGallery(),
                    ),
                    Positioned(
                      left: 31,
                      top: 49,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFFD44838),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _productData!['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 25 / 20,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _productData!['location'] as String,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(_productData!['timePosted'] as String?),
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCurrencyPrice(
                            _productData!['currentPrice'] as String,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 25 / 18,
                              color: Color(0xFFD44838),
                            ),
                          ),
                          if (_productData!['originalPrice'] != null)
                            buildCurrencyPrice(
                              _productData!['originalPrice'] as String,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 18 / 14,
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFF1A1C20).withOpacity(0.8),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      if (_productData!.containsKey('isNegotiable') &&
                          _productData!['isNegotiable'] == true)
                        _chip(AppLocalizations.of(context)!.negotiable, width: 91),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                _sellerCard(),
                const SizedBox(height: 30),
                _sectionTitle(AppLocalizations.of(context)!.descriptionLabel, fontSize: 18),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _productData!['description'] as String,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 18 / 14,
                      color: const Color(0xFF1A1C20).withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _sectionTitle(AppLocalizations.of(context)!.product_details, fontSize: 20),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ((_productData!['productDetails'] ?? []) as List)
                        .map((e) => _detailChip(e.toString()))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 30),
                _safetyCard(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () async {
                            final phone =
                                _productData!['phoneNumber'] as String?;
                            if (phone == null || phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(AppLocalizations.of(context)!.sellerPhoneNotAvailable)),
                              );
                              return;
                            }

                            // Open WhatsApp Web / App
                            final cleaned =
                                phone.replaceAll(RegExp(r'[^0-9+]'), '');
                            final numForWa = cleaned.replaceFirst('+', '');
                            final uri = Uri.parse('https://wa.me/$numForWa');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!.cannotOpenWhatsApp)),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFD44838),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.whatsappSeller,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: OutlinedButton(
                          onPressed: () async {
                            final phone =
                                _productData!['phoneNumber'] as String?;
                            if (phone == null || phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(AppLocalizations.of(context)!.sellerPhoneNotAvailable)),
                              );
                              return;
                            }
                            final tel = Uri(scheme: 'tel', path: phone);
                            if (await canLaunchUrl(tel)) {
                              await launchUrl(tel);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!.cannotMakeCall)),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD44838),
                            side: const BorderSide(color: Color(0xFFD44838)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.call,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery() {
    final gallery = (_productData!['gallery'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .where((path) => path.isNotEmpty)
            .toList() ??
        [];

    if (gallery.isEmpty) {
      return _productImage(_productData!['image'] as String);
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: gallery.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _productImage(gallery[index]);
          },
        ),
        if (gallery.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                gallery.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImageIndex == index ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _productImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: double.infinity,
        height: 414,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }

    return Image.asset(
      image,
      width: double.infinity,
      height: 414,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/store_header_banner.png',
      width: double.infinity,
      height: 414,
      fit: BoxFit.cover,
    );
  }

  Widget _chip(String text, {required double width}) {
    return Container(
      width: width,
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1A1C20)),
        borderRadius: BorderRadius.circular(17.2674),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 15 / 12,
          color: Color(0xFF1A1C20),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: const Color(0xFF1A1C20),
        ),
      ),
    );
  }

  Widget _sellerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFFFfffff),
        borderRadius: BorderRadius.circular(16.4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 21),
          CircleAvatar(
            radius: 25,
            backgroundImage: _productData!.containsKey('sellerImage')
                ? AssetImage(_productData!['sellerImage'] as String)
                : null,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _productData!['sellerName'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 23 / 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _productData!['location'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.listings_count(_productData!['listingCount'] ?? 0),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 24,
            margin: const EdgeInsets.only(right: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: _productData!.containsKey('rating')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 13,
                        color: Color(0xFFFFC300),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_productData!['rating']}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _detailChip(String text) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 15 / 12,
          color: Color(0xFF1A1C20),
        ),
      ),
    );
  }

  Widget _safetyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // height: 81,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(16.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user,
            size: 24,
            color: Colors.black,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.safety_tips,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                    color: Color(0xFF1A1C20),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.meet_in_public_tip,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 15 / 12,
                    color: const Color(0xFF1A1C20).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      final l10n = AppLocalizations.of(context)!;

      if (difference.inMinutes < 1) {
        return l10n.just_now;
      } else if (difference.inHours < 1) {
        return l10n.minutes_ago(difference.inMinutes);
      } else if (difference.inDays < 1) {
        return l10n.hours_ago(difference.inHours);
      } else if (difference.inDays < 7) {
        return l10n.days_ago(difference.inDays);
      } else {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      }
    } catch (e) {
      return dateTimeString;
    }
  }
}
