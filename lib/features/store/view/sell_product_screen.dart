import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart' show MultipartFile;
import '../repositories/store_repository.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'live_posted_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../models/store_item_model.dart';

class SellProductScreen extends StatefulWidget {
  final StoreItemModel? initialItem;

  const SellProductScreen({super.key, this.initialItem});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _currencyController = TextEditingController(text: '');

  String _selectedContactMethod = 'Select contact method';
  String _selectedCity = 'Select city';

  final List<XFile> _selectedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _contactMethods = [
    'Select contact method',
    'Call',
    'WhatsApp',
    'Email',
  ];

  final List<String> _cities = [
    'Select city',
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Al Ain',
    'Khusab',
    'Fujairah',
    'Ras Al Khaimah',
    'Umm Al Quwain',
  ];

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    if (item != null) {
      _productNameController.text = item.title;
      // price stored as numeric string in model
      _priceController.text = item.price.replaceAll(RegExp(r'[^0-9.]'), '');
      _descriptionController.text = item.description;
      _categoryController.text = item.category;
      _conditionController.text =
          item.details.isNotEmpty ? item.details.first : '';
      if (item.contactMethod != null && item.contactMethod!.isNotEmpty) {
        _selectedContactMethod = item.contactMethod!;
      }
      if (item.phoneNumber != null) _phoneController.text = item.phoneNumber!;
      if (item.location.isNotEmpty && _cities.contains(item.location)) {
        _selectedCity = item.location;
      }
    }
  }

  Future<void> _pickPhotosFromGallery() async {
    final files = await _imagePicker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (files.isEmpty) return;

    setState(() {
      final remaining = 5 - _selectedPhotos.length;
      _selectedPhotos.addAll(files.take(remaining));
    });
  }

  void _removePhoto(int index) {
    setState(() => _selectedPhotos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xFFedfffe),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 58),
                  _label(AppLocalizations.of(context)!.product_photos),
                  const SizedBox(height: 12),
                  _photoUploader(),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.product_name),
                  const SizedBox(height: 15),
                  _input(
                    controller: _productNameController,
                    hint: AppLocalizations.of(context)!.e_g_specialized_tarmac_sl7,
                  ),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.category),
                  const SizedBox(height: 15),
                  _input(
                    controller: _categoryController,
                    hint: AppLocalizations.of(context)!.select_category,
                  ),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.condition),
                  const SizedBox(height: 15),
                  _input(
                    controller: _conditionController,
                    hint: AppLocalizations.of(context)!.select_condition,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        width: 155,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(AppLocalizations.of(context)!.currency),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 43,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFedfffe),
                                  border: Border.all(color: const Color(0xFFCACACA)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: buildCurrencyPrice(
                                    _currencyController.text.trim().isEmpty ? '0' : _currencyController.text.trim(),
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF1A1C20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(AppLocalizations.of(context)!.price),
                            const SizedBox(height: 15),
                            _input(
                              controller: _priceController,
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.descriptionLabel),
                  const SizedBox(height: 15),
                  _input(
                    controller: _descriptionController,
                    hint: AppLocalizations.of(context)!.describe_item_hint,
                  ),
                  const SizedBox(height: 35),
                  _label(AppLocalizations.of(context)!.preferred_contact_method),
                  const SizedBox(height: 15),
                  _dropdown(
                    value: _selectedContactMethod,
                    items: _contactMethods,
                    onChanged: (value) {
                      setState(() {
                        _selectedContactMethod =
                            value ?? _selectedContactMethod;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.phone_number),
                  const SizedBox(height: 15),
                  _input(
                    controller: _phoneController,
                    hint: '+971 50 123 4567',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  _label(AppLocalizations.of(context)!.cityLabel),
                  const SizedBox(height: 15),
                  _dropdown(
                    value: _selectedCity,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value ?? _selectedCity;
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFD44838),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.list_item_for_sale,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Center(
                    child: SizedBox(
                      width: 306,
                      child: Text(
                        AppLocalizations.of(context)!.listing_terms,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          color: Color(0xFF6A7282),
                        ),
                      ),
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

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
                decoration: BoxDecoration(
                  color: Color(0xFFD44838).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(53.8462),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 13,
                  color: Color(0xFFD44838),
                ),
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.sellYourProduct,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 28 / 22,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 20 / 16,
        color: Color(0xFF1A1C20),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 20 / 16,
          color: Color(0xFF1A1C20),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 20 / 16,
            color: Color(0xFFA0A0A0),
          ),
          filled: true,
          fillColor: Color(0xFFedfffe),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCACACA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCACACA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD44838)),
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCACACA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFFA0A0A0),
          ),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 20 / 16,
            color: Color(0xFF1A1C20),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: item.startsWith('Select')
                      ? const Color(0xFFA0A0A0)
                      : const Color(0xFF1A1C20),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _photoUploader() {
    final existingPhotos = widget.initialItem?.gallery ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            if (index < _selectedPhotos.length) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_selectedPhotos[index].path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD44838),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (_selectedPhotos.isEmpty && index < existingPhotos.length) {
              final imageUrl = existingPhotos[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    AdaptiveImage(
                      imagePath: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (index == 0 && existingPhotos.length == 1)
                      const SizedBox.shrink(),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: _pickPhotosFromGallery,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFedfffe),
                  border: Border.all(color: const Color(0xFFCACACA)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_a_photo_outlined,
                        size: 26,
                        color: Color(0xFF6A7282),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        index == _selectedPhotos.length ? AppLocalizations.of(context)!.add_photo : '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          '${_selectedPhotos.length}/5 photos selected',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6A7282),
          ),
        ),
        if (_selectedPhotos.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              AppLocalizations.of(context)!.tap_slot_add_photos,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                color: Color(0xFF99A1AF),
              ),
            ),
          ),
      ],
    );
  }

  void _handleSubmit() {
    _submitListing();
  }

  Future<void> _submitListing() async {
    final repo = StoreRepository();

    final title = _productNameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    final category = _categoryController.text.trim();
    final condition = _conditionController.text.trim();
    final currency = _currencyController.text.trim();
    String contactMethod = _selectedContactMethod;
    if (contactMethod == 'Email') contactMethod = 'InApp';

    final phone = _phoneController.text.trim();

    final isCreating = widget.initialItem == null;

    if (title.isEmpty ||
        description.isEmpty ||
        category.isEmpty ||
        condition.isEmpty ||
        currency.isEmpty ||
        price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.fillAllRequiredFields)),
      );
      return;
    }

    if (_selectedCity.startsWith('Select')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectCity)),
      );
      return;
    }

    if (_selectedContactMethod.startsWith('Select')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectContactMethod)),
      );
      return;
    }

    if ((contactMethod == 'Call' || contactMethod == 'WhatsApp') &&
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.phoneRequiredForContactMethod)),
      );
      return;
    }

    if (isCreating && _selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.uploadAtLeastOnePhoto)),
      );
      return;
    }

    final payload = <String, dynamic>{
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'condition': condition,
      'currency': currency,
      'contactMethod': contactMethod,
      'phoneNumber': phone.isEmpty ? null : phone,
      'city': _selectedCity,
    };

    // Build MultipartFile list
    final List<MultipartFile> photos = [];
    for (final x in _selectedPhotos) {
      try {
        final file = File(x.path);
        final name = p.basename(file.path);
        final mf = await MultipartFile.fromFile(file.path, filename: name);
        photos.add(mf);
      } catch (_) {
        // ignore file errors
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    if (widget.initialItem != null) {
      success = await repo.updateItem(widget.initialItem!.id, payload,
          photos: photos.isEmpty ? null : photos);
    } else {
      success = await repo.createItem(payload,
          photos: photos.isEmpty ? null : photos);
    }

    Navigator.pop(context); // hide progress

    if (success) {
      if (widget.initialItem != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.listingUpdated)));
        Navigator.pop(context); // go back to listings
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LivePostedScreen(
              title: title,
              price: formatPriceWithCurrency(
                price,
                _currencyController.text.trim(),
              ),
              imagePath: _selectedPhotos.isNotEmpty
                  ? _selectedPhotos.first.path
                  : null,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveListing)),
      );
    }
  }
}
