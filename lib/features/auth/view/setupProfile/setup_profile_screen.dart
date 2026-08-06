import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/features/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedCity;
  List<String> _availableCities = const [];
  bool _isLoadingCities = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _acceptedTerms = false;
  final _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await _profileService.fetchAvailableCities();
      if (!mounted) return;
      setState(() {
        _availableCities = cities;
        _isLoadingCities = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _availableCities = const [];
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepRed,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _pickGender() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        const options = ['Male', 'Female', 'Prefer not to say'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        _selectedGender = value;
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
      builder: (context) {
        const options = [
          'UAE',
          'Saudi Arabia',
          'Qatar',
          'Oman',
          'Kuwait',
          'Bahrain',
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        _selectedCountry = value;
      });
    }
  }

  Future<void> _pickCity() async {
    if (_availableCities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cities are still loading')),
      );
      return;
    }

    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: _availableCities
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        _selectedCity = value;
      });
    }
  }

  String _birthDateText() {
    if (_selectedBirthDate == null) {
      return 'Choose your birth date';
    }
    final d = _selectedBirthDate!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    const screenBg = Color(0xFFFFFfff);
    return Scaffold(
      backgroundColor: screenBg,
      body: ColoredBox(
        color: screenBg,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
                child: SizedBox(
                  height: 35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFfff),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x1A000000),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 22,
                              color: Color(0xFF2B2B2B),
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Set up your Profile',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 23 / 18,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            // '1/2',
                            '',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildProfileField(
                          icon: Icons.person_outline,
                          label: 'Enter your full name',
                          child: TextFormField(
                            controller: _nameController,
                            contextMenuBuilder: (context, editableTextState) =>
                                const SizedBox.shrink(),
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              letterSpacing: -0.1,
                              color: Color(0xFF333333),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                letterSpacing: -0.1,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildProfileField(
                          icon: Icons.email_outlined,
                          label: 'Enter your email',
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            contextMenuBuilder: (context, editableTextState) =>
                                const SizedBox.shrink(),
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              letterSpacing: -0.1,
                              color: Color(0xFF333333),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Email is required';
                              }
                              final emailRegex =
                                  RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                              if (!emailRegex.hasMatch(email)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                letterSpacing: -0.1,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildProfileField(
                          icon: Icons.calendar_month_outlined,
                          label: _birthDateText(),
                          onTap: _pickBirthDate,
                        ),
                        const SizedBox(height: 12),
                        _buildProfileField(
                          icon: Icons.wc_outlined,
                          label: _selectedGender ?? 'Choose your Gender',
                          onTap: _pickGender,
                          showChevron: true,
                        ),
                        const SizedBox(height: 12),
                        _buildProfileField(
                          icon: Icons.flag_outlined,
                          label: _selectedCountry ?? 'Choose your Country',
                          onTap: _pickCountry,
                          showChevron: true,
                        ),
                        const SizedBox(height: 12),
                        _buildProfileField(
                          icon: Icons.public,
                          label: _selectedCity ??
                              (_isLoadingCities
                                  ? 'Loading cities...'
                                  : 'Choose your City'),
                          onTap: _isLoadingCities ? null : _pickCity,
                          showChevron: true,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _acceptedTerms = !_acceptedTerms;
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.08),
                                  ),
                                ),
                                child: _acceptedTerms
                                    ? const Icon(
                                        Icons.check,
                                        size: 17,
                                        color: Color(0xFF000000),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 18 / 14,
                                      color: Color(0xFF333333),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "I've read and agreed to ",
                                      ),
                                      TextSpan(
                                        text: 'User Agreement',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 51,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    final email = _emailController.text.trim();
                                    final emailRegex =
                                        RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");

                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (_selectedBirthDate == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please select your birth date'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_selectedGender == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Please select your gender'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_selectedCountry == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please select your country'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_selectedCity == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Please select your city'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (!_acceptedTerms) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please accept the Terms & Conditions to continue.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => _isLoading = true);

                                    final navigator = Navigator.of(context);
                                    final messenger =
                                        ScaffoldMessenger.of(context);

                                    final dob = _selectedBirthDate!;
                                    final dobString =
                                        '${dob.year.toString().padLeft(4, '0')}-'
                                        '${dob.month.toString().padLeft(2, '0')}-'
                                        '${dob.day.toString().padLeft(2, '0')}';

                                    try {
                                      final response =
                                          await AuthService.registerUser(
                                        fullName: _nameController.text.trim(),
                                        gender: _selectedGender!,
                                        dob: dobString,
                                        country: _selectedCountry,
                                        city: _selectedCity,
                                        email: email,
                                      );

                                      if (!mounted) return;

                                      if (response.success) {
                                        navigator.pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => const HomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      } else {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              response.message ??
                                                  'Registration failed',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (!mounted) return;
                                      messenger.showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4D6483),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 24 / 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    Widget? child,
    VoidCallback? onTap,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E8F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFAFC7FF),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4D6483),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: child ??
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF454545),
                    ),
                  ),
            ),
            if (showChevron)
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6D6D6D),
              ),
          ],
        ),
      ),
    );
  }
}
