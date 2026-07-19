import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class AppPhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<Country>? onCountryChanged;
  final Country? initialCountry;

  const AppPhoneNumberField({
    super.key,
    required this.controller,
    this.hintText = 'Enter Your Mobile Number',
    this.validator,
    this.onCountryChanged,
    this.initialCountry,
  });

  @override
  State<AppPhoneNumberField> createState() => _AppPhoneNumberFieldState();
}

class _AppPhoneNumberFieldState extends State<AppPhoneNumberField> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry ?? Country.parse('AE');
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
        widget.onCountryChanged?.call(country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: field.hasError
                      ? Colors.red
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  /// Country picker
                  InkWell(
                    onTap: _openCountryPicker,
                    child: Row(
                      children: [
                        Text(
                          _selectedCountry.flagEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+${_selectedCountry.phoneCode}',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Divider
                  Container(
                    width: 1,
                    height: 28,
                    color: Colors.grey.shade300,
                  ),

                  const SizedBox(width: 12),

                  /// Phone input
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onChanged: (value) {
                        field.didChange(value);
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// Error text
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
