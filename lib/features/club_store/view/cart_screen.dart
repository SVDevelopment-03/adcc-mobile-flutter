import 'package:flutter/material.dart';
import 'package:adcc/features/club_store/models/cart_item_model.dart';
import 'package:adcc/features/club_store/repositories/cart_repository.dart';
import 'package:adcc/features/club_store/view/checkout_screen.dart';
// store_theme.dart import removed; local `StoreTheme` defined below
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';

// Minimal StoreTheme fallback for this file (colors aligned with club store)
class StoreTheme {
  static const bg = Color(0xFFFFF8FA);
  static const appBar = Color(0xFFE04C71);
  static const primary = Color(0xFFE04C71);
  static const cardBg = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1A1C20);
  static const textGray = Color(0xFF7B8794);
  static const textSecondary = Color(0xFFA3A4A6);
  static const textMuted = Color(0xFF6B7A8D);
  static const iconMuted = Color(0xFF9AA5B4);
  static const disabled = Color(0xFFB0BEC5);
  static const softBg = Color(0xFFFFCAD7);
}

class ClubStoreCartScreen extends StatefulWidget {
  const ClubStoreCartScreen({super.key});

  @override
  State<ClubStoreCartScreen> createState() => _ClubStoreCartScreenState();
}

class _ClubStoreCartScreenState extends State<ClubStoreCartScreen> {
  final ClubStoreCartRepository _cartRepository =
      ClubStoreCartRepository.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await _cartRepository.loadCart();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                MarketplaceImges.marketplaceBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: StoreTheme.appBar,
              elevation: 0,
              title: Text(l10n.cart_title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ValueListenableBuilder<List<CartItemModel>>(
                    valueListenable: _cartRepository.items,
                    builder: (context, items, _) {
                      if (items.isEmpty) return _buildEmptyCart();

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return _CartItemCard(
                                  item: item,
                                  onRemove: () async {
                                    await _cartRepository.removeItem(item.id);
                                    _showMessage(l10n.removed_from_cart);
                                  },
                                  onQuantityChanged: (quantity) async {
                                    await _cartRepository.updateItemQuantity(item.id, quantity);
                                  },
                                );
                              },
                            ),
                          ),
                          _CartSummaryBar(
                            itemCount: items.length,
                            subtotal: _cartRepository.subtotal,
                            onCheckout: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ClubStoreCheckoutScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 80),
            const Icon(Icons.shopping_cart_outlined,
              size: 96, color: StoreTheme.textGray),
          const SizedBox(height: 24),
          Text(
            l10n.cart_empty_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C20),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.cart_empty_message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: StoreTheme.textMuted,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: StoreTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.cart_continue_shopping),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: StoreTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 88,
                height: 88,
                child: AdaptiveImage(
                  imagePath: item.productImage,
                  fit: BoxFit.cover,
                  placeholderColor: StoreTheme.softBg,
                  errorWidget: Container(color: StoreTheme.softBg),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.productName,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: StoreTheme.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: const Icon(Icons.close_rounded,
                          size: 18, color: StoreTheme.iconMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.color ?? l10n.color_not_set} · ${item.size ?? l10n.size_not_set}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: StoreTheme.textGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuantityControl(
                        quantity: item.quantity,
                        maxQuantity: item.availableStock,
                        onDecrement: () {
                          if (item.quantity > 1) onQuantityChanged(item.quantity - 1);
                        },
                        onIncrement: () {
                          if (item.quantity < item.availableStock) {
                            onQuantityChanged(item.quantity + 1);
                          }
                        },
                      ),
                      const Spacer(),
                      Text(
                        'د.إ ${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: StoreTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final canIncrement = quantity < maxQuantity;
    final canDecrement = quantity > 1;

    return Container(
      decoration: BoxDecoration(
        color: StoreTheme.softBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _StepperButton(icon: Icons.remove, onTap: canDecrement ? onDecrement : null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
                style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: StoreTheme.textDark,
              ),
            ),
          ),
          _StepperButton(icon: Icons.add, onTap: canIncrement ? onIncrement : null),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
            child: Icon(icon,
            size: 18, color: isEnabled ? StoreTheme.primary : StoreTheme.disabled),
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final VoidCallback onCheckout;

  const _CartSummaryBar({
    required this.itemCount,
    required this.subtotal,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.subtotal,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: Color(0xFF7B8794),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'د.إ ${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: StoreTheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: onCheckout,
                child: Text(
                  l10n.checkout_with_count(itemCount),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
