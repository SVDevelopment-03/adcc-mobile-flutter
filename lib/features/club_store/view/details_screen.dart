import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:adcc/features/club_store/repositories/cart_repository.dart';
import 'package:adcc/features/club_store/view/cart_screen.dart';
import 'package:adcc/features/club_store/view/checkout_screen.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
class _AppColors {
  static const background   = Color(0xFFFFF8F9);
  static const navyDark     = Color(0xFF1A2B3C);
  static const navyMid      = Color(0xFF2D3F52);
  static const navyLight    = Color(0xFF455A78);
  static const oldPrice     = Color(0xFF9AA5B4);
  static const chipBg       = Color(0xFFFFE1E9);
  static const selectedChip = Color(0xFFE04B71);
  static const cardBg       = Colors.white;
  static const starGold     = Color(0xFFFFC107);
  static const bodyText     = Color(0xFF4A5568);
  static const labelText    = Color(0xFF8A95A3);
}

class _Radius {
  static const card   = 20.0;
  static const chip   = 30.0;
  static const small  = 12.0;
  static const button = 16.0;
}

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────

class ClubStoreDetailsScreen extends StatefulWidget {
  final StoreItemModel item;

  const ClubStoreDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ClubStoreDetailsScreen> createState() => _ClubStoreDetailsScreenState();
}

class _ClubStoreDetailsScreenState extends State<ClubStoreDetailsScreen> {
  String _selectedColor = 'Blue';
  String _selectedSize  = 'M';
  int    _quantity      = 1;
  int    _currentImageIndex = 0;

  late final List<String> _colors;
  late final List<String> _sizes;
  late final PageController _pageController;

  static const List<_SpecItem> _specs = [
    _SpecItem('Material: 88% Polyester'),
    _SpecItem('Fit: Race'),
    _SpecItem('Pockets: 03'),
    _SpecItem('Zipper: Full-Length'),
    _SpecItem('Weight: 135g (M)'),
    _SpecItem('Care: Machine Wash 30°C'),
  ];

  @override
  void initState() {
    super.initState();

    _colors = widget.item.availableColors.isNotEmpty
        ? widget.item.availableColors
        : ['Blue', 'Black', 'White'];
    _sizes = widget.item.availableSizes.isNotEmpty
        ? widget.item.availableSizes
        : ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    _selectedColor = _colors.contains(_selectedColor) ? _selectedColor : _colors.first;
    _selectedSize = _sizes.contains(_selectedSize) ? _selectedSize : _sizes.first;
    _pageController = PageController();
  }

  int get _availableStock {
    return widget.item.stockFor(
      size: _selectedSize,
      color: _selectedColor,
    );
  }

