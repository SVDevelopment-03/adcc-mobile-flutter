import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
class StoreProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onTap;

  const StoreProductGrid({
    super.key,
    required this.products,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 172 / 252,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return _StoreProductCard(
          product: product,
          onTap: () => onTap(product),
        );
      },
    );
  }
}

class _StoreProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _StoreProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 172,
        height: 252,
        decoration: BoxDecoration(
          color: Color(0xFFFFF9EF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (product['image'] as String).startsWith('http')
                      ? Image.network(
                          product['image'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/no-img.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          product['image'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),

                /// LOCATION BADGE
              Positioned(
  top: 12,
  left: 7,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(22.5),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 7.5,
        sigmaY: 7.5,
      ),
      child: Container(
        height: 21,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(22.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/location.png",
              height: 12,
              width: 12,
              color: Colors.white,
            ),
            const SizedBox(width: 3),
           Text(
  product['location'],
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 9.75,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
          ],
        ),
      ),
    ),
  ),
)
              ],
            ),

            const SizedBox(height: 8),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
  product['title'],
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
  ),
),
            ),

            const SizedBox(height: 4),

            /// PRICE + TIME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                 Text(
  product['price'],
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
    color: Color(0xFFC12D32),
  ),
),
                  const SizedBox(width: 6),
                Text(
  "• ${product['timePosted']}",
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.1,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.5),
  ),
),
                ],
              ),
            ),

            const SizedBox(height: 4),

            /// POSTED BY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:Text(
  "Posted by ${product['postedBy']}",
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.5),
  ),
),
            ),
          ],
        ),
      ),
    );
  }
}