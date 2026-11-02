import 'package:adcc/core/constants/nationalities.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Region/City options accepted by the backend for internal event leads.
const List<String> kInternalEventCities = [
  'Abu Dhabi',
  'Dubai',
  'Sharjah',
  'Ajman',
  'Umm Al Quwain',
  'Ras Al Khaimah',
  'Fujairah',
  'Al Ain',
  'Al Dhafra',
];

/// The number as "+971 501234567" when it is valid for the picked country,
/// else null. Accepts it typed nationally ("050…"), without the trunk "0", or
/// with a matching "+971" / "00971" prefix.
String? normalizePhoneForCountry(String phoneCode, String input) {
  final digits = input.trim().replaceAll(RegExp(r'[\s\-().]'), '');
  if (digits.isEmpty) return null;

  final String international;
  if (digits.startsWith('+')) {
    international = digits;
  } else if (digits.startsWith('00')) {
    international = '+${digits.substring(2)}';
  } else {
    international = '+$phoneCode${digits.replaceFirst(RegExp(r'^0+'), '')}';
  }

  try {
    final parsed = PhoneNumber.parse(international);
    if (!parsed.isValid() || parsed.countryCode != phoneCode) return null;
    return '+${parsed.countryCode} ${parsed.nsn}';
  } catch (_) {
    return null;
  }
}

/// Registration form for an internal event, same as the website form. On submit
/// the details are saved as an event lead, which is the registration. Signed-in
/// members are also joined to the event so it shows as Registered; guests have
/// no account to join with. Then [onRegistered] is called.
class InternalEventRegistrationSection extends StatefulWidget {
  final Event event;
  final bool isGuest;
  final VoidCallback? onRegistered;

  const InternalEventRegistrationSection({
    super.key,
    required this.event,
    this.isGuest = false,
    this.onRegistered,
  });

  @override
  State<InternalEventRegistrationSection> createState() =>
      _InternalEventRegistrationSectionState();
}

