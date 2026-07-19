import 'package:adcc/shared/widgets/store_item_card.dart';
import 'package:flutter/material.dart';

class CommunityStoreSection extends StatelessWidget {
  const CommunityStoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Community Store',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All ›'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Items
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                StoreItemCard(
                  imagePath: 'assets/images/bike.png',
                  title: 'Trek Domane',
                  postedBy: 'Mahmoud shadlan',
                  price: '7500 AED',
                ),
                SizedBox(width: 12),
                StoreItemCard(
                  imagePath: 'assets/images/bike.png',
                  title: 'Trek Domane',
                  postedBy: 'Mahmoud shadlan',
                  price: '7500 AED',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
