import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/club_store/models/cart_item_model.dart';
import 'package:adcc/features/club_store/repositories/cart_repository.dart';
import 'package:adcc/features/club_store/view/final_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/core/theme/app_colors.dart';

// ─────────────────────────────────────────────
//  Colours & constants
// ─────────────────────────────────────────────
class _C {
  static const bg                 = Color(0xFFFFF8F9);
  static const appBar             = Color(0xFFE04B71);
  static const primary            = Color(0xFFE04B71);
  static const cardBg             = Color(0xFFFFFFFF);
  static const selectedMethodBg   = Color(0xFFFFE1E9);
  static const inputBg            = Color(0xFFDD9AAB);
  static const noteInputBg        = Color(0xFFFFFFFF);
  static const textDark           = Color(0xFF1F2937);
  static const textGray           = Color(0xFF7B8794);
  static const totalBlue          = Color(0xFF1F2937);
  static const border             = Color(0xFFE04B71);
  static const selectedRow        = Color(0x80E04B71);
  static const radioFill          = Color(0xFFE04B71);
}

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class ClubStoreCheckoutScreen extends StatefulWidget {
  const ClubStoreCheckoutScreen({super.key});

  @override
  State<ClubStoreCheckoutScreen> createState() =>
      _ClubStoreCheckoutScreenState();
}

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader();

  static const String _headerImageUrl =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Checkout-1785890804372-f8c34424e268.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AdaptiveImage(
            imagePath: _headerImageUrl,
            fit: BoxFit.cover,
            placeholderColor: _C.appBar,
            errorWidget: Container(color: _C.appBar),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: _CheckoutTitle(),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: _C.textDark,
    ),
  );
}

class _CheckoutTitle extends StatelessWidget {
  const _CheckoutTitle();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.checkout_title,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ClubStoreCheckoutScreenState extends State<ClubStoreCheckoutScreen> {
  final ClubStoreCartRepository _cartRepository = ClubStoreCartRepository.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _line1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emirateController = TextEditingController();
  final TextEditingController _cardLast4Controller = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final double _shippingCost = 25.0;

  bool _isLoading = true;
  bool _isSubmitting = false;
  String _selectedPayment = 'cod';

  static const _paymentOptions = [
    _PaymentOption(
      id: 'credit',
      title: 'credit',
      subtitle: 'credit_sub',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentOption(
      id: 'apple',
      title: 'apple',
      subtitle: 'apple_sub',
      icon: Icons.phone_iphone_rounded,
    ),
    _PaymentOption(
      id: 'tabby',
      title: 'tabby',
      subtitle: 'tabby_sub',
      icon: Icons.grid_view_rounded,
    ),
    _PaymentOption(
      id: 'cod',
      title: 'cod',
      subtitle: 'cod_sub',
      icon: Icons.payments_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _cityController.dispose();
    _emirateController.dispose();
    _cardLast4Controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _cartRepository.loadCart(),
      _loadProfile(),
    ]);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
      final userMap = ResponseParser.extractMap(
        response.data,
        const ['user', 'profile', 'data'],
      ) ??
          ResponseParser.extractMap(response.data, const ['data']) ??
          (response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : null);

      if (userMap == null) return;

      _nameController.text = ResponseParser.asString(
        userMap['fullName'] ?? userMap['name'],
      );
      _phoneController.text = ResponseParser.asString(
        userMap['phone'] ?? userMap['mobile'] ?? userMap['contactNumber'],
      );
      _line1Controller.text = ResponseParser.asString(
        userMap['address'] ??
            userMap['street'] ??
            userMap['villa'] ??
            userMap['apartment'] ??
            userMap['area'],
      );
      _cityController.text = ResponseParser.asString(
        userMap['city'] ?? userMap['location'] ?? userMap['area'] ?? userMap['country'],
      );
      _emirateController.text = ResponseParser.asString(
        userMap['emirate'] ?? userMap['state'] ?? userMap['country'] ?? userMap['city'],
      );
    } catch (_) {
      // Ignore profile load failures and keep the form editable.
    }
  }