  bool get _isOutOfStock => _availableStock <= 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _shareProduct() {
    final box = context.findRenderObject() as RenderBox?;
    final shareText = '''${widget.item.title}

${widget.item.description}

Price: ${widget.item.price}''';

    Share.share(
      shareText,
      subject: widget.item.title,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero image
                    _ProductImageSection(
                      onBack: () => Navigator.maybePop(context),
                      onViewCart: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ClubStoreCartScreen(),
                          ),
                        );
                      },
                      item: widget.item,
                      pageController: _pageController,
                      currentIndex: _currentImageIndex,
                      onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    ),

                    const SizedBox(height: 18),

                    // 2. Name + Price + Rating
                    _ProductInfoSection(item: widget.item),

                    const SizedBox(height: 16),

                    // 3. Feature cards
                    const _FeatureRow(),

                    const SizedBox(height: 20),

                    // 4. Color selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Color'),
                          const SizedBox(height: 12),
                          _ColorSelector(
                            colors: _colors,
                            selected: _selectedColor,
                            onSelect: (c) => setState(() => _selectedColor = c),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5. Size selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Size'),
                          const SizedBox(height: 12),
                          _SizeSelector(
                            sizes: _sizes,
                            selected: _selectedSize,
                            onSelect: (s) => setState(() => _selectedSize = s),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 6. Quantity + Add to cart
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _QuantityCartBar(
                        quantity: _quantity,
                        maxQuantity: _availableStock,
                        isOutOfStock: _isOutOfStock,
                        onDecrement: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                        onIncrement: () {
                          if (_quantity < _availableStock) {
                            setState(() => _quantity++);
                          }
                        },
                        onShare: _shareProduct,
                        onViewCart: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ClubStoreCartScreen(),
                            ),
                          );
                        },
                        onAddToCart: () async {
                          if (_isOutOfStock) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Selected variant is out of stock.')),
                            );
                            return;
                          }

                          if (_quantity > _availableStock) {
                            setState(() => _quantity = _availableStock);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Maximum available quantity is $_availableStock.')),
                            );
                            return;
                          }

                          await ClubStoreCartRepository.instance.addItemFromStoreItem(
                            widget.item,
                            _selectedSize,
                            _selectedColor,
                            _quantity,
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart successfully')),
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ClubStoreCheckoutScreen()),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 7. Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Description'),
                          const SizedBox(height: 10),
                          Text(
                            widget.item.description.isNotEmpty
                                ? widget.item.description
                                : 'No description available.',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              color: _AppColors.bodyText,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 8. Specifications
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Specifications'),
                          const SizedBox(height: 12),
                          (widget.item.specifications.isNotEmpty
                                  ? widget.item.specifications
                                  : widget.item.details)
                              .isNotEmpty
                              ? _SpecificationWrap(
                                  specs: (widget.item.specifications.isNotEmpty
                                          ? widget.item.specifications
                                          : widget.item.details)
                                      .map((d) => _SpecItem(d))
                                      .toList(),
                                )
                              : const _SpecificationWrap(specs: _specs),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ── Sticky bottom CTA ──
            Container(
              color: _AppColors.background,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _BottomActionButton(
                label: _isOutOfStock ? 'Out of stock' : 'Buy Now',
                onTap: _isOutOfStock ? null : () async {
                  if (_isOutOfStock) return;

                  if (_quantity > _availableStock) {
                    setState(() => _quantity = _availableStock);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Maximum available quantity is $_availableStock.')),
                    );
                    return;
                  }

                  await ClubStoreCartRepository.instance.addItemFromStoreItem(
                    widget.item,
                    _selectedSize,
                    _selectedColor,
                    _quantity,
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart successfully')),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClubStoreCheckoutScreen()),
                  );
                },
                enabled: !_isOutOfStock,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: _AppColors.navyDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  1. Product Image Section
// ─────────────────────────────────────────────
class _ProductImageSection extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onViewCart;
  final StoreItemModel item;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _ProductImageSection({
    required this.onBack,
    required this.onViewCart,
    required this.item,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final imgHeight = MediaQuery.of(context).size.height * 0.42;
    final images = item.gallery.isNotEmpty ? item.gallery : [item.image];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_Radius.card),
        child: Column(
          children: [
            SizedBox(
              height: imgHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: pageController,
                    physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      return AdaptiveImage(
                        imagePath: images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholderColor: const Color(0xFF435873),
                        errorWidget: Container(color: const Color(0xFF435873)),
                      );
                    },
                  ),

                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: _AppColors.navyDark),
                      ),
                    ),
                  ),
                  if (item.isOutOfStock)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: _OutOfStockBadge(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.black
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Splash painter
// ─────────────────────────────────────────────
class _SplashBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final bg = Paint()..color = const Color(0xFFE8ECF3);
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height), bg);

    void drawSplash(Path path, Color c) =>
        canvas.drawPath(path, Paint()..color = c);

    // Blue blob – left + top
    final blue = Path()
      ..moveTo(0, 0)
      ..cubicTo(s.width * .30, 0, s.width * .55, s.height * .10,
          s.width * .60, s.height * .45)
      ..cubicTo(s.width * .45, s.height * .80, s.width * .10, s.height * .90,
          0, s.height * .70)
      ..close();
    drawSplash(blue, const Color(0xFF1565C0).withOpacity(.88));

    // Lighter blue accent
    final blueAcc = Path()
      ..moveTo(s.width * .05, 0)
      ..cubicTo(s.width * .38, s.height * .05, s.width * .45, s.height * .20,
          s.width * .38, s.height * .50)
      ..cubicTo(s.width * .28, s.height * .68, s.width * .05, s.height * .65,
          s.width * .02, s.height * .40)
      ..close();
    drawSplash(blueAcc, const Color(0xFF1976D2).withOpacity(.50));

    // Red blob – right + bottom-right
    final red = Path()
      ..moveTo(s.width, 0)
      ..cubicTo(s.width * .68, 0, s.width * .45, s.height * .10,
          s.width * .42, s.height * .50)
      ..cubicTo(s.width * .55, s.height * .88, s.width * .90, s.height * .95,
          s.width, s.height * .80)
      ..close();
    drawSplash(red, const Color(0xFFB71C1C).withOpacity(.82));

    // Dark red bottom streak
    final darkRed = Path()
      ..moveTo(s.width * .30, s.height)
      ..cubicTo(s.width * .55, s.height * .85, s.width * .78, s.height * .90,
          s.width, s.height)
      ..close();
    drawSplash(darkRed, const Color(0xFF880E0E).withOpacity(.70));
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────
//  2. Product Info (name + price + rating)
// ─────────────────────────────────────────────
class _ProductInfoSection extends StatelessWidget {
  final StoreItemModel item;

