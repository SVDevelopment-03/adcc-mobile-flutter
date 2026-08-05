import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/sections/Join%20Event/join_event_emergency_card.dart';
import 'package:adcc/features/events/sections/Join%20Event/join_event_event_card.dart';
import 'package:adcc/features/events/sections/Join%20Event/join_event_text_field.dart';
import 'package:adcc/features/events/sections/Join%20Event/joint_event_header.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/events/view/your_registered_screen.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import '../../auth/view/registrationScreen/create_account.dart';

class JoinEvent extends StatefulWidget {
  final String? eventId;

  const JoinEvent({super.key, this.eventId});

  @override
  State<JoinEvent> createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {
  final _formKey = GlobalKey<FormState>();
  final _eventsService = EventsService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();

  String? selectedBikeType;
  String? haveBike;
  String? selectedBloodGroup;
  Country? selectedCountry;
  Event? _event;
  bool _isMemberJoined = false;
  bool _isGuest = false;
  bool isLoadingUserData = true;
  bool isRegistering = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadScreenData();
  }

  Future<void> _setGuestState() async {
    final isGuest = await TokenStorageService.isGuestUser();
    if (!mounted) return;
    setState(() => _isGuest = isGuest);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadScreenData() async {
    final eventId = (widget.eventId ?? '').trim();
    if (eventId.isEmpty) {
      if (!mounted) return;
      setState(() {
        isLoadingUserData = false;
        errorMessage = null;
      });
      return;
    }

    await _setGuestState();
    if (_isGuest) {
      if (!mounted) return;
      setState(() {
        isLoadingUserData = false;
        errorMessage = null;
      });
      return;
    }

    try {
      final profileFuture = ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
      final eventFuture = _eventsService.getEventById(eventId);
      final statusFuture = _eventsService.getMemberStatus(eventId: eventId);

      final profileResponse = await profileFuture;
      final eventResponse = await eventFuture;
      final statusResponse = await statusFuture;

      final responseData = profileResponse.data;

      if (!eventResponse.success || eventResponse.data == null) {
        if (!mounted) return;
        setState(() {
          isLoadingUserData = false;
          errorMessage = eventResponse.message ?? 'Failed to load event details.';
        });
        return;
      }

      final userData = responseData is Map<String, dynamic>
          ? (responseData['data'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(responseData['data'] as Map)
              : responseData)
          : <String, dynamic>{};

      if (!mounted) return;

      setState(() {
        _event = eventResponse.data;
        _isMemberJoined = statusResponse.success && (statusResponse.data ?? false);
        fullNameController.text = userData['fullName']?.toString().trim() ?? '';
        emailController.text = userData['email']?.toString().trim() ?? '';
        phoneController.text = userData['phone']?.toString().trim() ?? '';
        emergencyNameController.text = userData['fullName']?.toString().trim() ?? '';
        emergencyPhoneController.text = userData['phone']?.toString().trim() ?? '';
        isLoadingUserData = false;
        errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoadingUserData = false;
        errorMessage = 'Failed to load event or profile data. Please try again.';
      });
    }
  }

  Future<void> _completeRegistration() async {
    final eventId = (widget.eventId ?? '').trim();
    if (eventId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event ID not found. Please reopen the event.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedBloodGroup == null || selectedCountry == null || (haveBike == 'Yes' && selectedBikeType == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required selections.')),
      );
      return;
    }

    if (haveBike == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select whether you have your own bike.')),
      );
      return;
    }

    if (_isMemberJoined) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already joined for this event.')),
      );
      return;
    }

    setState(() {
      isRegistering = true;
    });

    final result = await _eventsService.joinEvent(eventId: eventId);

    if (!mounted) return;

    setState(() {
      isRegistering = false;
    });

    if (result.success) {
      final successResult = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationSuccessScreen(
            event: _event ?? Event.fromJson(const {}),
            bloodGroup: selectedBloodGroup,
            country: selectedCountry?.name,
            bikeType: selectedBikeType,
            haveBike: haveBike,
            emergencyName: emergencyNameController.text,
            emergencyPhone: emergencyPhoneController.text,
          ),
        ),
      );

      if (!mounted) return;

      if (successResult == true) {
        Navigator.pop(context, true);
      }

      return;
    }

    final errorMessage = result.message?.toLowerCase() ?? '';
    if (errorMessage.contains('already joined')) {
      if (!mounted) return;
      await _loadScreenData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already joined for this event.')),
      );
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message ?? 'Failed to complete registration.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUserData) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5EDFF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isGuest) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5EDFF),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Event registration is available only for logged in users.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5161F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login to continue',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (widget.eventId == null || (widget.eventId ?? '').trim().isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5EDFF),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Event ID missing. Please open the event from its details page.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5EDFF),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadScreenData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return  Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(EventsImgs.eventBackground),
          fit: BoxFit.cover,
        ),
      ),
      child:  SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      JoinEventHeader(
                        onBackTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                      JoinEventEventCard(
                        event: _event,
                        isJoined: _isMemberJoined,
                      ),
                      if (_isMemberJoined) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFA5D6A7)),
                          ),
                          child: const Text(
                            'You are already registered for this event.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      const Text(
                        'Personal Information',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Full Name *'),
                      JoinEventTextField(
                        controller: fullNameController,
                        hintText: 'Full name',
                        readOnly: true,
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('Email Address *'),
                      JoinEventTextField(
                        controller: emailController,
                        hintText: 'Email address',
                        // readOnly: true,
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('Phone Number *'),
                      JoinEventTextField(
                        controller: phoneController,
                        hintText: 'Phone number',
                        readOnly: true,
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('Blood Group *'),
                      DropdownButtonFormField<String>(
                        value: selectedBloodGroup,
                        hint: const Text('Select blood group'),
                        items: const [
                          'A+',
                          'A-',
                          'B+',
                          'B-',
                          'AB+',
                          'AB-',
                          'O+',
                          'O-',
                        ].map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Please select blood group' : null,
                        onChanged: (val) {
                          setState(() => selectedBloodGroup = val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildLabel('Country *'),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            onSelect: (country) {
                              setState(() {
                                selectedCountry = country;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            selectedCountry?.name ?? 'Select country',
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedCountry == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Cycling Information',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Do you have your own bike?'),
                      DropdownButtonFormField<String>(
                        value: haveBike,
                        hint: const Text('Select option'),
                        items: const ['Yes', 'No'].map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            haveBike = val;
                            if (val == 'No') {
                              selectedBikeType = null;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      if (haveBike == 'Yes') ...[
                        const SizedBox(height: 14),
                        _buildLabel('Bike Type *'),
                        JoinEventDropdown(
                          value: selectedBikeType,
                          hint: 'Select bike type',
                          items: const [
                            'Road Bike',
                            'Mountain Bike',
                            'Hybrid Bike',
                          ],
                          onChanged: (val) {
                            setState(() => selectedBikeType = val);
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      JoinEventEmergencyCard(
                        nameController: emergencyNameController,
                        phoneController: emergencyPhoneController,
                      ),
                      const SizedBox(height: 80),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 51,
                              child: ElevatedButton(
                                onPressed: (isRegistering || _isMemberJoined)
                                    ? null
                                    : _completeRegistration,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isMemberJoined
                                      ? Colors.grey
                                      : const Color(0XFF1B1A6E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isRegistering
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        _isMemberJoined
                                            ? 'Already Joined'
                                            : 'Complete Registration',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'I accept the terms and confirm that all information\nprovided is accurate. I understand the safety\nrequirements and will comply with all event guidelines.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0XFF6A7282),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ), );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}