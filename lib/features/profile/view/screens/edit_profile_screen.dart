import 'dart:io';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adcc/features/profile/services/profile_service.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  String? _country;
  String? _city;
  List<String> _availableCities = const [];
  bool _isLoadingCities = true;
  File? _imageFile;
  String? _imageUrl;
  String _initialEmail = '';
  bool _isSaving = false;

  final _service = ProfileService();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final cities = await _service.fetchAvailableCities();
      final resp = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
      final userMap = ResponseParser.extractMap(
        resp.data,
        const ['user', 'profile', 'data'],
      );

      if (userMap == null) return;

      final name = ResponseParser.asString(userMap['fullName']);
      final gender = ResponseParser.asString(userMap['gender']);
      final email = ResponseParser.asString(userMap['email']);
      final country = ResponseParser.asString(userMap['country']);
      final city = ResponseParser.asString(
          userMap['city'] ?? userMap['country'] ?? userMap['location']);
      final dobRaw =
          ResponseParser.asString(userMap['dob'] ?? userMap['dateOfBirth']);
      final image =
          ResponseParser.asString(userMap['profileImage'] ?? userMap['image']);

      DateTime? parsedDob;
      if (dobRaw.isNotEmpty) {
        parsedDob = DateTime.tryParse(dobRaw) ??
            (dobRaw.contains('-') ? DateTime.tryParse(dobRaw) : null);
      }

      if (!mounted) return;
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
        _initialEmail = email.trim().toLowerCase();
        _gender = gender.isEmpty ? null : gender;
        _countryController.text = country;
        _country = country.isEmpty ? null : country;
        _availableCities = cities;
        _isLoadingCities = false;
        _cityController.text = city;
        _city = city.isEmpty ? null : city;
        _dob = parsedDob;
        _imageUrl = image.isEmpty ? null : image;
      });
    } catch (_) {
      // ignore failures; keep defaults
      if (!mounted) return;
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _pickCity() async {
    if (_availableCities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.citiesAreLoading)),
      );
      return;
    }

    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: _availableCities
              .map(
                (option) => ListTile(
                  title: Text(option),
                  onTap: () => Navigator.pop(context, option),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (value != null) {
      setState(() {
        _city = value;
        _cityController.text = value;
      });
    }
  }

  Future<void> _pickCountry() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_uae)),
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_saudi_arabia)),
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_qatar)),
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_oman)),
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_kuwait)),
            ListTile(title: Text(AppLocalizations.of(context)!.profile_country_bahrain)),
          ].map((tile) {
            return ListTile(
              title: tile.title,
              onTap: () => Navigator.pop(context, (tile.title as Text).data),
            );
          }).toList(),
        ),
      ),
    );

    if (value != null) {
      setState(() {
        _country = value;
        _countryController.text = value;
      });
    }
  }

  Future<void> _pickImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      String? uploadedUrl;
      if (_imageFile != null) {
        final uploadRes = await _service.uploadImageFile(_imageFile!);
        uploadedUrl = _extractUploadedUrl(uploadRes.data);
      }

      final updates = <String, dynamic>{};
      if (_nameController.text.trim().isNotEmpty)
        updates['fullName'] = _nameController.text.trim();
      final enteredEmail = _emailController.text.trim().toLowerCase();
      final isEmailChanged = enteredEmail != _initialEmail;
      if (isEmailChanged && enteredEmail.isNotEmpty) {
        final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
        if (!emailRegex.hasMatch(enteredEmail)) {
          messenger.showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterValidEmail)),
          );
          return;
        }
        updates['email'] = enteredEmail;
      }
      if (_gender != null) updates['gender'] = _gender;
      if (_dob != null) updates['dob'] = _dob!.toIso8601String();
      final countryVal = (_country ?? _countryController.text).trim();
      if (countryVal.isNotEmpty) updates['country'] = countryVal;
      final cityVal = (_city ?? _cityController.text).trim();
      if (cityVal.isNotEmpty) updates['city'] = cityVal;
      if (uploadedUrl != null) updates['profileImage'] = uploadedUrl;

      if (updates.isNotEmpty) {
        await _service.updateProfile(updates);
      }

      messenger.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)));
      Navigator.pop(context);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(_friendlyErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _friendlyErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is List && message.isNotEmpty) {
          final first = message.first;
          if (first is Map<String, dynamic>) {
            final fieldMessage = ResponseParser.asString(first['message']);
            if (fieldMessage.isNotEmpty) return fieldMessage;
          }
          final firstText = ResponseParser.asString(first);
          if (firstText.isNotEmpty) return firstText;
        }
        final direct = ResponseParser.asString(message);
        if (direct.isNotEmpty) return direct;
      }
      return AppLocalizations.of(context)!.unable_to_update_profile;
    }
    return AppLocalizations.of(context)!.unable_to_update_profile_generic;
  }

  String? _extractUploadedUrl(dynamic responseData) {
    if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    if (responseData is Map<String, dynamic>) {
      final nested = responseData['data'];
      if (nested is String && nested.isNotEmpty) {
        return nested;
      }

      if (nested is Map<String, dynamic>) {
        final url = nested['url'];
        if (url is String && url.isNotEmpty) {
          return url;
        }

        final path = nested['path'];
        if (path is String && path.isNotEmpty) {
          return path;
        }
      }

      final url = responseData['url'];
      if (url is String && url.isNotEmpty) {
        return url;
      }

      final path = responseData['path'];
      if (path is String && path.isNotEmpty) {
        return path;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: resolveImageProvider(ProfileImgs.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0x5C035AE9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF435974),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildImageUploadCard(),
                  const SizedBox(height: 35),
                  Text(
                    AppLocalizations.of(context)!.personal_information,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        _buildField(
                          icon: Icons.person_outline,
                          title: AppLocalizations.of(context)!.full_name,
                          child: TextFormField(
                            controller: _nameController,
                            decoration:
                                _fieldDecoration(AppLocalizations.of(context)!.profile_full_name_hint),
                          ),
                        ),
                        _buildField(
                          icon: Icons.email_outlined,
                          title: AppLocalizations.of(context)!.email,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: _fieldDecoration(AppLocalizations.of(context)!.profile_email_hint),
                            validator: (value) {
                              final email = (value ?? '').trim();
                              if (email.isEmpty) return null;
                              if (email.toLowerCase() == _initialEmail)
                                return null;
                              final emailRegex =
                                  RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                              if (!emailRegex.hasMatch(email)) {
                                return AppLocalizations.of(context)!.pleaseEnterValidEmail;
                              }
                              return null;
                            },
                          ),
                        ),
                        _buildDateField(),
                        _buildField(
                          icon: Icons.location_city_outlined,
                          title: AppLocalizations.of(context)!.cityLabel,
                          child: TextField(
                            controller: _cityController,
                            readOnly: true,
                            onTap: _isLoadingCities ? null : _pickCity,
                            decoration: _fieldDecoration(
                              _isLoadingCities
                                  ? AppLocalizations.of(context)!.citiesAreLoading
                                  : AppLocalizations.of(context)!.enter_your_city,
                            ),
                          ),
                        ),
                        _buildField(
                          icon: Icons.flag_outlined,
                          title: AppLocalizations.of(context)!.countryLabel,
                          child: TextField(
                            controller: _countryController,
                            readOnly: true,
                            onTap: _pickCountry,
                            decoration: _fieldDecoration(AppLocalizations.of(context)!.enter_your_country),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    AppLocalizations.of(context)!.about_me,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.bio,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4DFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(14),
                              hintText:
                                  AppLocalizations.of(context)!.tell_us_about,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5257B5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              AppLocalizations.of(context)!.save_changes,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadCard() {
    final ImageProvider<Object>? imageProvider = _imageFile != null
        ? FileImage(_imageFile!)
        : _imageUrl != null && _imageUrl!.isNotEmpty
            ? (_imageUrl!.startsWith('assets/')
                ? AssetImage(_imageUrl!) as ImageProvider<Object>
                : NetworkImage(_imageUrl!) as ImageProvider<Object>)
            : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        image: DecorationImage(
            image:
                resolveImageProvider(ProfileImgs.profileEditUploadBackground),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: const Color(0xFF5257B5),
                    backgroundImage: imageProvider,
                    child: imageProvider == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF7592BA),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3D82F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.upload_a_new_photo,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.photo_size_hint,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: Color(0xFFD6DFEC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.upload,
                      style: const TextStyle(
                        color: Color(0xFF5257B5),
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 46,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                      _imageUrl = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF3C4F67)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return _buildField(
      icon: Icons.calendar_today_outlined,
      title: AppLocalizations.of(context)!.date_of_birth,
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            initialDate: _dob ?? DateTime(1990),
          );

          if (picked != null) {
            setState(() => _dob = picked);
          }
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE4DFFF),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            _dob == null
                ? AppLocalizations.of(context)!.select_date_of_birth
                : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
            style: const TextStyle(
              fontFamily: 'Outfit',
              color: Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFE4DFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE4DFFF), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: const TextStyle(
        fontFamily: 'Outfit',
        color: Color(0xFF6C7C93),
      ),
    );
  }
}
