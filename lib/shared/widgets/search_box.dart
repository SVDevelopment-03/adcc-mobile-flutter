import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable search box widget
class SearchBox extends StatelessWidget {
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  // Styling properties
  final Color? backgroundColor;
  final Color? textColor;
  final Color? placeholderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final Color? enabledBorderColor;
  final double? borderWidth;
  final double? enabledBorderWidth;
  final List<BoxShadow>? boxShadow;

  const SearchBox({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.placeholderColor,
    this.icon,
    this.iconColor,
    this.borderRadius,
    this.contentPadding,
    this.borderColor,
    this.enabledBorderColor,
    this.borderWidth,
    this.enabledBorderWidth,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? 12.0;
    final defaultBackgroundColor = backgroundColor ?? Colors.white;
    final defaultTextColor = textColor ?? Colors.black;
    final defaultPlaceholderColor = placeholderColor ?? Colors.grey.shade500;
    final defaultIcon = icon ?? Icons.search;
    final defaultIconColor = iconColor ?? Colors.grey.shade600;
    final defaultContentPadding = contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        );
    final defaultBorderColor = borderColor ?? AppColors.deepRed.withValues(alpha: 0.5);
    final defaultBorderWidth = borderWidth ?? 1.0;
    final defaultEnabledBorderColor = enabledBorderColor;
    final defaultEnabledBorderWidth = enabledBorderWidth ?? 1.0;
    final defaultBoxShadow = boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ];

    return Container(
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: defaultBoxShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        style: TextStyle(
          color: defaultTextColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: placeholder ?? 'Search...',
          hintStyle: TextStyle(
            color: defaultPlaceholderColor,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            defaultIcon,
            color: defaultIconColor,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultEnabledBorderColor ?? Colors.transparent,
              width: defaultEnabledBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultEnabledBorderColor ?? Colors.transparent,
              width: defaultEnabledBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: defaultBorderWidth,
            ),
          ),
          contentPadding: defaultContentPadding,
        ),
      ),
    );
  }
}