class _InternalEventRegistrationSectionState
    extends State<InternalEventRegistrationSection> {
  static const Color _primary = Color(0xFF1B1A6E);
  static const Color _selected = Color(0xFF019839);
  final _formKey = GlobalKey<FormState>();
  final _eventsService = EventsService();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyMobile = TextEditingController();

  Country _mobileCountry = Country.parse('AE');
  Country _emergencyCountry = Country.parse('AE');
  DateTime? _dateOfBirth;
  String? _gender;
  // Region/City is only asked for UAE nationals
  static const _uaeNationality = 'United Arab Emirates';
  String? _nationality = _uaeNationality;
  String? _city;

  bool _submitAttempted = false;
  bool _submitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastName,
      _email,
      _mobile,
      _emergencyName,
      _emergencyMobile,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _fullNumber(Country country, TextEditingController controller) =>
      normalizePhoneForCountry(country.phoneCode, controller.text);

  String? Function(String?) _required(String message) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  String? _validatePhone(
    Country country,
    TextEditingController controller,
    String requiredMessage,
  ) {
    final l = AppLocalizations.of(context)!;
    if (controller.text.trim().isEmpty) return requiredMessage;
    return _fullNumber(country, controller) == null
        ? l.internalEventInvalidMobile
        : null;
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now.subtract(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _pickNationality() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _NationalityPickerSheet(),
    );
    if (picked == null) return;
    setState(() {
      _nationality = picked;
      if (picked != _uaeNationality) _city = null;
    });
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _submitAttempted = true);
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || _dateOfBirth == null || _nationality == null) {
      return;
    }

    setState(() => _submitting = true);
    if (!await _saveLead()) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showMessage(l.internalEventErrorMessage);
      return;
    }

    if (!widget.isGuest) {
      await _eventsService.joinEvent(eventId: widget.event.id);
    }
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
    _showMessage(l.internalEventSuccessMessage);
    widget.onRegistered?.call();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _saveLead() async {
    final result = await _eventsService.submitEventLead(
      eventId: widget.event.id,
      body: {
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
        'mobileNumber': _fullNumber(_mobileCountry, _mobile),
        'email': _email.text.trim().toLowerCase(),
        'gender': _gender,
        'nationality': _nationality,
        if (_nationality == _uaeNationality) 'city': _city,
        'emergencyContactName': _emergencyName.text.trim(),
        'emergencyContactNumber':
            _fullNumber(_emergencyCountry, _emergencyMobile),
      },
    );
    return result.success;
  }

  InputDecoration _decoration(String hint, {Widget? suffixIcon}) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: border(const Color(0xFFE0E0E0)),
      enabledBorder: border(const Color(0xFFE0E0E0)),
      focusedBorder: border(_primary),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 14),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1C20),
          ),
        ),
      );

  Widget _error(String text) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 12),
        child: Text(text,
            style: const TextStyle(color: Colors.red, fontSize: 12)),
      );

  Widget _textField(
    TextEditingController controller, {
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: _decoration(hint),
    );
  }

  /// Read-only field that opens a picker (date of birth, nationality).
  Widget _pickerField({
    required String? value,
    required String hint,
    required String requiredMessage,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final showError = _submitAttempted && value == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: _decoration(hint, suffixIcon: Icon(icon, size: 20))
                .copyWith(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: showError ? Colors.red : const Color(0xFFE0E0E0)),
              ),
            ),
            isEmpty: value == null,
            child: value == null
                ? null
                : Text(value,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ),
        if (showError) _error(requiredMessage),
      ],
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required String requiredMessage,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      validator: _required(requiredMessage),
      decoration: _decoration(hint),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
      items: items.entries
          .map((entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _messageCard(String title, [String? message]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    if (widget.event.isRegistrationClosed) {
      return _messageCard(l.internalEventRegistrationClosed);
    }
    if (_submitted) {
      return _messageCard(
          l.internalEventSuccessTitle, l.internalEventSuccessMessage);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _submitAttempted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.internalEventFormTitle,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(l.internalEventFormDescription,
                style: const TextStyle(fontSize: 13, color: Colors.black54)),
            _label(l.internalEventFirstName),
            _textField(
              _firstName,
              hint: l.internalEventFirstNameHint,
              validator: _required(l.internalEventFirstNameRequired),
              autofillHints: const [AutofillHints.givenName],
            ),
            _label(l.internalEventLastName),
            _textField(
              _lastName,
              hint: l.internalEventLastNameHint,
              validator: _required(l.internalEventLastNameRequired),
              autofillHints: const [AutofillHints.familyName],
            ),
            _label(l.date_of_birth),
            _pickerField(
              value: _dateOfBirth == null
                  ? null
                  : DateFormat('d MMM yyyy', languageCode)
                      .format(_dateOfBirth!),
              hint: l.date_of_birth,
              requiredMessage: l.internalEventDateOfBirthRequired,
              onTap: _pickDateOfBirth,
              icon: Icons.calendar_today_outlined,
            ),
            _label(l.internalEventMobile),
            AppPhoneNumberField(
              controller: _mobile,
              hintText: l.internalEventMobileHint,
              initialCountry: _mobileCountry,
              onCountryChanged: (country) => _mobileCountry = country,
              validator: (_) => _validatePhone(
                _mobileCountry,
                _mobile,
                l.internalEventMobileRequired,
              ),
            ),
            _label(l.email),
            _textField(
              _email,
              hint: l.internalEventEmailHint,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                final required = _required(l.internalEventEmailRequired)(value);
                if (required != null) return required;
                return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value!.trim())
                    ? null
                    : l.internalEventInvalidEmail;
              },
            ),
            _label(l.internalEventGender),
            _dropdown(
              value: _gender,
              hint: l.internalEventGenderHint,
              requiredMessage: l.internalEventGenderRequired,
              items: {
                'Male': l.profile_gender_male,
                'Female': l.profile_gender_female,
              },
              onChanged: (value) => setState(() => _gender = value),
            ),
            _label(l.internalEventNationality),
            _pickerField(
              value: _nationality,
              hint: l.internalEventNationalityHint,
              requiredMessage: l.internalEventNationalityRequired,
              onTap: _pickNationality,
              icon: Icons.keyboard_arrow_down,
            ),
            if (_nationality == _uaeNationality) ...[
              _label(l.internalEventCity),
              _dropdown(
                value: _city,
                hint: l.internalEventCityHint,
                requiredMessage: l.internalEventCityRequired,
                items: {for (final city in kInternalEventCities) city: city},
                onChanged: (value) => setState(() => _city = value),
              ),
            ],
            const SizedBox(height: 22),
            // Same size as the form title
            Text(
              l.emergencyContact,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            _label(l.internalEventEmergencyName),
            _textField(
              _emergencyName,
              hint: l.internalEventEmergencyNameHint,
              validator: _required(l.internalEventEmergencyNameRequired),
            ),
            _label(l.internalEventMobile),
            AppPhoneNumberField(
              controller: _emergencyMobile,
              hintText: l.internalEventMobileHint,
              initialCountry: _emergencyCountry,
              onCountryChanged: (country) => _emergencyCountry = country,
              validator: (_) => _validatePhone(
                _emergencyCountry,
                _emergencyMobile,
                l.internalEventEmergencyNumberRequired,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        l.internalEventSubmit,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Searchable list of the website's nationalities. Pops with the picked name.
class _NationalityPickerSheet extends StatefulWidget {
  const _NationalityPickerSheet();

  @override
  State<_NationalityPickerSheet> createState() =>
      _NationalityPickerSheetState();
}

class _NationalityPickerSheetState extends State<_NationalityPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final query = _query.trim().toLowerCase();
    final countries = kNationalityCountries
        .where((name) => name.toLowerCase().contains(query))
        .toList();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: l.internalEventNationalityHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(countries[index]),
                onTap: () => Navigator.pop(context, countries[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
