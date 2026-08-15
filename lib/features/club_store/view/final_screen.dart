import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/club_store/view/marchindies_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────
//  App Colors
// ─────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFFFF8F9);
  static const navyLight = Color(0xFFFFCAD7);
  static const cardBlue = Color(0xFFFFCAD7);
  static const buttonColor = Color(0xFFE04B71);
  static const red = Color(0xFFE04B71);
  static const redAcc = Color(0xFFE04B71);
  static const white = Colors.white;
  static const textDark = Color(0xFF1A2332);
  static const textGray = Color(0xFF6B7A8D);
  static const textMid = Color(0xFF4A5568);
  static const totalBlue = Color(0xFF1A3A6B);
  static const divider = Color(0xFFE04B71);
}

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class ClubStoreFinalScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const ClubStoreFinalScreen({super.key, required this.order});

  void _returnToClubStoreHome(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const ClubStoreMarchindiesScreen(),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return WillPopScope(
      onWillPop: () async {
        _returnToClubStoreHome(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: _C.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Scrollable content ──
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main scroll
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          // const SizedBox(height: 52),

                          const SizedBox(height: 16),
                          const _AnimatedCompletionGraphic(),

                          const SizedBox(height: 18),

                              // 2. Heading & sub
                              const _ConfirmationTitle(),

                          const SizedBox(height: 32),

                          // 3. Order summary card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _OrderSummaryCard(order: order),
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 16,
                      top: 16,
                      child: SafeArea(
                        child: GestureDetector(
                          onTap: () {
                            _returnToClubStoreHome(context);
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _C.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: _C.textDark,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Sticky bottom buttons ──
              Container(
                color: _C.bg,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PrimaryButton(
                      label: AppLocalizations.of(context)!.downloadInvoice,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _SecondaryButton(
                      label: AppLocalizations.of(context)!.trackOrder,
                      onTap: () {},
                    ),
                    const SizedBox(height: 28),
                    // Home indicator spacer
                    Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _C.textDark.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Decorative Red Arc
// ─────────────────────────────────────────────
class _RedArc extends StatelessWidget {
  const _RedArc();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(painter: _RedArcPainter()),
    );
  }
}

class _RedArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _C.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width,
        height: size.height,
      ),
      -1.2, // start angle (radians)
      2.4, // sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _AnimatedCompletionGraphic extends StatelessWidget {
  const _AnimatedCompletionGraphic();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/checkmark.gif',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  1. Success Header (circle + icon)
// ─────────────────────────────────────────────
class _SuccessHeader extends StatelessWidget {
  const _SuccessHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 110,
        height: 110,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // White circle
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: _C.white,
                shape: BoxShape.circle,
              ),
            ),
            // Small red accent dot (top-right area inside circle)
            Positioned(
              top: 22,
              right: 22,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: _C.redAcc,
                  shape: BoxShape.circle,
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
//  2. Confirmation Title
// ─────────────────────────────────────────────
class _ConfirmationTitle extends StatelessWidget {
  const _ConfirmationTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.orderConfirmedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: _C.textDark,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.thankYouForShopping,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _C.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  3. Order Summary Card (outer blue)
// ─────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = ResponseParser.extractList(order['items'], const ['items']);
    final shippingAddress =
        ResponseParser.extractMap(order['shippingAddress'], const []);
    final subtotal = ResponseParser.asDouble(order['subtotal']);
    final shipping = ResponseParser.asDouble(order['shipping']);
    final total = ResponseParser.asDouble(order['total']);
    final paymentMethod = ResponseParser.asString(order['paymentMethod'],
        fallback: l10n.payment_cod_title);
    final paymentLast4 = ResponseParser.asString(order['paymentLast4']);
    final notes = ResponseParser.asString(order['notes']);
    final orderNumber = ResponseParser.asString(order['orderNumber']);
    final status =
        ResponseParser.asString(order['status'], fallback: l10n.pending);

    return Container(
      decoration: BoxDecoration(
        color: _C.cardBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHeader(orderNumber: orderNumber, status: status),
          const SizedBox(height: 16),
          ...items.map((item) {
            final itemMap =
                item is Map<String, dynamic> ? item : <String, dynamic>{};
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ProductRow(item: itemMap),
            );
          }).toList(),
          if (items.isNotEmpty) const SizedBox(height: 8),
          _PaymentDetailsCard(
            shippingAddress: shippingAddress,
            subtotal: subtotal,
            shipping: shipping,
            total: total,
            paymentMethod: paymentMethod,
            paymentLast4: paymentLast4,
            notes: notes,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Product thumbnail row
// ─────────────────────────────────────────────
class _ProductRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ProductRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productName =
        ResponseParser.asString(item['productName'], fallback: l10n.product_label);
    final color = ResponseParser.asString(item['color'], fallback: l10n.colorLabel);
    final size = ResponseParser.asString(item['size'], fallback: l10n.sizeLabel);
    final quantity = ResponseParser.asInt(item['quantity'], fallback: 1);
    final price = ResponseParser.asDouble(item['price']);
    final productImage = ResponseParser.asString(item['productImage']);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 56,
            height: 56,
            child: AdaptiveImage(
              imagePath: productImage,
              fit: BoxFit.cover,
              placeholderColor: const Color(0xFFE2EAF4),
              errorWidget: Container(
                color: const Color(0xFFE2EAF4),
                child: Center(
                  child: Text(
                    productName.isNotEmpty ? productName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A8FA6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _C.textDark,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.productVariantInfo(color, size, quantity),
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _C.textGray,
                ),
              ),
            ],
          ),
        ),
        Text(
          'AED ${price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _C.totalBlue,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  4. Payment Details Card (inner white)
// ─────────────────────────────────────────────
class _PaymentDetailsCard extends StatelessWidget {
  final Map<String, dynamic>? shippingAddress;
  final double subtotal;
  final double shipping;
  final double total;
  final String paymentMethod;
  final String paymentLast4;
  final String notes;

  const _PaymentDetailsCard({
    this.shippingAddress,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.paymentMethod,
    required this.paymentLast4,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shippingAddress != null && shippingAddress!.isNotEmpty) ...[
            _AddressRow(address: shippingAddress!),
            const SizedBox(height: 14),
            const Divider(color: _C.divider, thickness: 1, height: 1),
            const SizedBox(height: 14),
          ],
            _PriceRow(
              label: AppLocalizations.of(context)!.subtotal,
              value: 'AED ${subtotal.toStringAsFixed(2)}',
              isBold: false),
          const SizedBox(height: 8),
            _PriceRow(
              label: AppLocalizations.of(context)!.delivery,
              value: 'AED ${shipping.toStringAsFixed(2)}',
              isBold: false),
          const SizedBox(height: 14),
          const Divider(color: _C.divider, thickness: 1, height: 1),
          const SizedBox(height: 14),
          _TotalRow(total: total),
          const SizedBox(height: 10),
          _PriceRow(
            label: AppLocalizations.of(context)!.payment,
            value: paymentMethod,
            isBold: false,
            labelColor: _C.textGray,
            valueColor: _C.textMid,
          ),
          if (paymentLast4.isNotEmpty) ...[
            const SizedBox(height: 8),
            _PriceRow(
              label: AppLocalizations.of(context)!.cardEnding,
              value: '**** ${paymentLast4}',
              isBold: false,
              labelColor: _C.textGray,
              valueColor: _C.textMid,
            ),
          ],
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(color: _C.divider, thickness: 1, height: 1),
            const SizedBox(height: 14),
            Text(
              AppLocalizations.of(context)!.orderNote,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _C.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              notes,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: _C.textGray,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final String orderNumber;
  final String status;

  const _OrderHeader({required this.orderNumber, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.orderNumber(orderNumber),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _C.textGray,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.orderConfirmed,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _C.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          status.isNotEmpty ? status.toUpperCase() : AppLocalizations.of(context)!.pending.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _C.navyLight,
          ),
        ),
      ],
    );
  }
}

// Address row
class _AddressRow extends StatelessWidget {
  final Map<String, dynamic> address;

  const _AddressRow({required this.address});

  @override
  Widget build(BuildContext context) {
    final name =
        ResponseParser.asString(address['name'], fallback: 'Delivery Address');
    final line1 = ResponseParser.asString(address['line1']);
    final city = ResponseParser.asString(address['city']);
    final emirate = ResponseParser.asString(address['emirate']);
    final phone = ResponseParser.asString(address['phone']);
    final fullAddress =
        [line1, city, emirate].where((part) => part.isNotEmpty).join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.location_on_outlined, size: 18, color: _C.textGray),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.deliveryAddress,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: _C.textGray,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$name · $fullAddress',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _C.textDark,
                  height: 1.45,
                ),
              ),
              if (phone.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _C.textGray,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// Generic price row
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color labelColor;
  final Color valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isBold,
    this.labelColor = _C.textMid,
    this.valueColor = _C.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// Total row (larger, bold, blue amount)
class _TotalRow extends StatelessWidget {
  final double total;

  const _TotalRow({required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Paid',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _C.textDark,
              ),
            ),
          ],
        ),
        Text(
          'AED ${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _C.totalBlue,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Primary Button
// ─────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: _C.buttonColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _C.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Secondary Button
// ─────────────────────────────────────────────
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.buttonColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _C.buttonColor,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
