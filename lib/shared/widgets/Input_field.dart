import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final Widget? image;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const InputField({
    super.key, 
    required this.controller,
    required this.hint,
    this.icon,
    this.image,
    required this.keyboardType,
    this.validator,
  });


  Widget? _buildPrefixIcon() {
    if (icon != null) {
      return Icon(icon);
    }
    if (image != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: image,
      );
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
      decoration: InputDecoration(
        prefixIcon: _buildPrefixIcon(),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
