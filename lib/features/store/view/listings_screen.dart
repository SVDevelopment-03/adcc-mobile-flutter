import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/adaptive_image.dart';
import '../models/store_item_model.dart';
import '../repositories/store_repository.dart';
import 'sell_product_screen.dart';

class ListingsScreen extends StatefulWidget {
  final String? imagePath;

  const ListingsScreen({super.key, this.imagePath});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final StoreRepository _repo = StoreRepository();
  List<StoreItemModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    final list = await _repo.fetchMyItems();
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Widget _listingCard(BuildContext context, StoreItemModel item) {
    final location = item.location.trim();
    final seller = item.postedBy.trim().isNotEmpty
        ? item.postedBy.trim()
        : 'Unknown Seller';

    return SizedBox(
      width: 357,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: AdaptiveImage(
                      imagePath: item.image.isNotEmpty
                          ? item.image
                          : (widget.imagePath ?? 'assets/images/no-img.jpg'),
                      width: 357,
                      height: 210,
                      fit: BoxFit.cover,
                      placeholderColor: AppColors.charcoal.withOpacity(0.06),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.08),
                            Colors.transparent,
                            Colors.black.withOpacity(0.10),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _Badge(
                      icon: Icons.location_on_outlined,
                      label: location.isNotEmpty ? location : 'UAE',
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _Badge(
                      icon: Icons.sell_outlined,
                      label:
                          item.category.isNotEmpty ? item.category : 'Listing',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                              color: Color(0xFF1A1C20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.price,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF129995),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: const Color(0xFFECF7F7),
                          child: Text(
                            seller.isNotEmpty ? seller[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF129995),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Posted by $seller',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A1C20).withOpacity(0.62),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2 days ago',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1A1C20).withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _ActionChip(
                          label: 'Edit',
                          icon: Icons.edit_outlined,
                          foreground: const Color(0xFF129995),
                          background: const Color(0xFFE9F7F7),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SellProductScreen(initialItem: item),
                              ),
                            );
                            await _loadItems();
                          },
                        ),
                        _ActionChip(
                          label: 'Mark sold',
                          icon: Icons.local_mall_outlined,
                          foreground: const Color(0xFF1A1C20),
                          background: const Color(0xFFF6F7F9),
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Mark as sold'),
                                content: const Text('Mark this item as sold?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Yes')),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              final ok = await _repo.markItemSold(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(ok ? 'Marked sold' : 'Failed')),
                              );
                              await _loadItems();
                            }
                          },
                        ),
                        _ActionChip(
                          label: 'Delete',
                          icon: Icons.delete_outline,
                          foreground: const Color(0xFFE11D48),
                          background: const Color(0xFFFDECEF),
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete listing'),
                                content: const Text(
                                    'Are you sure you want to delete this listing?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              final ok = await _repo.archiveItem(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(ok ? 'Deleted' : 'Failed')),
                              );
                              await _loadItems();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 35,
        height: 35,
        padding: const EdgeInsets.only(
          top: 10,
          right: 7.5,
          bottom: 9.5,
          left: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff9cd9d6),
          borderRadius: BorderRadius.circular(53.8462),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 13,
          color: Color(0xFF129995),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(

            color: Color.fromARGB(255, 211, 250, 248)  ,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  MarketplaceImges.marketplaceBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Row(
                      children: [
                        _backButton(context),
                        const Spacer(),
                        const Text(
                          'My Listings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 28 / 22,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 35),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  TabBar(
                    indicatorColor: const Color(0xFF9cd9d6),
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.black.withOpacity(0.5),
                    dividerHeight: 3,
                    labelColor: const Color(0xFF9cd9d6),
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    labelStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 20 / 16,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 20 / 16,
                    ),
                    tabs: const [
                      Tab(text: 'Active listings'),
                      Tab(text: 'Sold items'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
                          child: _loading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 80),
                                  itemCount: _items.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) =>
                                      _listingCard(context, _items[index]),
                                ),
                        ),
                        Center(
                          child: Text(
                            'No sold items yet',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              color: AppColors.textDark.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