  const _ProductInfoSection({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            item.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _AppColors.navyDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Prices (left)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _AppColors.navyDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: _AppColors.oldPrice,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Rating (right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded,
                      color: _AppColors.starGold, size: 22),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _AppColors.navyDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(124 reviews)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: _AppColors.oldPrice,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  3. Feature cards row
// ─────────────────────────────────────────────
class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(
            child: _FeatureCard(
              icon: Icons.local_shipping_outlined,
              title: 'Free Delivery',
              subtitle: 'Above AED 200',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _FeatureCard(
              icon: Icons.assignment_return_outlined,
              title: 'Easy Returns',
              subtitle: '7-day policy',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _FeatureCard(
              icon: Icons.verified_user_outlined,
              title: 'Authentic',
              subtitle: 'Secure payment',
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: _AppColors.cardBg,
        borderRadius: BorderRadius.circular(_Radius.small),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: _AppColors.navyMid),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _AppColors.navyDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              color: _AppColors.labelText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  4. Color selector
// ─────────────────────────────────────────────
class _ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selected;
  final ValueChanged<String> onSelect;

  const _ColorSelector({
    required this.colors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: colors.map((c) {
        final isSelected = c == selected;
        return GestureDetector(
          onTap: () => onSelect(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? _AppColors.selectedChip : _AppColors.chipBg,
              borderRadius: BorderRadius.circular(_Radius.chip),
            ),
            child: Text(
              c,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _AppColors.navyDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  5. Size selector
// ─────────────────────────────────────────────
class _SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onSelect;

  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((s) {
        final isSelected = s == selected;
        return GestureDetector(
          onTap: () => onSelect(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 48,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? _AppColors.selectedChip : _AppColors.chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              s,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _AppColors.navyDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  6. Quantity + Add to Cart bar
// ─────────────────────────────────────────────
class _QuantityCartBar extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final bool isOutOfStock;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onShare;
  final VoidCallback onViewCart;
  final VoidCallback onAddToCart;

  const _QuantityCartBar({
    required this.quantity,
    required this.maxQuantity,
    required this.isOutOfStock,
    required this.onDecrement,
    required this.onIncrement,
    required this.onShare,
    required this.onViewCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE1E9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quantity :',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Stepper
              _QuantityStepper(
                quantity: quantity,
                maxQuantity: maxQuantity,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
              const SizedBox(width: 12),
              // Add to cart
              Expanded(
                child: GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _CircleIconButton(icon: Icons.shopping_cart_outlined, onTap: onViewCart),
              const SizedBox(width: 8),
              _CircleIconButton(icon: Icons.share_rounded, onTap: onShare),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.maxQuantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperBtn(
          icon: Icons.remove,
          onTap: onDecrement,
          enabled: quantity > 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        _StepperBtn(
          icon: Icons.add,
          onTap: onIncrement,
          enabled: quantity < maxQuantity,
        ),
      ],
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepperBtn({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? Colors.white.withOpacity(0.15) : Colors.white12,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: enabled ? Colors.black : Colors.black38, size: 16),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _AppColors.navyDark, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  7. Specification chips
// ─────────────────────────────────────────────
@immutable
class _SpecItem {
  final String label;
  const _SpecItem(this.label);
}

class _SpecificationWrap extends StatelessWidget {
  final List<_SpecItem> specs;
  const _SpecificationWrap({required this.specs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specs.map((s) => _SpecificationChip(label: s.label)).toList(),
    );
  }
}

class _SpecificationChip extends StatelessWidget {
  final String label;
  const _SpecificationChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _AppColors.navyDark,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  8. Bottom CTA button
// ─────────────────────────────────────────────
class _BottomActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const _BottomActionButton({
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFE04B71) : const Color(0xFFE04B71).withOpacity(0.5),
          borderRadius: BorderRadius.circular(_Radius.button),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.white : Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutOfStockBadge extends StatelessWidget {
  const _OutOfStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Out of stock',
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}