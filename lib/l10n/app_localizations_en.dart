// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get currentLocation => 'Current location';

  @override
  String get findRide => 'Find a ride';

  @override
  String get home_profileName => 'Ahmed Al Mansouri';

  @override
  String get home_profileLocation => 'Abu Dhabi City';

  @override
  String get home_currentLocationLabel => 'Current location';

  @override
  String home_weatherHighLow(Object high, Object low) {
    return 'H:$high°C   L:$low°C';
  }

  @override
  String get home_contentPlaceholder => 'Home Content';

  @override
  String get cityAbuDhabi => 'Abu Dhabi';

  @override
  String get highTemp => 'H';

  @override
  String get lowTemp => 'L';

  @override
  String get temperatureUnit => '°C';

  @override
  String get choose => 'Choose your';

  @override
  String get language => 'language';

  @override
  String get language_screen_title => 'WELCOME TO ABU\nDHABI CYCLING CLUB';

  @override
  String get language_label_english => 'ENGLISH';

  @override
  String get language_label_arabic => 'ARABIC';

  @override
  String get community_heading1 => 'Join the official';

  @override
  String get community_heading2 => 'Abu Dhabi Cycling Community';

  @override
  String get phone_action_card => 'Continue with phone';

  @override
  String get email_action_card => 'Enter your Email';

  @override
  String get create_button => 'Create Account';

  @override
  String get sign_in_option => 'Or sign in with';

  @override
  String get policy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get create_account_heading => 'Create your account';

  @override
  String get create_account_title => 'Join the cycling community today';

  @override
  String get phone_number_placeholder => 'Enter Your Mobile Number';

  @override
  String get continue_button => 'Continue';

  @override
  String get login_link => 'Already have an account? Login';

  @override
  String get error_required_number => 'Phone number is required';

  @override
  String get error_valid_number => 'Enter a valid phone number';
}
