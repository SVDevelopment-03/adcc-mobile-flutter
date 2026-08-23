import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

String resolveCurrencySymbol(String? currency) {
  final raw = (currency ?? '').trim();
  if (raw.isEmpty) return '';

  final alreadySymbol = raw.contains(RegExp(r'[^A-Za-z0-9]')) &&
      !raw.toUpperCase().contains(RegExp(r'^[A-Z]{3}$'));
  if (alreadySymbol) {
    return raw;
  }

  switch (raw.toUpperCase()) {
    case 'AED':
      return '';
    case 'SAR':
      return 'ر.س';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'QAR':
      return 'ر.ق';
    case 'OMR':
      return 'ر.ع';
    case 'BHD':
      return 'ب.د';
    case 'KWD':
      return 'د.ك';
    case 'JOD':
      return 'د.ا';
    default:
      return raw;
  }
}

class UaeDirhamSymbolIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const UaeDirhamSymbolIcon({
    super.key,
    this.width = 18,
    this.height = 18,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/UAE_Dirham_Symbol.svg',
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: 'UAE Dirham symbol',
    );
  }
}

Widget buildCurrencyPrice(String value, {TextStyle? style}) {
  final trimmed = value.trim();
  final amount = trimmed.replaceAll(RegExp(r'[^0-9.,-]'), '').trim();
  final displayAmount = amount.isEmpty
      ? (trimmed.isEmpty ? '0' : trimmed)
      : amount;

  final iconSize = (style?.fontSize ?? 16) * 0.78;

  return RichText(
    text: TextSpan(
      style: style ?? const TextStyle(color: Colors.black),
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: UaeDirhamSymbolIcon(
            width: iconSize,
            height: iconSize,
            color: style?.color,
          ),
        ),
        TextSpan(text: ' $displayAmount'),
      ],
    ),
  );
}

class CurrencyPriceText extends StatelessWidget {
  final String amountText;
  final String? currency;
  final TextStyle? style;

  const CurrencyPriceText({
    super.key,
    required this.amountText,
    this.currency,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = (currency ?? '').trim();
    final isAed = normalized.isEmpty || normalized.toUpperCase() == 'AED';

    if (!isAed) {
      final symbol = resolveCurrencySymbol(currency);
      return Text(
        symbol.isEmpty ? amountText : '$amountText $symbol',
        style: style,
      );
    }

    return buildCurrencyPrice(amountText, style: style);
  }
}

String formatPriceWithCurrency(num price, String? currency) {
  final normalized = (currency ?? '').trim();
  if (normalized.isEmpty || normalized.toUpperCase() == 'AED') {
    return price.toString();
  }
  return '${price.toString()} ${resolveCurrencySymbol(currency)}';
}