  Future<void> _placeOrder() async {
    if (_cartRepository.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cart_empty_title)),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final orderData = await _cartRepository.createOrder(
        name: _nameController.text.trim(),
        line1: _line1Controller.text.trim(),
        city: _cityController.text.trim(),
        emirate: _emirateController.text.trim(),
        phone: _phoneController.text.trim(),
        paymentMethod: _paymentLabel,
        paymentLast4: _selectedPayment == 'credit' ? _cardLast4Controller.text.trim() : null,
        shipping: _shippingCost,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      await _cartRepository.clearCart();

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ClubStoreFinalScreen(order: orderData)),
        (route) => route.isFirst,
      );
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.order_place_failed}: ${error.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String get _paymentLabel {
    switch (_selectedPayment) {
      case 'credit':
        return 'Credit / Debit Card';
      case 'apple':
        return 'Apple Pay';
      case 'tabby':
        return 'Tabby';
      case 'cod':
      default:
        return 'Cash on Delivery';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: _C.appBar,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _C.bg,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              top: false,
              child: Column(
                children: [
                  const _CheckoutHeader(),
                  Expanded(
                    child: ValueListenableBuilder<List<CartItemModel>>(
                      valueListenable: _cartRepository.items,
                      builder: (context, items, _) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle(AppLocalizations.of(context)!.order_summary),
                                const SizedBox(height: 12),
                                _OrderSummaryCard(items: items),

                                const SizedBox(height: 24),

                                _sectionTitle(AppLocalizations.of(context)!.delivery_address),
                                const SizedBox(height: 12),
                                _DeliveryAddressCard(
                                  nameController: _nameController,
                                  phoneController: _phoneController,
                                  line1Controller: _line1Controller,
                                  cityController: _cityController,
                                  emirateController: _emirateController,
                                ),

                                const SizedBox(height: 20),

                                _sectionTitle(AppLocalizations.of(context)!.payment_method),
                                const SizedBox(height: 12),
                                _PaymentMethodCard(
                                  options: _paymentOptions,
                                  selected: _selectedPayment,
                                  onSelect: (id) => setState(() => _selectedPayment = id),
                                ),

                                if (_selectedPayment == 'credit') ...[
                                  const SizedBox(height: 18),
                                  _CreditCardField(controller: _cardLast4Controller),
                                ],

                                const SizedBox(height: 24),

                                _sectionTitle(AppLocalizations.of(context)!.order_notes),
                                const SizedBox(height: 12),
                                _NotesField(controller: _notesController),

                                const SizedBox(height: 24),

                                _sectionTitle(AppLocalizations.of(context)!.price_details),
                                const SizedBox(height: 12),
                                _PriceDetailsCard(
                                  subtotal: _cartRepository.subtotal,
                                  shipping: _shippingCost,
                                  itemCount: items.length,
                                ),

                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        color: _C.cardBg,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: _FloatingCheckoutBar(
          totalAmount: _cartRepository.total(shipping: _shippingCost),
          isSubmitting: _isSubmitting,
          onCheckout: _placeOrder,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Order Summary Card
// ─────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final List<CartItemModel> items;
  const _OrderSummaryCard({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Text(
          AppLocalizations.of(context)!.cart_empty_message,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _C.textGray,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: AdaptiveImage(
                      imagePath: item.productImage,
                      fit: BoxFit.cover,
                      placeholderColor: const Color(0xFFFFE1E9),
                      errorWidget: Container(
                        color: const Color(0xFFFFE1E9),
                        child: Center(
                          child: Text(
                            item.productName.isNotEmpty ? item.productName[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _C.textGray,
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
                        item.productName,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item.color ?? 'Color'} · ${item.size ?? 'Size'} · Qty ${item.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: _C.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'AED ${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _C.totalBlue,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Delivery Address Card
// ─────────────────────────────────────────────
class _DeliveryAddressCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController line1Controller;
  final TextEditingController cityController;
  final TextEditingController emirateController;

  const _DeliveryAddressCard({
    required this.nameController,
    required this.phoneController,
    required this.line1Controller,
    required this.cityController,
    required this.emirateController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Full Name + Phone
          Row(
            children: [
              Expanded(
                child: _LabeledInputField(
                  label: AppLocalizations.of(context)!.full_name,
                  controller: nameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledInputField(
                  label: AppLocalizations.of(context)!.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter your phone' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Row 2: Street full-width
          _LabeledInputField(
            label: AppLocalizations.of(context)!.street_villa_apartment,
            controller: line1Controller,
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter your street address' : null,
          ),
          const SizedBox(height: 14),
          // Row 3: Area + Emirate
          Row(
            children: [
              Expanded(
                child: _LabeledInputField(
                  label: AppLocalizations.of(context)!.area,
                  controller: cityController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter your area' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledInputField(
                  label: AppLocalizations.of(context)!.emirate,
                  controller: emirateController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter your emirate' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _AddressField({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _C.textGray,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: _C.inputBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _C.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool hasBorder;
  final Color fillColor;

  const _LabeledInputField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.hasBorder = false,
    this.fillColor = _C.inputBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _C.textGray,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasBorder
                  ? const BorderSide(color: _C.border, width: 1)
                  : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasBorder
                  ? const BorderSide(color: _C.border, width: 1)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: hasBorder
                  ? const BorderSide(color: _C.primary, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _C.textDark,
          ),
        ),
      ],
    );
  }
}

class _CreditCardField extends StatelessWidget {
  final TextEditingController controller;

  const _CreditCardField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _LabeledInputField(
      label: AppLocalizations.of(context)!.card_last_4_digits,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter the last 4 digits of your card';
        }
        if (value.trim().length != 4) {
          return 'Enter exactly 4 digits';
        }
        return null;
      },
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _LabeledInputField(
      label: AppLocalizations.of(context)!.additional_notes_optional,
      controller: controller,
      maxLines: 3,
      validator: (_) => null,
      hasBorder: true,
      fillColor: _C.noteInputBg,
    );
  }
}

// ─────────────────────────────────────────────
//  Floating Checkout Bar
// ─────────────────────────────────────────────
class _FloatingCheckoutBar extends StatelessWidget {
  final double totalAmount;
  final bool isSubmitting;
  final VoidCallback onCheckout;

  const _FloatingCheckoutBar({
    required this.totalAmount,
    required this.isSubmitting,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.cardBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      color: _C.textGray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AED ${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _C.totalBlue,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: isSubmitting ? null : onCheckout,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: _C.primary.withOpacity(isSubmitting ? 0.65 : 1),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  alignment: Alignment.center,
                      child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Builder(builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Text(
                            l10n.checkout_place_order,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          );
                        }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "By placing your order you agree to ADCC's Terms & Conditions",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10.5,
              color: _C.textGray.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Offer Card
// ─────────────────────────────────────────────
class _OfferCard extends StatelessWidget {
  const _OfferCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Text(
            'View available offers',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _C.textDark,
            ),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: _C.textGray, size: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Payment Method Card
// ─────────────────────────────────────────────
@immutable
class _PaymentOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _PaymentMethodCard extends StatelessWidget {
  final List<_PaymentOption> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PaymentMethodCard({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
                        children: options
            .map((opt) => _PaymentOptionTile(
                  option: opt,
                  isSelected: opt.id == selected,
                  isEnabled: opt.id == 'cod',
                  onTap: () {
                    if (opt.id == 'cod') {
                      onSelect(opt.id);
                    }
                  },
                  showDivider: opt != options.last,
                ))
            .toList(),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final _PaymentOption option;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  final bool showDivider;

  const _PaymentOptionTile({
    required this.option,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: isSelected ? _C.selectedMethodBg : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? _C.border : Colors.transparent,
              ),
            ),
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.45,
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 40,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _C.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(option.icon, size: 18, color: _C.primary),
                  ),
                  const SizedBox(width: 14),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          final title = option.title == 'credit'
                              ? l10n.payment_credit_title
                              : option.title == 'apple'
                                  ? l10n.payment_apple_title
                                  : option.title == 'tabby'
                                      ? l10n.payment_tabby_title
                                      : l10n.payment_cod_title;
                          final subtitle = option.subtitle == 'credit_sub'
                              ? l10n.payment_credit_sub
                              : option.subtitle == 'apple_sub'
                                  ? l10n.payment_apple_sub
                                  : option.subtitle == 'tabby_sub'
                                      ? l10n.payment_tabby_sub
                                      : l10n.payment_cod_sub;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: _C.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  color: _C.textGray,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  // Radio
                  _RadioIndicator(selected: isSelected),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            color: _C.border,
            height: 1,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
      ],
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool selected;
  const _RadioIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _C.radioFill : _C.textGray.withOpacity(0.4),
          width: selected ? 0 : 1.5,
        ),
        color: selected ? _C.radioFill : Colors.transparent,
      ),
      child: selected
          ? const Center(
              child: Icon(Icons.circle, size: 10, color: Colors.white),
            )
          : null,
    );
  }
}

// ─────────────────────────────────────────────
//  Price Details Card
// ─────────────────────────────────────────────
class _PriceDetailsCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final int itemCount;

  const _PriceDetailsCard({
    required this.subtotal,
    required this.shipping,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + shipping;
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _PriceRow(label: AppLocalizations.of(context)!.subtotal_items(itemCount), value: 'AED ${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _PriceRow(label: AppLocalizations.of(context)!.delivery_fee, value: 'AED ${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 14),
          const Divider(color: _C.border, thickness: 1, height: 1),
          const SizedBox(height: 14),
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _C.textDark,
                ),
              ),
              Text(
                'AED ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.totalBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            color: _C.textGray,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            color: _C.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}