import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @findRide.
  ///
  /// In en, this message translates to:
  /// **'Find a ride'**
  String get findRide;

  /// No description provided for @home_profileName.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Al Mansouri'**
  String get home_profileName;

  /// No description provided for @home_profileLocation.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi City'**
  String get home_profileLocation;

  /// No description provided for @home_currentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get home_currentLocationLabel;

  /// No description provided for @home_weatherHighLow.
  ///
  /// In en, this message translates to:
  /// **'H:{high}°C   L:{low}°C'**
  String home_weatherHighLow(Object high, Object low);

  /// No description provided for @home_contentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Home Content'**
  String get home_contentPlaceholder;

  /// No description provided for @cityAbuDhabi.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi'**
  String get cityAbuDhabi;

  /// No description provided for @highTemp.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get highTemp;

  /// No description provided for @lowTemp.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get lowTemp;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get temperatureUnit;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose your'**
  String get choose;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_screen_title.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO ABU\nDHABI CYCLING CLUB'**
  String get language_screen_title;

  /// No description provided for @language_label_english.
  ///
  /// In en, this message translates to:
  /// **'ENGLISH'**
  String get language_label_english;

  /// No description provided for @language_label_arabic.
  ///
  /// In en, this message translates to:
  /// **'ARABIC'**
  String get language_label_arabic;

  /// No description provided for @community_heading1.
  ///
  /// In en, this message translates to:
  /// **'Join the official'**
  String get community_heading1;

  /// No description provided for @community_heading2.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi Cycling Community'**
  String get community_heading2;

  /// No description provided for @phone_action_card.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone'**
  String get phone_action_card;

  /// No description provided for @email_action_card.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email'**
  String get email_action_card;

  /// No description provided for @create_button.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_button;

  /// No description provided for @sign_in_option.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get sign_in_option;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get policy;

  /// No description provided for @otp_verify_your_number.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Number'**
  String get otp_verify_your_number;

  /// No description provided for @otp_enter_code_sent.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to you'**
  String get otp_enter_code_sent;

  /// No description provided for @otp_sent_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'We have sent OTP on your mobile number'**
  String get otp_sent_mobile_number;

  /// No description provided for @otp_enter_valid_6_digit.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit OTP'**
  String get otp_enter_valid_6_digit;

  /// No description provided for @otp_resend_in.
  ///
  /// In en, this message translates to:
  /// **'Resend the OTP in '**
  String get otp_resend_in;

  /// No description provided for @otp_resend_now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get otp_resend_now;

  /// No description provided for @otp_seconds.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get otp_seconds;

  /// No description provided for @otp_resend_failed.
  ///
  /// In en, this message translates to:
  /// **'OTP resend failed'**
  String get otp_resend_failed;

  /// No description provided for @otp_failed_default.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get otp_failed_default;

  /// No description provided for @create_account_heading.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get create_account_heading;

  /// No description provided for @create_account_title.
  ///
  /// In en, this message translates to:
  /// **'Join the cycling community today'**
  String get create_account_title;

  /// No description provided for @phone_number_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile Number'**
  String get phone_number_placeholder;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @login_link.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get login_link;

  /// No description provided for @error_required_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get error_required_number;

  /// No description provided for @error_valid_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get error_valid_number;

  /// No description provided for @otp_too_many_attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many OTP attempts from this device. Please wait and try again later.'**
  String get otp_too_many_attempts;

  /// No description provided for @otp_failed.
  ///
  /// In en, this message translates to:
  /// **'OTP Failed'**
  String get otp_failed;

  /// No description provided for @google_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Google login failed'**
  String get google_login_failed;

  /// No description provided for @facebook_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Facebook login failed'**
  String get facebook_login_failed;

  /// No description provided for @error_prefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get error_prefix;

  /// No description provided for @login_to_your_account.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get login_to_your_account;

  /// No description provided for @or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or_continue_with;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dont_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @register_ride_connect.
  ///
  /// In en, this message translates to:
  /// **'Ride. Connect.'**
  String get register_ride_connect;

  /// No description provided for @register_join_community.
  ///
  /// In en, this message translates to:
  /// **'Join Abu Dhabi\'s premier cycling community App'**
  String get register_join_community;

  /// No description provided for @register_skip_continue_as.
  ///
  /// In en, this message translates to:
  /// **'Skip and continue as'**
  String get register_skip_continue_as;

  /// No description provided for @register_continue_with_mobile.
  ///
  /// In en, this message translates to:
  /// **'Continue With Mobile Number'**
  String get register_continue_with_mobile;

  /// No description provided for @register_continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get register_continue_as_guest;

  /// No description provided for @register_policy_text.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to ADCycling\'s Terms of Service\nand Privacy Policy'**
  String get register_policy_text;

  /// No description provided for @create_account_phone_prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue.\nWe will send an OTP for verification.'**
  String get create_account_phone_prompt;

  /// No description provided for @guest_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Guest login failed'**
  String get guest_login_failed;

  /// No description provided for @common_or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get common_or;

  /// No description provided for @profile_setup_title.
  ///
  /// In en, this message translates to:
  /// **'Set up your Profile'**
  String get profile_setup_title;

  /// No description provided for @profile_full_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get profile_full_name_hint;

  /// No description provided for @profile_full_name_required.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get profile_full_name_required;

  /// No description provided for @profile_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get profile_email_hint;

  /// No description provided for @profile_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get profile_email_required;

  /// No description provided for @profile_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get profile_email_invalid;

  /// No description provided for @profile_birth_date_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your birth date'**
  String get profile_birth_date_placeholder;

  /// No description provided for @profile_gender_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your Gender'**
  String get profile_gender_placeholder;

  /// No description provided for @profile_country_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your Country'**
  String get profile_country_placeholder;

  /// No description provided for @profile_city_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your City'**
  String get profile_city_placeholder;

  /// No description provided for @profile_cities_loading.
  ///
  /// In en, this message translates to:
  /// **'Cities are still loading'**
  String get profile_cities_loading;

  /// No description provided for @profile_gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profile_gender_male;

  /// No description provided for @profile_gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profile_gender_female;

  /// No description provided for @profile_gender_prefer_not_to_say.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get profile_gender_prefer_not_to_say;

  /// No description provided for @profile_country_uae.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get profile_country_uae;

  /// No description provided for @profile_country_saudi_arabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get profile_country_saudi_arabia;

  /// No description provided for @profile_country_qatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get profile_country_qatar;

  /// No description provided for @profile_country_oman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get profile_country_oman;

  /// No description provided for @profile_country_kuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get profile_country_kuwait;

  /// No description provided for @profile_country_bahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get profile_country_bahrain;

  /// No description provided for @profile_terms_prefix.
  ///
  /// In en, this message translates to:
  /// **'I\'ve read and agreed to '**
  String get profile_terms_prefix;

  /// No description provided for @profile_terms_and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get profile_terms_and;

  /// No description provided for @profile_terms_user_agreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get profile_terms_user_agreement;

  /// No description provided for @profile_terms_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profile_terms_privacy_policy;

  /// No description provided for @profile_select_birth_date.
  ///
  /// In en, this message translates to:
  /// **'Please select your birth date'**
  String get profile_select_birth_date;

  /// No description provided for @profile_select_gender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get profile_select_gender;

  /// No description provided for @profile_select_country.
  ///
  /// In en, this message translates to:
  /// **'Please select your country'**
  String get profile_select_country;

  /// No description provided for @profile_select_city.
  ///
  /// In en, this message translates to:
  /// **'Please select your city'**
  String get profile_select_city;

  /// No description provided for @profile_accept_terms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions to continue.'**
  String get profile_accept_terms;

  /// No description provided for @profile_registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get profile_registration_failed;

  /// No description provided for @event_registration_only_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Event registration is available only for logged in users.'**
  String get event_registration_only_logged_in;

  /// No description provided for @login_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get login_to_continue;

  /// No description provided for @event_id_missing_message.
  ///
  /// In en, this message translates to:
  /// **'Event ID missing. Please open the event from its details page.'**
  String get event_id_missing_message;

  /// No description provided for @common_go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get common_go_back;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @you_already_registered_for_event.
  ///
  /// In en, this message translates to:
  /// **'You are already registered for this event.'**
  String get you_already_registered_for_event;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @field_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get field_full_name;

  /// No description provided for @field_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address *'**
  String get field_email_address;

  /// No description provided for @field_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get field_phone_number;

  /// No description provided for @field_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group *'**
  String get field_blood_group;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get select_country;

  /// No description provided for @cycling_information.
  ///
  /// In en, this message translates to:
  /// **'Cycling Information'**
  String get cycling_information;

  /// No description provided for @field_have_bike.
  ///
  /// In en, this message translates to:
  /// **'Do you have your own bike?'**
  String get field_have_bike;

  /// No description provided for @field_bike_type.
  ///
  /// In en, this message translates to:
  /// **'Bike Type *'**
  String get field_bike_type;

  /// No description provided for @select_bike_type.
  ///
  /// In en, this message translates to:
  /// **'Select bike type'**
  String get select_bike_type;

  /// No description provided for @select_option.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get select_option;

  /// No description provided for @event_id_not_found.
  ///
  /// In en, this message translates to:
  /// **'Event ID not found. Please reopen the event.'**
  String get event_id_not_found;

  /// No description provided for @complete_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required selections.'**
  String get complete_required_fields;

  /// No description provided for @please_select_have_bike.
  ///
  /// In en, this message translates to:
  /// **'Please select whether you have your own bike.'**
  String get please_select_have_bike;

  /// No description provided for @already_joined_for_event.
  ///
  /// In en, this message translates to:
  /// **'You are already joined for this event.'**
  String get already_joined_for_event;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @unable_to_load_product_details.
  ///
  /// In en, this message translates to:
  /// **'Unable to load product details.'**
  String get unable_to_load_product_details;

  /// No description provided for @community_details.
  ///
  /// In en, this message translates to:
  /// **'Community Details'**
  String get community_details;

  /// No description provided for @unable_to_load_community_details.
  ///
  /// In en, this message translates to:
  /// **'Unable to load community details.'**
  String get unable_to_load_community_details;

  /// No description provided for @location_services_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them.'**
  String get location_services_disabled;

  /// No description provided for @location_permissions_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get location_permissions_denied;

  /// No description provided for @location_permissions_permanently_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied. Please enable them in settings.'**
  String get location_permissions_permanently_denied;

  /// No description provided for @delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account_title;

  /// No description provided for @deleting_account.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deleting_account;

  /// No description provided for @delete_account_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot be undone.'**
  String get delete_account_message;

  /// No description provided for @delete_account_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_account_cancel;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_account_confirm;

  /// No description provided for @account_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get account_deleted_successfully;

  /// No description provided for @failed_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get failed_delete_account;

  /// No description provided for @challenge_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Challenge Complete!'**
  String get challenge_complete_title;

  /// No description provided for @challenge_difficulty_question.
  ///
  /// In en, this message translates to:
  /// **'How was the difficulty?'**
  String get challenge_difficulty_question;

  /// No description provided for @challenge_difficulty_too_easy.
  ///
  /// In en, this message translates to:
  /// **'Too Easy'**
  String get challenge_difficulty_too_easy;

  /// No description provided for @challenge_difficulty_just_right.
  ///
  /// In en, this message translates to:
  /// **'Just Right'**
  String get challenge_difficulty_just_right;

  /// No description provided for @challenge_difficulty_too_hard.
  ///
  /// In en, this message translates to:
  /// **'Too Hard'**
  String get challenge_difficulty_too_hard;

  /// No description provided for @challenge_rate_experience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get challenge_rate_experience;

  /// No description provided for @challenge_how_was_your_experience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get challenge_how_was_your_experience;

  /// No description provided for @challenge_enjoyment_question.
  ///
  /// In en, this message translates to:
  /// **'What did you enjoy?'**
  String get challenge_enjoyment_question;

  /// No description provided for @challenge_enjoyment_great_challenge.
  ///
  /// In en, this message translates to:
  /// **'Great Challenge'**
  String get challenge_enjoyment_great_challenge;

  /// No description provided for @challenge_enjoyment_perfect_difficulty.
  ///
  /// In en, this message translates to:
  /// **'Perfect Difficulty'**
  String get challenge_enjoyment_perfect_difficulty;

  /// No description provided for @challenge_enjoyment_motivating.
  ///
  /// In en, this message translates to:
  /// **'Motivating'**
  String get challenge_enjoyment_motivating;

  /// No description provided for @challenge_enjoyment_achievable_goals.
  ///
  /// In en, this message translates to:
  /// **'Achievable Goals'**
  String get challenge_enjoyment_achievable_goals;

  /// No description provided for @challenge_additional_thoughts.
  ///
  /// In en, this message translates to:
  /// **'Additional Thoughts'**
  String get challenge_additional_thoughts;

  /// No description provided for @challenge_thoughts_hint.
  ///
  /// In en, this message translates to:
  /// **'Share details about your experience.'**
  String get challenge_thoughts_hint;

  /// No description provided for @challenge_achievements_unlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievements Unlocked'**
  String get challenge_achievements_unlocked;

  /// No description provided for @challenge_badge_completed.
  ///
  /// In en, this message translates to:
  /// **'Challenge Completed'**
  String get challenge_badge_completed;

  /// No description provided for @challenge_completed_title.
  ///
  /// In en, this message translates to:
  /// **'You completed \"{challengeTitle}\"'**
  String challenge_completed_title(Object challengeTitle);

  /// No description provided for @challenge_reward_points_value.
  ///
  /// In en, this message translates to:
  /// **'+{rewardPoints} Reward Points'**
  String challenge_reward_points_value(Object rewardPoints);

  /// No description provided for @challenge_reward_points_missing.
  ///
  /// In en, this message translates to:
  /// **'nulled Reward Points'**
  String get challenge_reward_points_missing;

  /// No description provided for @challenge_reward_points_added.
  ///
  /// In en, this message translates to:
  /// **'Added to your account'**
  String get challenge_reward_points_added;

  /// No description provided for @challenge_reward_badge_title.
  ///
  /// In en, this message translates to:
  /// **'Reward Badge'**
  String get challenge_reward_badge_title;

  /// No description provided for @challenge_reward_badge_description.
  ///
  /// In en, this message translates to:
  /// **'You earned a reward for completing this challenge.'**
  String get challenge_reward_badge_description;

  /// No description provided for @challenge_share_button.
  ///
  /// In en, this message translates to:
  /// **'Share Your Challenge'**
  String get challenge_share_button;

  /// No description provided for @challenge_share_subject.
  ///
  /// In en, this message translates to:
  /// **'Check out my challenge on ADCC'**
  String get challenge_share_subject;

  /// No description provided for @challenge_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get challenge_joined;

  /// No description provided for @challenge_join_now.
  ///
  /// In en, this message translates to:
  /// **'Join Challenge'**
  String get challenge_join_now;

  /// No description provided for @challenge_mark_complete.
  ///
  /// In en, this message translates to:
  /// **'Mark as complete'**
  String get challenge_mark_complete;

  /// No description provided for @challenge_progress_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Progress incomplete'**
  String get challenge_progress_incomplete;

  /// No description provided for @challenge_join_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to join challenge'**
  String get challenge_join_failed;

  /// No description provided for @challenge_complete_requirement.
  ///
  /// In en, this message translates to:
  /// **'You can only mark the challenge complete after you reach the target progress.'**
  String get challenge_complete_requirement;

  /// No description provided for @challenge_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update challenge progress'**
  String get challenge_update_failed;

  /// No description provided for @challenge_registered_title.
  ///
  /// In en, this message translates to:
  /// **'You\'re registered!'**
  String get challenge_registered_title;

  /// No description provided for @challenge_registered_message.
  ///
  /// In en, this message translates to:
  /// **'You joined \"{title}\" successfully. Get ready for the challenge!'**
  String challenge_registered_message(Object title);

  /// No description provided for @challenge_view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get challenge_view_all;

  /// No description provided for @challenge_no_performers.
  ///
  /// In en, this message translates to:
  /// **'No performers yet. Join the challenge to appear here.'**
  String get challenge_no_performers;

  /// No description provided for @challenge_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get challenge_progress;

  /// No description provided for @challenge_days_left.
  ///
  /// In en, this message translates to:
  /// **'{daysLeft} days left'**
  String challenge_days_left(Object daysLeft);

  /// No description provided for @challenge_joined_label.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get challenge_joined_label;

  /// No description provided for @challenge_days_left_label.
  ///
  /// In en, this message translates to:
  /// **'Days Left'**
  String get challenge_days_left_label;

  /// No description provided for @challenge_points_label.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get challenge_points_label;

  /// No description provided for @challenge_active_challenges.
  ///
  /// In en, this message translates to:
  /// **'Active Challenges'**
  String get challenge_active_challenges;

  /// No description provided for @challenge_leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get challenge_leaderboard;

  /// No description provided for @challenge_search_events.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get challenge_search_events;

  /// No description provided for @challenge_no_active_challenges.
  ///
  /// In en, this message translates to:
  /// **'No active challenges found'**
  String get challenge_no_active_challenges;

  /// No description provided for @challenge_no_recent_challenges.
  ///
  /// In en, this message translates to:
  /// **'No recent challenges'**
  String get challenge_no_recent_challenges;

  /// No description provided for @challenge_recent_challenges.
  ///
  /// In en, this message translates to:
  /// **'Recent Challenges'**
  String get challenge_recent_challenges;

  /// No description provided for @challenge_connect_devices.
  ///
  /// In en, this message translates to:
  /// **'Connect Devices'**
  String get challenge_connect_devices;

  /// No description provided for @challenge_top_riders_this_month.
  ///
  /// In en, this message translates to:
  /// **'Top riders this month'**
  String get challenge_top_riders_this_month;

  /// No description provided for @challenge_no_riders_found.
  ///
  /// In en, this message translates to:
  /// **'No riders found'**
  String get challenge_no_riders_found;

  /// No description provided for @challenge_your_month_stats.
  ///
  /// In en, this message translates to:
  /// **'Your {monthName} Stats'**
  String challenge_your_month_stats(Object monthName);

  /// No description provided for @challenge_total_km.
  ///
  /// In en, this message translates to:
  /// **'Total KM'**
  String get challenge_total_km;

  /// No description provided for @challenge_rides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get challenge_rides;

  /// No description provided for @challenge_rank_change.
  ///
  /// In en, this message translates to:
  /// **'Rank Change'**
  String get challenge_rank_change;

  /// No description provided for @my_challenges_title.
  ///
  /// In en, this message translates to:
  /// **'My challenges'**
  String get my_challenges_title;

  /// No description provided for @my_challenges_no_challenges.
  ///
  /// In en, this message translates to:
  /// **'No challenges yet'**
  String get my_challenges_no_challenges;

  /// No description provided for @challenge_tab_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get challenge_tab_completed;

  /// No description provided for @challenge_tab_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get challenge_tab_upcoming;

  /// No description provided for @challenge_tab_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get challenge_tab_cancelled;

  /// No description provided for @cart_title.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cart_title;

  /// No description provided for @removed_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Removed from cart'**
  String get removed_from_cart;

  /// No description provided for @cart_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Add items from the club store and review them here before checkout.'**
  String get cart_empty_message;

  /// No description provided for @cart_continue_shopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get cart_continue_shopping;

  /// No description provided for @checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout_title;

  /// No description provided for @order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get order_summary;

  /// No description provided for @delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get delivery_address;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @order_notes.
  ///
  /// In en, this message translates to:
  /// **'Order Notes'**
  String get order_notes;

  /// No description provided for @price_details.
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get price_details;

  /// No description provided for @cart_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get cart_empty_title;

  /// No description provided for @order_place_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get order_place_failed;

  /// No description provided for @payment_credit_title.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get payment_credit_title;

  /// No description provided for @payment_credit_sub.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, AMEX'**
  String get payment_credit_sub;

  /// No description provided for @payment_apple_title.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get payment_apple_title;

  /// No description provided for @payment_apple_sub.
  ///
  /// In en, this message translates to:
  /// **'Touch ID / Face ID'**
  String get payment_apple_sub;

  /// No description provided for @payment_tabby_title.
  ///
  /// In en, this message translates to:
  /// **'Tabby – Pay in 4'**
  String get payment_tabby_title;

  /// No description provided for @payment_tabby_sub.
  ///
  /// In en, this message translates to:
  /// **'Split into 4 payments'**
  String get payment_tabby_sub;

  /// No description provided for @payment_cod_title.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get payment_cod_title;

  /// No description provided for @payment_cod_sub.
  ///
  /// In en, this message translates to:
  /// **'Pay when you receive'**
  String get payment_cod_sub;

  /// No description provided for @checkout_place_order.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get checkout_place_order;

  /// No description provided for @checkout_terms.
  ///
  /// In en, this message translates to:
  /// **'By placing your order you agree to ADCC\'s Terms & Conditions'**
  String get checkout_terms;

  /// No description provided for @club_store_title.
  ///
  /// In en, this message translates to:
  /// **'Club Store'**
  String get club_store_title;

  /// No description provided for @club_store_home.
  ///
  /// In en, this message translates to:
  /// **'Club Store Home'**
  String get club_store_home;

  /// No description provided for @color_not_set.
  ///
  /// In en, this message translates to:
  /// **'Color not set'**
  String get color_not_set;

  /// No description provided for @size_not_set.
  ///
  /// In en, this message translates to:
  /// **'Size not set'**
  String get size_not_set;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @checkout_with_count.
  ///
  /// In en, this message translates to:
  /// **'Checkout ({count})'**
  String checkout_with_count(Object count);

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeLabel;

  /// No description provided for @selectedVariantOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Selected variant is out of stock.'**
  String get selectedVariantOutOfStock;

  /// No description provided for @maxAvailableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Maximum available quantity is {count}.'**
  String maxAvailableQuantity(Object count);

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart successfully'**
  String get addedToCart;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescriptionAvailable;

  /// No description provided for @specificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specificationsLabel;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @featureFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get featureFreeDelivery;

  /// No description provided for @featureFreeDeliverySub.
  ///
  /// In en, this message translates to:
  /// **'Above 200'**
  String get featureFreeDeliverySub;

  /// No description provided for @featureEasyReturns.
  ///
  /// In en, this message translates to:
  /// **'Easy Returns'**
  String get featureEasyReturns;

  /// No description provided for @featureEasyReturnsSub.
  ///
  /// In en, this message translates to:
  /// **'7-day policy'**
  String get featureEasyReturnsSub;

  /// No description provided for @featureAuthentic.
  ///
  /// In en, this message translates to:
  /// **'Authentic'**
  String get featureAuthentic;

  /// No description provided for @featureAuthenticSub.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get featureAuthenticSub;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity :'**
  String get quantityLabel;

  /// No description provided for @addToCartLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCartLabel;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed!'**
  String get orderConfirmedTitle;

  /// No description provided for @thankYouForShopping.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with ADCC'**
  String get thankYouForShopping;

  /// No description provided for @productVariantInfo.
  ///
  /// In en, this message translates to:
  /// **'{color} · {size} · Qty {quantity}'**
  String productVariantInfo(Object color, Object quantity, Object size);

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @cardEnding.
  ///
  /// In en, this message translates to:
  /// **'Card ending'**
  String get cardEnding;

  /// No description provided for @orderNote.
  ///
  /// In en, this message translates to:
  /// **'Order Note'**
  String get orderNote;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderNumber}'**
  String orderNumber(Object orderNumber);

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @failedToLoadMerchandise.
  ///
  /// In en, this message translates to:
  /// **'Failed to load merchandise. Please try again.'**
  String get failedToLoadMerchandise;

  /// No description provided for @latestProducts.
  ///
  /// In en, this message translates to:
  /// **'Latest Products'**
  String get latestProducts;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @community_store.
  ///
  /// In en, this message translates to:
  /// **'Community Store'**
  String get community_store;

  /// No description provided for @recentlyPosted.
  ///
  /// In en, this message translates to:
  /// **'Recently Posted'**
  String get recentlyPosted;

  /// No description provided for @noMorePosts.
  ///
  /// In en, this message translates to:
  /// **'No more posts'**
  String get noMorePosts;

  /// No description provided for @swipeBrowsePosts.
  ///
  /// In en, this message translates to:
  /// **'Swipe left or right to browse posts.'**
  String get swipeBrowsePosts;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'LIKE'**
  String get like;

  /// No description provided for @nope.
  ///
  /// In en, this message translates to:
  /// **'NOPE'**
  String get nope;

  /// No description provided for @noClubMerchandiseFound.
  ///
  /// In en, this message translates to:
  /// **'No club merchandise found.'**
  String get noClubMerchandiseFound;

  /// No description provided for @featuredProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// No description provided for @noFeaturedProducts.
  ///
  /// In en, this message translates to:
  /// **'No featured products available.'**
  String get noFeaturedProducts;

  /// No description provided for @merchandiseComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Merchandise coming soon'**
  String get merchandiseComingSoon;

  /// No description provided for @merchandiseHelpText.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar and category chips above to explore club store items.'**
  String get merchandiseHelpText;

  /// No description provided for @clubMerchandiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Club Merchandise'**
  String get clubMerchandiseTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search events, communities, cities, or tracks...'**
  String get searchHint;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @viewStore.
  ///
  /// In en, this message translates to:
  /// **'View store'**
  String get viewStore;

  /// No description provided for @allProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProductsTitle;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @exploreCommunity.
  ///
  /// In en, this message translates to:
  /// **'Explore Community →'**
  String get exploreCommunity;

  /// No description provided for @membersLabel.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get membersLabel;

  /// No description provided for @eventsLabel.
  ///
  /// In en, this message translates to:
  /// **'events'**
  String get eventsLabel;

  /// No description provided for @categoryWomen.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get categoryWomen;

  /// No description provided for @categoryYouth.
  ///
  /// In en, this message translates to:
  /// **'Youth'**
  String get categoryYouth;

  /// No description provided for @categoryEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get categoryEndurance;

  /// No description provided for @categoryFamilySocial.
  ///
  /// In en, this message translates to:
  /// **'Family / Social'**
  String get categoryFamilySocial;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @categoryRacing.
  ///
  /// In en, this message translates to:
  /// **'Racing'**
  String get categoryRacing;

  /// No description provided for @welcomeToCommunity.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Community!'**
  String get welcomeToCommunity;

  /// No description provided for @youHaveSuccessfullyJoined.
  ///
  /// In en, this message translates to:
  /// **'You have successfully joined'**
  String get youHaveSuccessfullyJoined;

  /// No description provided for @whatsNext.
  ///
  /// In en, this message translates to:
  /// **'What\'s Next?'**
  String get whatsNext;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications feature coming soon'**
  String get notificationsComingSoon;

  /// No description provided for @joinCommunityChats.
  ///
  /// In en, this message translates to:
  /// **'Join Community Chats'**
  String get joinCommunityChats;

  /// No description provided for @chatComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Chat feature coming soon'**
  String get chatComingSoon;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get startExploring;

  /// No description provided for @communityDescription.
  ///
  /// In en, this message translates to:
  /// **'The main cycling community in {location}, bringing together...'**
  String communityDescription(Object location);

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @login_required_title.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get login_required_title;

  /// No description provided for @login_required_message.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access this feature.'**
  String get login_required_message;

  /// No description provided for @discover_adcc.
  ///
  /// In en, this message translates to:
  /// **'Discover ADCC'**
  String get discover_adcc;

  /// No description provided for @explore_button.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore_button;

  /// No description provided for @welcome_guest.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Guest'**
  String get welcome_guest;

  /// No description provided for @could_not_load_feed.
  ///
  /// In en, this message translates to:
  /// **'Could not load feed'**
  String get could_not_load_feed;

  /// No description provided for @ride_in_abu_dhabi.
  ///
  /// In en, this message translates to:
  /// **'Ride in Abu Dhabi'**
  String get ride_in_abu_dhabi;

  /// No description provided for @ride_in_city.
  ///
  /// In en, this message translates to:
  /// **'Ride in {city}'**
  String ride_in_city(Object city);

  /// No description provided for @pleaseSelectReasonForLeaving.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for leaving'**
  String get pleaseSelectReasonForLeaving;

  /// No description provided for @youHaveLeftTheCommunity.
  ///
  /// In en, this message translates to:
  /// **'You have left the community'**
  String get youHaveLeftTheCommunity;

  /// No description provided for @failedToLeaveCommunity.
  ///
  /// In en, this message translates to:
  /// **'Failed to leave community'**
  String get failedToLeaveCommunity;

  /// No description provided for @leaveCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Community'**
  String get leaveCommunityTitle;

  /// No description provided for @leaveCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go.\nYour feedback helps us improve.'**
  String get leaveCommunitySubtitle;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason:'**
  String get reasonLabel;

  /// No description provided for @additionalFeedback.
  ///
  /// In en, this message translates to:
  /// **'Additional feedback'**
  String get additionalFeedback;

  /// No description provided for @tellUsMoreHint.
  ///
  /// In en, this message translates to:
  /// **'Tell Us More....'**
  String get tellUsMoreHint;

  /// No description provided for @leaving.
  ///
  /// In en, this message translates to:
  /// **'Leaving...'**
  String get leaving;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @reasonNotActiveAnymore.
  ///
  /// In en, this message translates to:
  /// **'Not Active Anymore'**
  String get reasonNotActiveAnymore;

  /// No description provided for @reasonScheduleConflict.
  ///
  /// In en, this message translates to:
  /// **'Schedule Conflict'**
  String get reasonScheduleConflict;

  /// No description provided for @reasonNotMatchingInterest.
  ///
  /// In en, this message translates to:
  /// **'Community Not Matching My Interest'**
  String get reasonNotMatchingInterest;

  /// No description provided for @reasonFoundAnotherCommunity.
  ///
  /// In en, this message translates to:
  /// **'Found Another Community'**
  String get reasonFoundAnotherCommunity;

  /// No description provided for @reasonTemporaryBreak.
  ///
  /// In en, this message translates to:
  /// **'Temporary Break'**
  String get reasonTemporaryBreak;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonOther;

  /// No description provided for @myCommunitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Communities'**
  String get myCommunitiesTitle;

  /// No description provided for @noCommunitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No communities found'**
  String get noCommunitiesFound;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @communityLabel.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @trackLabel.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get trackLabel;

  /// No description provided for @organizedBy.
  ///
  /// In en, this message translates to:
  /// **'Organized By'**
  String get organizedBy;

  /// No description provided for @viewCommunity.
  ///
  /// In en, this message translates to:
  /// **'View Community'**
  String get viewCommunity;

  /// No description provided for @eventSchedule.
  ///
  /// In en, this message translates to:
  /// **'Event Schedule'**
  String get eventSchedule;

  /// No description provided for @participantsPreview.
  ///
  /// In en, this message translates to:
  /// **'Participants Preview'**
  String get participantsPreview;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @ridersRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} riders registered'**
  String ridersRegistered(Object count);

  /// No description provided for @loginToRegister.
  ///
  /// In en, this message translates to:
  /// **'Login to register'**
  String get loginToRegister;

  /// No description provided for @viewPastResult.
  ///
  /// In en, this message translates to:
  /// **'View Past Result'**
  String get viewPastResult;

  /// No description provided for @joinEvent.
  ///
  /// In en, this message translates to:
  /// **'Join Event'**
  String get joinEvent;

  /// No description provided for @guestCannotRegister.
  ///
  /// In en, this message translates to:
  /// **'Guests cannot access event registration. Please login to continue.'**
  String get guestCannotRegister;

  /// No description provided for @cancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cancelled successfully'**
  String get cancelledSuccessfully;

  /// No description provided for @cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Registration'**
  String get cancelRegistration;

  /// No description provided for @aboutThisEvent.
  ///
  /// In en, this message translates to:
  /// **'About this Event'**
  String get aboutThisEvent;

  /// No description provided for @quickInfo.
  ///
  /// In en, this message translates to:
  /// **'Quick Info'**
  String get quickInfo;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @maxRidersLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Riders'**
  String get maxRidersLabel;

  /// No description provided for @registeredLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registeredLabel;

  /// No description provided for @registrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registrationLabel;

  /// No description provided for @whoCanJoin.
  ///
  /// In en, this message translates to:
  /// **'Who Can Join'**
  String get whoCanJoin;

  /// No description provided for @ageWithPlus.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}+'**
  String ageWithPlus(Object age);

  /// No description provided for @helmetRequired.
  ///
  /// In en, this message translates to:
  /// **'Helmet required'**
  String get helmetRequired;

  /// No description provided for @helmetNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Helmet not required'**
  String get helmetNotRequired;

  /// No description provided for @roadBikeMandatory.
  ///
  /// In en, this message translates to:
  /// **'Road Bike\nMandatory'**
  String get roadBikeMandatory;

  /// No description provided for @roadBikeNotMandatory.
  ///
  /// In en, this message translates to:
  /// **'Road bike not mandatory'**
  String get roadBikeNotMandatory;

  /// No description provided for @experienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience: {level}'**
  String experienceLabel(Object level);

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender: {gender}'**
  String genderLabel(Object gender);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @rewardsAndBadges.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Badges'**
  String get rewardsAndBadges;

  /// No description provided for @requiredGear.
  ///
  /// In en, this message translates to:
  /// **'Required Gear'**
  String get requiredGear;

  /// No description provided for @helmetMandatory.
  ///
  /// In en, this message translates to:
  /// **'Helmet\n(Mandatory)'**
  String get helmetMandatory;

  /// No description provided for @helmetRecommended.
  ///
  /// In en, this message translates to:
  /// **'Helmet\n(Recommended)'**
  String get helmetRecommended;

  /// No description provided for @frontRearLights.
  ///
  /// In en, this message translates to:
  /// **'Front & Rear\nLights'**
  String get frontRearLights;

  /// No description provided for @roadBikeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Road Bike\nRecommended'**
  String get roadBikeRecommended;

  /// No description provided for @waterBottles.
  ///
  /// In en, this message translates to:
  /// **'Water\nBottles'**
  String get waterBottles;

  /// No description provided for @doYouHaveBike.
  ///
  /// In en, this message translates to:
  /// **'Do you have a bike?'**
  String get doYouHaveBike;

  /// No description provided for @races.
  ///
  /// In en, this message translates to:
  /// **'Races'**
  String get races;

  /// No description provided for @communityRides.
  ///
  /// In en, this message translates to:
  /// **'Community\nRides'**
  String get communityRides;

  /// No description provided for @trainingClinics.
  ///
  /// In en, this message translates to:
  /// **'Training &\nClinics'**
  String get trainingClinics;

  /// No description provided for @awarenessRides.
  ///
  /// In en, this message translates to:
  /// **'Awareness\nRides'**
  String get awarenessRides;

  /// No description provided for @corporateEvents.
  ///
  /// In en, this message translates to:
  /// **'Corporate\nEvents'**
  String get corporateEvents;

  /// No description provided for @nationalEvents.
  ///
  /// In en, this message translates to:
  /// **'National\nEvents'**
  String get nationalEvents;

  /// No description provided for @eventsByCategory.
  ///
  /// In en, this message translates to:
  /// **'Events by Category'**
  String get eventsByCategory;

  /// No description provided for @communityHighlights.
  ///
  /// In en, this message translates to:
  /// **'Community Highlights'**
  String get communityHighlights;

  /// No description provided for @eventsTab.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTab;

  /// No description provided for @tracksTab.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tracksTab;

  /// No description provided for @galleryTab.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryTab;

  /// No description provided for @updatesTab.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updatesTab;

  /// No description provided for @foundedLabel.
  ///
  /// In en, this message translates to:
  /// **'Founded'**
  String get foundedLabel;

  /// No description provided for @activeMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Members'**
  String get activeMembersLabel;

  /// No description provided for @trackDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Track Distance'**
  String get trackDistanceLabel;

  /// No description provided for @averageRideRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Ride Rating'**
  String get averageRideRatingLabel;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsFound;

  /// No description provided for @eventsByCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Competitive cycling events organized by ADCC communities'**
  String get eventsByCategorySubtitle;

  /// No description provided for @communityRidesSingle.
  ///
  /// In en, this message translates to:
  /// **'Community Ride'**
  String get communityRidesSingle;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get noUpcomingEvents;

  /// No description provided for @familyAndKids.
  ///
  /// In en, this message translates to:
  /// **'Family & Kids'**
  String get familyAndKids;

  /// No description provided for @corporateShort.
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get corporateShort;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @emergencyContactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name *'**
  String get emergencyContactNameLabel;

  /// No description provided for @emergencyContactNameHint.
  ///
  /// In en, this message translates to:
  /// **'Contact person name'**
  String get emergencyContactNameHint;

  /// No description provided for @emergencyContactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone *'**
  String get emergencyContactPhoneLabel;

  /// No description provided for @emergencyContactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+971 50 123 4567'**
  String get emergencyContactPhoneHint;

  /// No description provided for @unknownEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Test demo'**
  String get unknownEventTitle;

  /// No description provided for @unknownEventLocation.
  ///
  /// In en, this message translates to:
  /// **'test demo'**
  String get unknownEventLocation;

  /// No description provided for @whenLabel.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get whenLabel;

  /// No description provided for @defaultCity.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi'**
  String get defaultCity;

  /// No description provided for @joinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joinedLabel;

  /// No description provided for @defaultDate.
  ///
  /// In en, this message translates to:
  /// **'18 July 2026'**
  String get defaultDate;

  /// No description provided for @backToEvent.
  ///
  /// In en, this message translates to:
  /// **'Back to Event'**
  String get backToEvent;

  /// No description provided for @checkYourEventSchedule.
  ///
  /// In en, this message translates to:
  /// **'Check your Event\nSchedule'**
  String get checkYourEventSchedule;

  /// No description provided for @chooseDateHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a date to see what is happening next.'**
  String get chooseDateHint;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @failedToLoadJoinedEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load joined events'**
  String get failedToLoadJoinedEvents;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get filterThisWeek;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get filterThisMonth;

  /// No description provided for @filterLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get filterLater;

  /// No description provided for @failedToLoadUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load upcoming events'**
  String get failedToLoadUpcomingEvents;

  /// No description provided for @upcomingEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The next rides, races, and training sessions on the ADCC calendar'**
  String get upcomingEventsSubtitle;

  /// No description provided for @noRewardsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rewards available'**
  String get noRewardsAvailable;

  /// No description provided for @riderCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Rider Check-in'**
  String get riderCheckIn;

  /// No description provided for @safetyBriefing.
  ///
  /// In en, this message translates to:
  /// **'Safety briefing'**
  String get safetyBriefing;

  /// No description provided for @raceStart.
  ///
  /// In en, this message translates to:
  /// **'Race start'**
  String get raceStart;

  /// No description provided for @finalLap.
  ///
  /// In en, this message translates to:
  /// **'Final lap'**
  String get finalLap;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @awardsCeremony.
  ///
  /// In en, this message translates to:
  /// **'Awards ceremony'**
  String get awardsCeremony;

  /// No description provided for @facilityWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get facilityWater;

  /// No description provided for @facilityToilets.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get facilityToilets;

  /// No description provided for @facilityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get facilityParking;

  /// No description provided for @facilityMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get facilityMedical;

  /// No description provided for @facilityLights.
  ///
  /// In en, this message translates to:
  /// **'Lights'**
  String get facilityLights;

  /// No description provided for @communityInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Community information not available'**
  String get communityInfoNotAvailable;

  /// No description provided for @invalidCommunityId.
  ///
  /// In en, this message translates to:
  /// **'Invalid community ID'**
  String get invalidCommunityId;

  /// No description provided for @failedToLoadCommunity.
  ///
  /// In en, this message translates to:
  /// **'Failed to load community'**
  String get failedToLoadCommunity;

  /// No description provided for @pleaseSignInToJoinCommunities.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to join communities.'**
  String get pleaseSignInToJoinCommunities;

  /// No description provided for @communityJoinedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Community joined successfully! 🎉'**
  String get communityJoinedSuccessfully;

  /// No description provided for @joinFailed.
  ///
  /// In en, this message translates to:
  /// **'Join failed'**
  String get joinFailed;

  /// No description provided for @communityLeftSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Community left successfully'**
  String get communityLeftSuccessfully;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @joinChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get joinChecking;

  /// No description provided for @community_no_upcoming_events.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events for this community'**
  String get community_no_upcoming_events;

  /// No description provided for @community_no_gallery_images.
  ///
  /// In en, this message translates to:
  /// **'No gallery images available'**
  String get community_no_gallery_images;

  /// No description provided for @community_no_track_data.
  ///
  /// In en, this message translates to:
  /// **'No track data available'**
  String get community_no_track_data;

  /// No description provided for @community_no_updates.
  ///
  /// In en, this message translates to:
  /// **'No community updates yet'**
  String get community_no_updates;

  /// No description provided for @pleaseSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get pleaseSelectReason;

  /// No description provided for @cancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Cancel failed'**
  String get cancelFailed;

  /// No description provided for @cancelRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please let us know why you\'re\ncancelling'**
  String get cancelRegistrationSubtitle;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @noLeaderboardData.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data available yet'**
  String get noLeaderboardData;

  /// No description provided for @failedToLoadEventDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load event details.'**
  String get failedToLoadEventDetails;

  /// No description provided for @failedToLoadEventOrProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load event or profile data. Please try again.'**
  String get failedToLoadEventOrProfile;

  /// No description provided for @failedToCompleteRegistration.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete registration.'**
  String get failedToCompleteRegistration;

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get hintFullName;

  /// No description provided for @hintEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get hintEmailAddress;

  /// No description provided for @hintPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get hintPhoneNumber;

  /// No description provided for @pleaseSelectBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Please select blood group'**
  String get pleaseSelectBloodGroup;

  /// No description provided for @countryLabel2.
  ///
  /// In en, this message translates to:
  /// **'Country *'**
  String get countryLabel2;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @bikeTypeRoad.
  ///
  /// In en, this message translates to:
  /// **'Road Bike'**
  String get bikeTypeRoad;

  /// No description provided for @bikeTypeMountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain Bike'**
  String get bikeTypeMountain;

  /// No description provided for @bikeTypeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid Bike'**
  String get bikeTypeHybrid;

  /// No description provided for @alreadyJoined.
  ///
  /// In en, this message translates to:
  /// **'Already Joined'**
  String get alreadyJoined;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @joinEventTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms and confirm that all information\nprovided is accurate. I understand the safety\nrequirements and will comply with all event guidelines.'**
  String get joinEventTerms;

  /// No description provided for @purposeBasedEvents.
  ///
  /// In en, this message translates to:
  /// **'Purpose Based Events'**
  String get purposeBasedEvents;

  /// No description provided for @noPurposeBasedEvents.
  ///
  /// In en, this message translates to:
  /// **'No purpose-based events found'**
  String get noPurposeBasedEvents;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @ownBike.
  ///
  /// In en, this message translates to:
  /// **'Own Bike'**
  String get ownBike;

  /// No description provided for @bikeType.
  ///
  /// In en, this message translates to:
  /// **'Bike Type'**
  String get bikeType;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get emergencyPhone;

  /// No description provided for @youAreRegistered.
  ///
  /// In en, this message translates to:
  /// **'You\'re registered!'**
  String get youAreRegistered;

  /// No description provided for @getReadyForRide.
  ///
  /// In en, this message translates to:
  /// **'Get ready for an amazing ride with\nthe community!'**
  String get getReadyForRide;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalendar;

  /// No description provided for @shareWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get shareWithFriends;

  /// No description provided for @viewMyEvents.
  ///
  /// In en, this message translates to:
  /// **'View My Events'**
  String get viewMyEvents;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Event location'**
  String get eventLocation;

  /// No description provided for @yourRegistration.
  ///
  /// In en, this message translates to:
  /// **'Your Registration'**
  String get yourRegistration;

  /// No description provided for @unableToBuildCalendarLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to build calendar link.'**
  String get unableToBuildCalendarLink;

  /// No description provided for @calendarLinkOpened.
  ///
  /// In en, this message translates to:
  /// **'Calendar link opened successfully.'**
  String get calendarLinkOpened;

  /// No description provided for @unableToOpenCalendarLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open calendar link.'**
  String get unableToOpenCalendarLink;

  /// No description provided for @registeredForEvent.
  ///
  /// In en, this message translates to:
  /// **'I just registered for {title}.'**
  String registeredForEvent(Object title);

  /// No description provided for @registrationCopied.
  ///
  /// In en, this message translates to:
  /// **'Registration details copied to clipboard.'**
  String get registrationCopied;

  /// No description provided for @myEvents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get myEvents;

  /// No description provided for @failedToLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load events'**
  String get failedToLoadEvents;

  /// No description provided for @noCancelledEvents.
  ///
  /// In en, this message translates to:
  /// **'No cancelled events'**
  String get noCancelledEvents;

  /// No description provided for @cancelledEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Cancelled events will appear here when available.'**
  String get cancelledEventsHint;

  /// No description provided for @eventHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Your event history will appear here once data is loaded.'**
  String get eventHistoryHint;

  /// No description provided for @loadingSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Loading search results...'**
  String get loadingSearchResults;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @myCyclingDetails.
  ///
  /// In en, this message translates to:
  /// **'My cycling details'**
  String get myCyclingDetails;

  /// No description provided for @riderLevel.
  ///
  /// In en, this message translates to:
  /// **'Rider Level'**
  String get riderLevel;

  /// No description provided for @totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// No description provided for @totalRides.
  ///
  /// In en, this message translates to:
  /// **'Total Rides'**
  String get totalRides;

  /// No description provided for @badgesEarned.
  ///
  /// In en, this message translates to:
  /// **'Badges Earned'**
  String get badgesEarned;

  /// No description provided for @yourRidesAndEvents.
  ///
  /// In en, this message translates to:
  /// **'Your Rides & Events'**
  String get yourRidesAndEvents;

  /// No description provided for @noCompletedRidesYet.
  ///
  /// In en, this message translates to:
  /// **'No completed rides yet'**
  String get noCompletedRidesYet;

  /// No description provided for @noJoinedCommunitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No joined communities yet'**
  String get noJoinedCommunitiesYet;

  /// No description provided for @yourListedGear.
  ///
  /// In en, this message translates to:
  /// **'Your Listed Gear'**
  String get yourListedGear;

  /// No description provided for @noListedGearYet.
  ///
  /// In en, this message translates to:
  /// **'No listed gear yet'**
  String get noListedGearYet;

  /// No description provided for @citiesAreLoading.
  ///
  /// In en, this message translates to:
  /// **'Cities are still loading'**
  String get citiesAreLoading;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @noCompletedEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No completed events yet'**
  String get noCompletedEventsYet;

  /// No description provided for @noChallengesFound.
  ///
  /// In en, this message translates to:
  /// **'No challenges found'**
  String get noChallengesFound;

  /// No description provided for @usePoints.
  ///
  /// In en, this message translates to:
  /// **'Use {points} pts'**
  String usePoints(Object points);

  /// No description provided for @failedToLoadTracks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tracks'**
  String get failedToLoadTracks;

  /// No description provided for @noTracksFound.
  ///
  /// In en, this message translates to:
  /// **'No tracks found'**
  String get noTracksFound;

  /// No description provided for @markAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as sold'**
  String get markAsSold;

  /// No description provided for @markItemAsSoldQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mark this item as sold?'**
  String get markItemAsSoldQuestion;

  /// No description provided for @markedSold.
  ///
  /// In en, this message translates to:
  /// **'Marked sold'**
  String get markedSold;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteListing.
  ///
  /// In en, this message translates to:
  /// **'Delete listing'**
  String get deleteListing;

  /// No description provided for @deleteListingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this listing?'**
  String get deleteListingConfirm;

  /// No description provided for @loginToPostOrLike.
  ///
  /// In en, this message translates to:
  /// **'Please login to post or like feed updates.'**
  String get loginToPostOrLike;

  /// No description provided for @tapMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to select a location.'**
  String get tapMapToSelectLocation;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get selectLocation;

  /// No description provided for @postSubmittedForApproval.
  ///
  /// In en, this message translates to:
  /// **'Post submitted for approval'**
  String get postSubmittedForApproval;

  /// No description provided for @noEventsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No events available'**
  String get noEventsAvailable;

  /// No description provided for @selectAnEvent.
  ///
  /// In en, this message translates to:
  /// **'Select an event'**
  String get selectAnEvent;

  /// No description provided for @noTracksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tracks available'**
  String get noTracksAvailable;

  /// No description provided for @selectATrack.
  ///
  /// In en, this message translates to:
  /// **'Select a track'**
  String get selectATrack;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required listing fields'**
  String get fillAllRequiredFields;

  /// No description provided for @pleaseSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get pleaseSelectCity;

  /// No description provided for @pleaseSelectContactMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a contact method'**
  String get pleaseSelectContactMethod;

  /// No description provided for @phoneRequiredForContactMethod.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required for selected contact method'**
  String get phoneRequiredForContactMethod;

  /// No description provided for @uploadAtLeastOnePhoto.
  ///
  /// In en, this message translates to:
  /// **'Please upload at least one product photo'**
  String get uploadAtLeastOnePhoto;

  /// No description provided for @listingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Listing updated'**
  String get listingUpdated;

  /// No description provided for @failedToSaveListing.
  ///
  /// In en, this message translates to:
  /// **'Failed to save listing'**
  String get failedToSaveListing;

  /// No description provided for @negotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get negotiable;

  /// No description provided for @sellerPhoneNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Seller phone not available'**
  String get sellerPhoneNotAvailable;

  /// No description provided for @cannotOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Cannot open WhatsApp'**
  String get cannotOpenWhatsApp;

  /// No description provided for @whatsappSeller.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Seller'**
  String get whatsappSeller;

  /// No description provided for @cannotMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Cannot make call'**
  String get cannotMakeCall;

  /// No description provided for @sellYourProduct.
  ///
  /// In en, this message translates to:
  /// **'Sell your product'**
  String get sellYourProduct;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} Results'**
  String showingResults(Object count);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @minPriceAed.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get minPriceAed;

  /// No description provided for @maxPriceAed.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get maxPriceAed;

  /// No description provided for @cityOptional.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get cityOptional;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighLow;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tracks;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @bikeExperience.
  ///
  /// In en, this message translates to:
  /// **'Bike Experience'**
  String get bikeExperience;

  /// No description provided for @rideFeed.
  ///
  /// In en, this message translates to:
  /// **'Ride Feed'**
  String get rideFeed;

  /// No description provided for @clubStore.
  ///
  /// In en, this message translates to:
  /// **'Club Store'**
  String get clubStore;

  /// No description provided for @nearbyTracks.
  ///
  /// In en, this message translates to:
  /// **'Nearby Tracks'**
  String get nearbyTracks;

  /// No description provided for @officialCyclingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Official Cycling Routes'**
  String get officialCyclingRoutes;

  /// No description provided for @exploreSafeRoutes.
  ///
  /// In en, this message translates to:
  /// **'Explore safe routes across Abu Dhabi'**
  String get exploreSafeRoutes;

  /// No description provided for @trackSafetyGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Track Safety & Guidelines'**
  String get trackSafetyGuidelines;

  /// No description provided for @staySafeEveryRide.
  ///
  /// In en, this message translates to:
  /// **'Stay safe on every ride'**
  String get staySafeEveryRide;

  /// No description provided for @searchAcrossHint.
  ///
  /// In en, this message translates to:
  /// **'Search across events, communities, tracks, and more.'**
  String get searchAcrossHint;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @soldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by'**
  String get soldBy;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @exploreByCity.
  ///
  /// In en, this message translates to:
  /// **'Explore by City'**
  String get exploreByCity;

  /// No description provided for @officialCyclingTracks.
  ///
  /// In en, this message translates to:
  /// **'Official Cycling\nTracks'**
  String get officialCyclingTracks;

  /// No description provided for @rideByStyle.
  ///
  /// In en, this message translates to:
  /// **'Ride by Style'**
  String get rideByStyle;

  /// No description provided for @tracksNearYou.
  ///
  /// In en, this message translates to:
  /// **'Tracks Near You'**
  String get tracksNearYou;

  /// No description provided for @routeDetailsPdf.
  ///
  /// In en, this message translates to:
  /// **'Route Details (PDF)'**
  String get routeDetailsPdf;

  /// No description provided for @safetyGuidelinesPdf.
  ///
  /// In en, this message translates to:
  /// **'Safety Guidelines (PDF)'**
  String get safetyGuidelinesPdf;

  /// No description provided for @safetyInformation.
  ///
  /// In en, this message translates to:
  /// **'Safety Information'**
  String get safetyInformation;

  /// No description provided for @openInLinkMyRide.
  ///
  /// In en, this message translates to:
  /// **'Open in Link My Ride'**
  String get openInLinkMyRide;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @startRide.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get startRide;

  /// No description provided for @trackDetails.
  ///
  /// In en, this message translates to:
  /// **'Track Details'**
  String get trackDetails;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @searchMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Search marketplace...'**
  String get searchMarketplace;

  /// No description provided for @availableAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Available as a guest:'**
  String get availableAsGuest;

  /// No description provided for @browseEvents.
  ///
  /// In en, this message translates to:
  /// **'Browse Events'**
  String get browseEvents;

  /// No description provided for @exploreCommunityButton.
  ///
  /// In en, this message translates to:
  /// **'Explore Community'**
  String get exploreCommunityButton;

  /// No description provided for @viewTracks.
  ///
  /// In en, this message translates to:
  /// **'View Tracks'**
  String get viewTracks;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @metricComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Metric (km, kg)\nComing soon!'**
  String get metricComingSoon;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @rideGuidelinesEtiquette.
  ///
  /// In en, this message translates to:
  /// **'Ride Guidelines / Etiquette'**
  String get rideGuidelinesEtiquette;

  /// No description provided for @helpCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help Center (Coming soon!)'**
  String get helpCenterComingSoon;

  /// No description provided for @termsConditionsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions (Coming soon!)'**
  String get termsConditionsComingSoon;

  /// No description provided for @privacyPolicyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy (Coming soon!)'**
  String get privacyPolicyComingSoon;

  /// No description provided for @eventReminders.
  ///
  /// In en, this message translates to:
  /// **'Event Reminders'**
  String get eventReminders;

  /// No description provided for @eventRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Get notified before events start'**
  String get eventRemindersSub;

  /// No description provided for @communityUpdates.
  ///
  /// In en, this message translates to:
  /// **'Community Updates'**
  String get communityUpdates;

  /// No description provided for @communityUpdatesSub.
  ///
  /// In en, this message translates to:
  /// **'New posts and announcements'**
  String get communityUpdatesSub;

  /// No description provided for @newMessages.
  ///
  /// In en, this message translates to:
  /// **'New Messages'**
  String get newMessages;

  /// No description provided for @newMessagesSub.
  ///
  /// In en, this message translates to:
  /// **'Direct messages from riders'**
  String get newMessagesSub;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsSub.
  ///
  /// In en, this message translates to:
  /// **'When you unlock badges'**
  String get achievementsSub;

  /// No description provided for @myEventsAndCalendar.
  ///
  /// In en, this message translates to:
  /// **'My Events & Calendar'**
  String get myEventsAndCalendar;

  /// No description provided for @badgesAndAchievements.
  ///
  /// In en, this message translates to:
  /// **'Badges & achievements'**
  String get badgesAndAchievements;

  /// No description provided for @myChallenges.
  ///
  /// In en, this message translates to:
  /// **'My Challenges'**
  String get myChallenges;

  /// No description provided for @rewardsAndPoints.
  ///
  /// In en, this message translates to:
  /// **'Rewards and points'**
  String get rewardsAndPoints;

  /// No description provided for @settingsAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Settings & preferences'**
  String get settingsAndPreferences;

  /// No description provided for @myBadges.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get myBadges;

  /// No description provided for @joinedEvents.
  ///
  /// In en, this message translates to:
  /// **'Joined Events'**
  String get joinedEvents;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @averageCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Average\nCompletion Rate'**
  String get averageCompletionRate;

  /// No description provided for @averageEventDistance.
  ///
  /// In en, this message translates to:
  /// **'Average Event\nDistance'**
  String get averageEventDistance;

  /// No description provided for @bestCategory.
  ///
  /// In en, this message translates to:
  /// **'Best Category'**
  String get bestCategory;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedLevel;

  /// No description provided for @ambassador.
  ///
  /// In en, this message translates to:
  /// **'Ambassador'**
  String get ambassador;

  /// No description provided for @latestAchievement.
  ///
  /// In en, this message translates to:
  /// **'Latest Achievement'**
  String get latestAchievement;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @objective.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get objective;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @street_villa_apartment.
  ///
  /// In en, this message translates to:
  /// **'Street / Villa / Apartment'**
  String get street_villa_apartment;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @emirate.
  ///
  /// In en, this message translates to:
  /// **'Emirate'**
  String get emirate;

  /// No description provided for @card_last_4_digits.
  ///
  /// In en, this message translates to:
  /// **'Card last 4 digits'**
  String get card_last_4_digits;

  /// No description provided for @additional_notes_optional.
  ///
  /// In en, this message translates to:
  /// **'Additional notes (optional)'**
  String get additional_notes_optional;

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @join_failed.
  ///
  /// In en, this message translates to:
  /// **'Join failed '**
  String get join_failed;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @primary_track.
  ///
  /// In en, this message translates to:
  /// **'Primary Track'**
  String get primary_track;

  /// No description provided for @members_1.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members_1;

  /// No description provided for @founded_year.
  ///
  /// In en, this message translates to:
  /// **'Founded Year'**
  String get founded_year;

  /// No description provided for @community_rides.
  ///
  /// In en, this message translates to:
  /// **'Community Rides'**
  String get community_rides;

  /// No description provided for @training_clinics.
  ///
  /// In en, this message translates to:
  /// **'Training & Clinics'**
  String get training_clinics;

  /// No description provided for @awareness_rides.
  ///
  /// In en, this message translates to:
  /// **'Awareness Rides'**
  String get awareness_rides;

  /// No description provided for @corporate_events.
  ///
  /// In en, this message translates to:
  /// **'Corporate Events'**
  String get corporate_events;

  /// No description provided for @national_events.
  ///
  /// In en, this message translates to:
  /// **'National Events'**
  String get national_events;

  /// No description provided for @completed_event_result.
  ///
  /// In en, this message translates to:
  /// **'Completed Event Result'**
  String get completed_event_result;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @points_earned.
  ///
  /// In en, this message translates to:
  /// **'Points Earned'**
  String get points_earned;

  /// No description provided for @pointsearned.
  ///
  /// In en, this message translates to:
  /// **'pointsEarned'**
  String get pointsearned;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @trek_domane.
  ///
  /// In en, this message translates to:
  /// **'Trek Domane'**
  String get trek_domane;

  /// No description provided for @total_distance.
  ///
  /// In en, this message translates to:
  /// **'Total distance'**
  String get total_distance;

  /// No description provided for @rides_this_month.
  ///
  /// In en, this message translates to:
  /// **'Rides this month'**
  String get rides_this_month;

  /// No description provided for @days_in_saddle.
  ///
  /// In en, this message translates to:
  /// **'Days in saddle'**
  String get days_in_saddle;

  /// No description provided for @level_progress.
  ///
  /// In en, this message translates to:
  /// **'Level Progress'**
  String get level_progress;

  /// No description provided for @identity_score.
  ///
  /// In en, this message translates to:
  /// **'Identity score'**
  String get identity_score;

  /// No description provided for @style_badge.
  ///
  /// In en, this message translates to:
  /// **'Style badge'**
  String get style_badge;

  /// No description provided for @your_cycling_journey_starts_here.
  ///
  /// In en, this message translates to:
  /// **'YOUR CYCLING JOURNEY STARTS HERE'**
  String get your_cycling_journey_starts_here;

  /// No description provided for @join_the_ride_live_the_passion.
  ///
  /// In en, this message translates to:
  /// **'JOIN THE RIDE, LIVE THE PASSION'**
  String get join_the_ride_live_the_passion;

  /// No description provided for @shop_share_with_cyclists.
  ///
  /// In en, this message translates to:
  /// **'SHOP & SHARE WITH CYCLISTS'**
  String get shop_share_with_cyclists;

  /// No description provided for @create_your_own_ride.
  ///
  /// In en, this message translates to:
  /// **'CREATE YOUR OWN RIDE'**
  String get create_your_own_ride;

  /// No description provided for @badges_achivements.
  ///
  /// In en, this message translates to:
  /// **'Badges & Achivements'**
  String get badges_achivements;

  /// No description provided for @ride.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get ride;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @event_history.
  ///
  /// In en, this message translates to:
  /// **'Event History'**
  String get event_history;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @logging_out.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get logging_out;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @back_to_feed.
  ///
  /// In en, this message translates to:
  /// **'Back to Feed'**
  String get back_to_feed;

  /// No description provided for @add_photos_videos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos / Videos'**
  String get add_photos_videos;

  /// No description provided for @write_your_experience.
  ///
  /// In en, this message translates to:
  /// **'Write your experience'**
  String get write_your_experience;

  /// No description provided for @share_your_ride_event_experience.
  ///
  /// In en, this message translates to:
  /// **'Share your ride, event experience...'**
  String get share_your_ride_event_experience;

  /// No description provided for @tag_event_optional.
  ///
  /// In en, this message translates to:
  /// **'Tag Event (optional)'**
  String get tag_event_optional;

  /// No description provided for @select_event.
  ///
  /// In en, this message translates to:
  /// **'Select event'**
  String get select_event;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get start_time;

  /// No description provided for @special_instructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get special_instructions;

  /// No description provided for @tag_track_optional.
  ///
  /// In en, this message translates to:
  /// **'Tag Track (optional)'**
  String get tag_track_optional;

  /// No description provided for @select_track.
  ///
  /// In en, this message translates to:
  /// **'Select track'**
  String get select_track;

  /// No description provided for @location_optional.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get location_optional;

  /// No description provided for @add_a_comment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get add_a_comment;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @mark_sold.
  ///
  /// In en, this message translates to:
  /// **'Mark sold'**
  String get mark_sold;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @active_listings.
  ///
  /// In en, this message translates to:
  /// **'Active listings'**
  String get active_listings;

  /// No description provided for @sold_items.
  ///
  /// In en, this message translates to:
  /// **'Sold items'**
  String get sold_items;

  /// No description provided for @e_g_specialized_tarmac_sl7.
  ///
  /// In en, this message translates to:
  /// **'e.g., Specialized Tarmac SL7'**
  String get e_g_specialized_tarmac_sl7;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get select_category;

  /// No description provided for @select_condition.
  ///
  /// In en, this message translates to:
  /// **'Select condition'**
  String get select_condition;

  /// No description provided for @lighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lighting;

  /// No description provided for @water_stataion.
  ///
  /// In en, this message translates to:
  /// **'Water stataion'**
  String get water_stataion;

  /// No description provided for @restroom.
  ///
  /// In en, this message translates to:
  /// **'Restroom'**
  String get restroom;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'YOUR CYCLING JOURNEY STARTS HERE'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Track your rides, explore scenic routes, join events, and connect with the UAE cycling community.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'JOIN THE RIDE, LIVE THE PASSION'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Discover cycling routes, community rides, and events designed for every rider.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'SHOP & SHARE WITH CYCLISTS'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Browse cycling gear, connect with fellow riders, and grow your equipment collection.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'CREATE YOUR OWN RIDE'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Plan routes, set goals, and track your progress to ride farther every day.'**
  String get onboardingDesc4;

  /// No description provided for @about_me.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get about_me;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @tell_us_about.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself and your cycling journey...'**
  String get tell_us_about;

  /// No description provided for @select_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get select_date_of_birth;

  /// No description provided for @yourResult.
  ///
  /// In en, this message translates to:
  /// **'Your Result'**
  String get yourResult;

  /// No description provided for @communities_using_track.
  ///
  /// In en, this message translates to:
  /// **'Communities Using This Track'**
  String get communities_using_track;

  /// No description provided for @error_loading_communities.
  ///
  /// In en, this message translates to:
  /// **'Error loading communities'**
  String get error_loading_communities;

  /// No description provided for @no_communities_for_track.
  ///
  /// In en, this message translates to:
  /// **'No communities found for this track'**
  String get no_communities_for_track;

  /// No description provided for @tracks_description.
  ///
  /// In en, this message translates to:
  /// **'Tracks Description'**
  String get tracks_description;

  /// No description provided for @upcoming_events_on_track.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events on this Track'**
  String get upcoming_events_on_track;

  /// No description provided for @route_preview.
  ///
  /// In en, this message translates to:
  /// **'Route Preview'**
  String get route_preview;

  /// No description provided for @subtotal_items.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({count} items)'**
  String subtotal_items(Object count);

  /// No description provided for @total_badges.
  ///
  /// In en, this message translates to:
  /// **'Total Badges'**
  String get total_badges;

  /// No description provided for @total_points.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get total_points;

  /// No description provided for @total_events.
  ///
  /// In en, this message translates to:
  /// **'Total Events'**
  String get total_events;

  /// No description provided for @podium_finishes.
  ///
  /// In en, this message translates to:
  /// **'Podium Finishes'**
  String get podium_finishes;

  /// No description provided for @earned_this_month.
  ///
  /// In en, this message translates to:
  /// **'Earned This Month'**
  String get earned_this_month;

  /// No description provided for @reward_claimed.
  ///
  /// In en, this message translates to:
  /// **'Reward Claimed'**
  String get reward_claimed;

  /// No description provided for @current_tier.
  ///
  /// In en, this message translates to:
  /// **'Current Tier'**
  String get current_tier;

  /// No description provided for @rewards_and_points.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Points'**
  String get rewards_and_points;

  /// No description provided for @earn_points_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Earn points by completing challenges'**
  String get earn_points_subtitle;

  /// No description provided for @distance_champion_badge.
  ///
  /// In en, this message translates to:
  /// **'Distance Champion Badge'**
  String get distance_champion_badge;

  /// No description provided for @earned_today.
  ///
  /// In en, this message translates to:
  /// **'Earned today'**
  String get earned_today;

  /// No description provided for @reward_points_100.
  ///
  /// In en, this message translates to:
  /// **'+100 Reward Points'**
  String get reward_points_100;

  /// No description provided for @added_to_your_account.
  ///
  /// In en, this message translates to:
  /// **'Added to your account'**
  String get added_to_your_account;

  /// No description provided for @challenge_top_performers.
  ///
  /// In en, this message translates to:
  /// **'Top Performers'**
  String get challenge_top_performers;

  /// No description provided for @your_cycling_identity.
  ///
  /// In en, this message translates to:
  /// **'Your Cycling Identity'**
  String get your_cycling_identity;

  /// No description provided for @communities_in_your_city.
  ///
  /// In en, this message translates to:
  /// **'Communities in Your City'**
  String get communities_in_your_city;

  /// No description provided for @purpose_based_communities.
  ///
  /// In en, this message translates to:
  /// **'Purpose-Based Communities'**
  String get purpose_based_communities;

  /// No description provided for @most_active.
  ///
  /// In en, this message translates to:
  /// **'Most Active'**
  String get most_active;

  /// No description provided for @most_members.
  ///
  /// In en, this message translates to:
  /// **'Most Members'**
  String get most_members;

  /// No description provided for @recently_created.
  ///
  /// In en, this message translates to:
  /// **'Recently Created'**
  String get recently_created;

  /// No description provided for @all_cycling_communities.
  ///
  /// In en, this message translates to:
  /// **'All cycling communities active near you'**
  String get all_cycling_communities;

  /// No description provided for @communities_purpose_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Communities based on purpose and goals'**
  String get communities_purpose_subtitle;

  /// No description provided for @family_leisure.
  ///
  /// In en, this message translates to:
  /// **'Family & Leisure'**
  String get family_leisure;

  /// No description provided for @racing_performance.
  ///
  /// In en, this message translates to:
  /// **'Racing & Performance'**
  String get racing_performance;

  /// No description provided for @women_sherides.
  ///
  /// In en, this message translates to:
  /// **'Women (SheRides)'**
  String get women_sherides;

  /// No description provided for @youth_cycling.
  ///
  /// In en, this message translates to:
  /// **'Youth Cycling'**
  String get youth_cycling;

  /// No description provided for @social_weekend.
  ///
  /// In en, this message translates to:
  /// **'Social / Weekend'**
  String get social_weekend;

  /// No description provided for @night_riders.
  ///
  /// In en, this message translates to:
  /// **'Night Riders'**
  String get night_riders;

  /// No description provided for @mtb_trail.
  ///
  /// In en, this message translates to:
  /// **'MTB / Trail'**
  String get mtb_trail;

  /// No description provided for @awareness_charity.
  ///
  /// In en, this message translates to:
  /// **'Awareness & Charity'**
  String get awareness_charity;

  /// No description provided for @challenge_completion_badge.
  ///
  /// In en, this message translates to:
  /// **'Completion Badge'**
  String get challenge_completion_badge;

  /// No description provided for @challenge_completion_badge_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Great work finishing the challenge!'**
  String get challenge_completion_badge_subtitle;

  /// No description provided for @challenge_your_progress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get challenge_your_progress;

  /// No description provided for @challenge_rules.
  ///
  /// In en, this message translates to:
  /// **'Challenge Rules'**
  String get challenge_rules;

  /// No description provided for @challenge_progress_to_go.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% to go • {remaining} {unit} remaining'**
  String challenge_progress_to_go(
      Object percentage, Object remaining, Object unit);

  /// No description provided for @month_january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get month_january;

  /// No description provided for @month_february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get month_february;

  /// No description provided for @month_march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get month_march;

  /// No description provided for @month_april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get month_april;

  /// No description provided for @month_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month_may;

  /// No description provided for @month_june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get month_june;

  /// No description provided for @month_july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get month_july;

  /// No description provided for @month_august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get month_august;

  /// No description provided for @month_september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get month_september;

  /// No description provided for @month_october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get month_october;

  /// No description provided for @month_november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get month_november;

  /// No description provided for @month_december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get month_december;

  /// No description provided for @reward_earned.
  ///
  /// In en, this message translates to:
  /// **'Reward Earned'**
  String get reward_earned;

  /// No description provided for @failed_to_load_products.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products. Please try again.'**
  String get failed_to_load_products;

  /// No description provided for @no_products_found.
  ///
  /// In en, this message translates to:
  /// **'No products found.'**
  String get no_products_found;

  /// No description provided for @product_label.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product_label;

  /// No description provided for @join_community_button.
  ///
  /// In en, this message translates to:
  /// **'Join Community'**
  String get join_community_button;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get not_available;

  /// No description provided for @share_community_fallback_title.
  ///
  /// In en, this message translates to:
  /// **'Check out this community'**
  String get share_community_fallback_title;

  /// No description provided for @share_community_fallback_description.
  ///
  /// In en, this message translates to:
  /// **'Discover this community on the ADCC app.'**
  String get share_community_fallback_description;

  /// No description provided for @share_community_footer.
  ///
  /// In en, this message translates to:
  /// **'Explore it on the Abu Dhabi Cycling Club app.'**
  String get share_community_footer;

  /// No description provided for @share_community_subject.
  ///
  /// In en, this message translates to:
  /// **'Check out this community'**
  String get share_community_subject;

  /// No description provided for @gear.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get gear;

  /// No description provided for @event_badge_national.
  ///
  /// In en, this message translates to:
  /// **'National'**
  String get event_badge_national;

  /// No description provided for @event_badge_corporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get event_badge_corporate;

  /// No description provided for @event_badge_awareness.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get event_badge_awareness;

  /// No description provided for @event_badge_training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get event_badge_training;

  /// No description provided for @event_badge_race.
  ///
  /// In en, this message translates to:
  /// **'Race'**
  String get event_badge_race;

  /// No description provided for @event_badge_community_ride.
  ///
  /// In en, this message translates to:
  /// **'Community Ride'**
  String get event_badge_community_ride;

  /// No description provided for @event_badge_tbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get event_badge_tbd;

  /// No description provided for @riders_suffix.
  ///
  /// In en, this message translates to:
  /// **'riders'**
  String get riders_suffix;

  /// No description provided for @share_event_subject.
  ///
  /// In en, this message translates to:
  /// **'Check out this event on ADCC'**
  String get share_event_subject;

  /// No description provided for @failed_to_load_event_results.
  ///
  /// In en, this message translates to:
  /// **'Failed to load event results'**
  String get failed_to_load_event_results;

  /// No description provided for @leaderboard_top_10.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard (Top 10)'**
  String get leaderboard_top_10;

  /// No description provided for @you_label.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you_label;

  /// No description provided for @rider_label.
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get rider_label;

  /// No description provided for @date_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Date unavailable'**
  String get date_unavailable;

  /// No description provided for @time_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Time unavailable'**
  String get time_unavailable;

  /// No description provided for @time_am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get time_am;

  /// No description provided for @time_pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get time_pm;

  /// No description provided for @month_short_jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get month_short_jan;

  /// No description provided for @month_short_feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get month_short_feb;

  /// No description provided for @month_short_mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get month_short_mar;

  /// No description provided for @month_short_apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get month_short_apr;

  /// No description provided for @month_short_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month_short_may;

  /// No description provided for @month_short_jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get month_short_jun;

  /// No description provided for @month_short_jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get month_short_jul;

  /// No description provided for @month_short_aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get month_short_aug;

  /// No description provided for @month_short_sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get month_short_sep;

  /// No description provided for @month_short_oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get month_short_oct;

  /// No description provided for @month_short_nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get month_short_nov;

  /// No description provided for @month_short_dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get month_short_dec;

  /// No description provided for @event_status_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get event_status_open;

  /// No description provided for @popular_communities.
  ///
  /// In en, this message translates to:
  /// **'Popular Communities'**
  String get popular_communities;

  /// No description provided for @featured_events.
  ///
  /// In en, this message translates to:
  /// **'Featured Events'**
  String get featured_events;

  /// No description provided for @view_all_label.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all_label;

  /// No description provided for @posted_by.
  ///
  /// In en, this message translates to:
  /// **'Posted by '**
  String get posted_by;

  /// No description provided for @choose_your_language.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR\nLANGUAGE'**
  String get choose_your_language;

  /// No description provided for @rider_level_membership.
  ///
  /// In en, this message translates to:
  /// **'Rider level membership'**
  String get rider_level_membership;

  /// No description provided for @your_communities.
  ///
  /// In en, this message translates to:
  /// **'Your Communities'**
  String get your_communities;

  /// No description provided for @explore_label.
  ///
  /// In en, this message translates to:
  /// **'Explore ›'**
  String get explore_label;

  /// No description provided for @just_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get just_now;

  /// No description provided for @notification_type.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String notification_type(Object type);

  /// No description provided for @notification_inbox.
  ///
  /// In en, this message translates to:
  /// **'Notification Inbox'**
  String get notification_inbox;

  /// No description provided for @unread_notifications.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String unread_notifications(Object count);

  /// No description provided for @rider_level_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get rider_level_locked;

  /// No description provided for @unlocked_badges.
  ///
  /// In en, this message translates to:
  /// **'Unlocked Badges'**
  String get unlocked_badges;

  /// No description provided for @no_badges_available.
  ///
  /// In en, this message translates to:
  /// **'No badges available yet'**
  String get no_badges_available;

  /// No description provided for @failed_to_load_cycling_details.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cycling details'**
  String get failed_to_load_cycling_details;

  /// No description provided for @unable_to_update_profile.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. Please check your details and try again.'**
  String get unable_to_update_profile;

  /// No description provided for @unable_to_update_profile_generic.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. Please try again.'**
  String get unable_to_update_profile_generic;

  /// No description provided for @completed_events.
  ///
  /// In en, this message translates to:
  /// **'Completed Events'**
  String get completed_events;

  /// No description provided for @upcoming_events_section.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcoming_events_section;

  /// No description provided for @ride_completed.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed!'**
  String get ride_completed;

  /// No description provided for @settings_and_preferences_title.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settings_and_preferences_title;

  /// No description provided for @check_out_my_achievements.
  ///
  /// In en, this message translates to:
  /// **'Check out my ADCC achievements'**
  String get check_out_my_achievements;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @performance_insights.
  ///
  /// In en, this message translates to:
  /// **'Performance Insights'**
  String get performance_insights;

  /// No description provided for @welcome_to_adcc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ADCC'**
  String get welcome_to_adcc;

  /// No description provided for @sign_up_prompt.
  ///
  /// In en, this message translates to:
  /// **'Sign up to join events, connect with the community, and track your cycling journey.'**
  String get sign_up_prompt;

  /// No description provided for @sign_up_login.
  ///
  /// In en, this message translates to:
  /// **'Sign Up / Login'**
  String get sign_up_login;

  /// No description provided for @available_rewards.
  ///
  /// In en, this message translates to:
  /// **'Available Rewards'**
  String get available_rewards;

  /// No description provided for @claim_now.
  ///
  /// In en, this message translates to:
  /// **'Claim now'**
  String get claim_now;

  /// No description provided for @additional_thoughts.
  ///
  /// In en, this message translates to:
  /// **'Additional Thoughts'**
  String get additional_thoughts;

  /// No description provided for @share_details_hint.
  ///
  /// In en, this message translates to:
  /// **'Share details about your experience.'**
  String get share_details_hint;

  /// No description provided for @new_badge_formed.
  ///
  /// In en, this message translates to:
  /// **'New Badge Formed!'**
  String get new_badge_formed;

  /// No description provided for @century_explorer.
  ///
  /// In en, this message translates to:
  /// **'Century Explorer'**
  String get century_explorer;

  /// No description provided for @share_your_photos_optional.
  ///
  /// In en, this message translates to:
  /// **'Share Your Photos (Optional)'**
  String get share_your_photos_optional;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get add_photo;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @share_your_ride.
  ///
  /// In en, this message translates to:
  /// **'Share Your Ride'**
  String get share_your_ride;

  /// No description provided for @i_just_completed_ride.
  ///
  /// In en, this message translates to:
  /// **'I just completed a ride on ADCC'**
  String get i_just_completed_ride;

  /// No description provided for @wrap_up_week.
  ///
  /// In en, this message translates to:
  /// **'Wrap up week'**
  String get wrap_up_week;

  /// No description provided for @great_job_completing_ride.
  ///
  /// In en, this message translates to:
  /// **'Great job on completing this ride!'**
  String get great_job_completing_ride;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @avg_speed.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get avg_speed;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @elevation_gain.
  ///
  /// In en, this message translates to:
  /// **'Elevation Gain'**
  String get elevation_gain;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @app_preferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get app_preferences;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @app_version_value.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0 (Build 100)'**
  String get app_version_value;

  /// No description provided for @ride_feed.
  ///
  /// In en, this message translates to:
  /// **'Ride Feed'**
  String get ride_feed;

  /// No description provided for @join_abu_dhabi_community.
  ///
  /// In en, this message translates to:
  /// **'Join the Abu Dhabi Cycling Community!'**
  String get join_abu_dhabi_community;

  /// No description provided for @post_your_ride.
  ///
  /// In en, this message translates to:
  /// **'Post Your Ride'**
  String get post_your_ride;

  /// No description provided for @earned_count.
  ///
  /// In en, this message translates to:
  /// **'{count} earned'**
  String earned_count(Object count);

  /// No description provided for @completion_rate.
  ///
  /// In en, this message translates to:
  /// **'{value} completion'**
  String completion_rate(Object value);

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @cycling_community_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Cycling community • {trackName}'**
  String cycling_community_subtitle(Object trackName);

  /// No description provided for @various_tracks.
  ///
  /// In en, this message translates to:
  /// **'Various tracks'**
  String get various_tracks;

  /// No description provided for @unknown_members.
  ///
  /// In en, this message translates to:
  /// **'Unknown members'**
  String get unknown_members;

  /// No description provided for @members_count.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String members_count(Object count);

  /// No description provided for @elevation.
  ///
  /// In en, this message translates to:
  /// **'Elevation'**
  String get elevation;

  /// No description provided for @type_label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type_label;

  /// No description provided for @avg_time.
  ///
  /// In en, this message translates to:
  /// **'Avg Time'**
  String get avg_time;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @route_permission_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to track your route. Please enable it in settings.'**
  String get route_permission_message;

  /// No description provided for @helmets_mandatory.
  ///
  /// In en, this message translates to:
  /// **'Helmets are mandatory.'**
  String get helmets_mandatory;

  /// No description provided for @safety_ride_early.
  ///
  /// In en, this message translates to:
  /// **'Ride early morning or late evening in summer.'**
  String get safety_ride_early;

  /// No description provided for @safety_carry_water.
  ///
  /// In en, this message translates to:
  /// **'Carry sufficient water.'**
  String get safety_carry_water;

  /// No description provided for @safety_follow_regulations.
  ///
  /// In en, this message translates to:
  /// **'Follow traffic and track regulations.'**
  String get safety_follow_regulations;

  /// No description provided for @tracks_in_city.
  ///
  /// In en, this message translates to:
  /// **'Tracks in {city}'**
  String tracks_in_city(Object city);

  /// No description provided for @tracks_found.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks found'**
  String tracks_found(Object count);

  /// No description provided for @find_a_track.
  ///
  /// In en, this message translates to:
  /// **'Find a Track'**
  String get find_a_track;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @cycling_tracks_closest.
  ///
  /// In en, this message translates to:
  /// **'Cycling tracks closest to your current location'**
  String get cycling_tracks_closest;

  /// No description provided for @official_cycling_tracks_title.
  ///
  /// In en, this message translates to:
  /// **'Official Cycling Tracks'**
  String get official_cycling_tracks_title;

  /// No description provided for @hill_elevation_training.
  ///
  /// In en, this message translates to:
  /// **'Hill & Elevation Training'**
  String get hill_elevation_training;

  /// No description provided for @night_riding_routes.
  ///
  /// In en, this message translates to:
  /// **'Night Riding Routes'**
  String get night_riding_routes;

  /// No description provided for @sunrise_rides.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Rides'**
  String get sunrise_rides;

  /// No description provided for @family_youth_friendly.
  ///
  /// In en, this message translates to:
  /// **'Family & Youth Friendly'**
  String get family_youth_friendly;

  /// No description provided for @routes_count.
  ///
  /// In en, this message translates to:
  /// **'{count} routes'**
  String routes_count(Object count);

  /// No description provided for @product_photos.
  ///
  /// In en, this message translates to:
  /// **'Product Photos'**
  String get product_photos;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @preferred_contact_method.
  ///
  /// In en, this message translates to:
  /// **'Preferred Contact Method'**
  String get preferred_contact_method;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @select_contact_method.
  ///
  /// In en, this message translates to:
  /// **'Select contact method'**
  String get select_contact_method;

  /// No description provided for @select_city.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get select_city;

  /// No description provided for @describe_item_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe your item, its condition, and any relevant details...'**
  String get describe_item_hint;

  /// No description provided for @your_item_is_live.
  ///
  /// In en, this message translates to:
  /// **'Your item is live'**
  String get your_item_is_live;

  /// No description provided for @successfully_posted_listing.
  ///
  /// In en, this message translates to:
  /// **'You have successfully\nposted listing'**
  String get successfully_posted_listing;

  /// No description provided for @view_listing.
  ///
  /// In en, this message translates to:
  /// **'View Listing'**
  String get view_listing;

  /// No description provided for @post_another_item.
  ///
  /// In en, this message translates to:
  /// **'Post Another Item'**
  String get post_another_item;

  /// No description provided for @posted_by_time_ago.
  ///
  /// In en, this message translates to:
  /// **'Posted by {time} ago'**
  String posted_by_time_ago(Object time);

  /// No description provided for @cycling_marketplace.
  ///
  /// In en, this message translates to:
  /// **'Cycling Marketplace'**
  String get cycling_marketplace;

  /// No description provided for @safety_tips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safety_tips;

  /// No description provided for @meet_the_seller_tip.
  ///
  /// In en, this message translates to:
  /// **'Meet the seller in a safe public place and inspect the item before payment.'**
  String get meet_the_seller_tip;

  /// No description provided for @listings_count.
  ///
  /// In en, this message translates to:
  /// **'{count} listings'**
  String listings_count(Object count);

  /// No description provided for @unknown_seller.
  ///
  /// In en, this message translates to:
  /// **'Unknown Seller'**
  String get unknown_seller;

  /// No description provided for @listing_label.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get listing_label;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @no_achievements_yet.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get no_achievements_yet;

  /// No description provided for @no_badges_yet.
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get no_badges_yet;

  /// No description provided for @no_joined_events_yet.
  ///
  /// In en, this message translates to:
  /// **'No joined events yet'**
  String get no_joined_events_yet;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @tracks_views_community_photos.
  ///
  /// In en, this message translates to:
  /// **'Tracks Views & Community Photos'**
  String get tracks_views_community_photos;

  /// No description provided for @my_listings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get my_listings;

  /// No description provided for @no_sold_items_yet.
  ///
  /// In en, this message translates to:
  /// **'No sold items yet'**
  String get no_sold_items_yet;

  /// No description provided for @listed_in_community_store.
  ///
  /// In en, this message translates to:
  /// **'Listed in Community Store'**
  String get listed_in_community_store;

  /// No description provided for @route_details_title.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get route_details_title;

  /// No description provided for @post_not_found.
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get post_not_found;

  /// No description provided for @club_update.
  ///
  /// In en, this message translates to:
  /// **'Club Update'**
  String get club_update;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @create_post.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get create_post;

  /// No description provided for @upload_media.
  ///
  /// In en, this message translates to:
  /// **'Upload Media'**
  String get upload_media;

  /// No description provided for @images_videos_gifs.
  ///
  /// In en, this message translates to:
  /// **'Images, videos, or GIFs'**
  String get images_videos_gifs;

  /// No description provided for @upload_a_new_photo.
  ///
  /// In en, this message translates to:
  /// **'Upload a new photo'**
  String get upload_a_new_photo;

  /// No description provided for @failed_to_load_communities.
  ///
  /// In en, this message translates to:
  /// **'Failed to load communities'**
  String get failed_to_load_communities;

  /// No description provided for @photo_size_hint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or GIF. Max size 2MB'**
  String get photo_size_hint;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @view_available_offers.
  ///
  /// In en, this message translates to:
  /// **'View available offers'**
  String get view_available_offers;

  /// No description provided for @no_comments_yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get no_comments_yet;

  /// No description provided for @no_approved_posts.
  ///
  /// In en, this message translates to:
  /// **'No approved posts yet.'**
  String get no_approved_posts;

  /// No description provided for @keep_riding_to_level_up.
  ///
  /// In en, this message translates to:
  /// **'Keep riding to level up.'**
  String get keep_riding_to_level_up;

  /// No description provided for @list_item_for_sale.
  ///
  /// In en, this message translates to:
  /// **'List Item for Sale'**
  String get list_item_for_sale;

  /// No description provided for @listing_terms.
  ///
  /// In en, this message translates to:
  /// **'By listing your item, you agree to our terms of service and marketplace guidelines.'**
  String get listing_terms;

  /// No description provided for @meet_in_public_tip.
  ///
  /// In en, this message translates to:
  /// **'Meet in a public place, Inspect the item before paying. ADCC does not handle transactions'**
  String get meet_in_public_tip;

  /// No description provided for @search_track_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by track name, city, distance or terrain...'**
  String get search_track_name_hint;

  /// No description provided for @search_tracks_hint.
  ///
  /// In en, this message translates to:
  /// **'Search tracks, city, distance or terrain...'**
  String get search_tracks_hint;

  /// No description provided for @cycling_stats_from_events.
  ///
  /// In en, this message translates to:
  /// **'Your Cycling Stats Come From Events And Rides.'**
  String get cycling_stats_from_events;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @image_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get image_unavailable;

  /// No description provided for @two_days_ago.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get two_days_ago;

  /// No description provided for @posted_two_mins_ago.
  ///
  /// In en, this message translates to:
  /// **'Posted by 2mins ago'**
  String get posted_two_mins_ago;

  /// No description provided for @rank_number.
  ///
  /// In en, this message translates to:
  /// **'Rank #{rank}'**
  String rank_number(Object rank);

  /// No description provided for @view_all_arrow.
  ///
  /// In en, this message translates to:
  /// **'View All ›'**
  String get view_all_arrow;

  /// No description provided for @completed_rides_count.
  ///
  /// In en, this message translates to:
  /// **'Completed Rides: 18'**
  String get completed_rides_count;

  /// No description provided for @drt_830_road_shoes.
  ///
  /// In en, this message translates to:
  /// **'DRT 830 Road Shoes'**
  String get drt_830_road_shoes;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @join_event_hint.
  ///
  /// In en, this message translates to:
  /// **'Join the Abu Dhabi Cycle Community Event!\nPedal through the city\'s beautiful streets and\nconnect with fellow cycling enthusiasts.\nCelebrate cycling and community spirit!'**
  String get join_event_hint;

  /// No description provided for @selected_location.
  ///
  /// In en, this message translates to:
  /// **'Selected location: {location}'**
  String selected_location(Object location);

  /// No description provided for @cycling_tracks_in_city.
  ///
  /// In en, this message translates to:
  /// **'Cycling tracks closest to your current location in {city}'**
  String cycling_tracks_in_city(Object city);

  /// No description provided for @tap_slot_add_photos.
  ///
  /// In en, this message translates to:
  /// **'Tap a slot to add your photos. You can upload up to 5 photos.'**
  String get tap_slot_add_photos;

  /// No description provided for @club_tees.
  ///
  /// In en, this message translates to:
  /// **'Club Tees'**
  String get club_tees;

  /// No description provided for @club_tees_sub.
  ///
  /// In en, this message translates to:
  /// **'Browse the latest branded apparel'**
  String get club_tees_sub;

  /// No description provided for @ride_gear.
  ///
  /// In en, this message translates to:
  /// **'Ride Gear'**
  String get ride_gear;

  /// No description provided for @ride_gear_sub.
  ///
  /// In en, this message translates to:
  /// **'Find helmets, gloves, and protective wear'**
  String get ride_gear_sub;

  /// No description provided for @bike_tools.
  ///
  /// In en, this message translates to:
  /// **'Bike Tools'**
  String get bike_tools;

  /// No description provided for @bike_tools_sub.
  ///
  /// In en, this message translates to:
  /// **'Shop the essentials for maintenance'**
  String get bike_tools_sub;

  /// No description provided for @no_community_groups.
  ///
  /// In en, this message translates to:
  /// **'No community groups found'**
  String get no_community_groups;

  /// No description provided for @communities_title.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communities_title;

  /// No description provided for @community_types.
  ///
  /// In en, this message translates to:
  /// **'Community Types'**
  String get community_types;

  /// No description provided for @choose_communities_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose communities based on your riding preference'**
  String get choose_communities_subtitle;

  /// No description provided for @elite_community.
  ///
  /// In en, this message translates to:
  /// **'Elite Community'**
  String get elite_community;

  /// No description provided for @awareness_rides_community.
  ///
  /// In en, this message translates to:
  /// **'Awareness Rides Community'**
  String get awareness_rides_community;

  /// No description provided for @uae_national_events_riders.
  ///
  /// In en, this message translates to:
  /// **'UAE National Events Riders'**
  String get uae_national_events_riders;

  /// No description provided for @breast_cancer_awareness_riders.
  ///
  /// In en, this message translates to:
  /// **'Breast Cancer Awareness Riders'**
  String get breast_cancer_awareness_riders;

  /// No description provided for @completed_rides.
  ///
  /// In en, this message translates to:
  /// **'Completed Rides: {rides}'**
  String completed_rides(Object rides);

  /// No description provided for @reward_earned_newline.
  ///
  /// In en, this message translates to:
  /// **'Reward\nEarned'**
  String get reward_earned_newline;

  /// No description provided for @available_points.
  ///
  /// In en, this message translates to:
  /// **'Available Points'**
  String get available_points;

  /// No description provided for @progress_to_gold_tier.
  ///
  /// In en, this message translates to:
  /// **'Progress to Gold Tier'**
  String get progress_to_gold_tier;

  /// No description provided for @complete_5_rides_same_condo.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 Rides in the same Condo'**
  String get complete_5_rides_same_condo;

  /// No description provided for @no_communities_found.
  ///
  /// In en, this message translates to:
  /// **'No communities found'**
  String get no_communities_found;

  /// No description provided for @search_events_communities_hint.
  ///
  /// In en, this message translates to:
  /// **'Search events, communities, cities, or tracks...'**
  String get search_events_communities_hint;

  /// No description provided for @explore_community_plus.
  ///
  /// In en, this message translates to:
  /// **'Explore Community +'**
  String get explore_community_plus;

  /// No description provided for @communities_in_city.
  ///
  /// In en, this message translates to:
  /// **'Communities in {city}'**
  String communities_in_city(Object city);

  /// No description provided for @communities_found_count.
  ///
  /// In en, this message translates to:
  /// **'{count} communities found'**
  String communities_found_count(Object count);

  /// No description provided for @share_event_body.
  ///
  /// In en, this message translates to:
  /// **'Check out this event on ADCC:\n{title}\n\nOpen in app:\n{deepLink}\n{webLink}'**
  String share_event_body(Object title, Object deepLink, Object webLink);

  /// No description provided for @share_challenge_body.
  ///
  /// In en, this message translates to:
  /// **'Check out this challenge on ADCC:\n{title}\n\nOpen in app:\n{deepLink}\n{webLink}'**
  String share_challenge_body(Object title, Object deepLink, Object webLink);

  /// No description provided for @share_route_body.
  ///
  /// In en, this message translates to:
  /// **'Check out this route on ADCC:\n{title}\n\nOpen in app:\n{deepLink}\n{webLink}'**
  String share_route_body(Object title, Object deepLink, Object webLink);

  /// No description provided for @share_community_body.
  ///
  /// In en, this message translates to:
  /// **'Check out this community on ADCC:\n{title}\n\nOpen in app:\n{deepLink}\n{webLink}'**
  String share_community_body(Object title, Object deepLink, Object webLink);

  /// No description provided for @share_achievements_body.
  ///
  /// In en, this message translates to:
  /// **'Check out my achievements on ADCC!\n\nOpen the ADCC app to see more.\n{webLink}'**
  String share_achievements_body(Object webLink);

  /// No description provided for @share_ride_body.
  ///
  /// In en, this message translates to:
  /// **'I just completed a ride on ADCC!\n\nOpen the ADCC app to track rides and join events.\n{webLink}'**
  String share_ride_body(Object webLink);

  /// No description provided for @connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get connection_timeout;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get no_internet_connection;

  /// No description provided for @request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled'**
  String get request_cancelled;

  /// No description provided for @ssl_certificate_error.
  ///
  /// In en, this message translates to:
  /// **'SSL certificate error. Please try again later.'**
  String get ssl_certificate_error;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpected_error;

  /// No description provided for @bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please check your input.'**
  String get bad_request;

  /// No description provided for @unauthorized_login_again.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please login again.'**
  String get unauthorized_login_again;

  /// No description provided for @forbidden_no_permission.
  ///
  /// In en, this message translates to:
  /// **'Forbidden. You don\'t have permission to access this resource.'**
  String get forbidden_no_permission;

  /// No description provided for @resource_not_found.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get resource_not_found;

  /// No description provided for @conflict_exists.
  ///
  /// In en, this message translates to:
  /// **'Conflict. The resource already exists.'**
  String get conflict_exists;

  /// No description provided for @validation_error.
  ///
  /// In en, this message translates to:
  /// **'Validation error. Please check your input.'**
  String get validation_error;

  /// No description provided for @too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get too_many_requests;

  /// No description provided for @internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please try again later.'**
  String get internal_server_error;

  /// No description provided for @bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway. Please try again later.'**
  String get bad_gateway;

  /// No description provided for @service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable. Please try again later.'**
  String get service_unavailable;

  /// No description provided for @gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout. Please try again later.'**
  String get gateway_timeout;

  /// No description provided for @error_status_code.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Status code: {statusCode}'**
  String error_status_code(Object statusCode);

  /// No description provided for @share_route_subject.
  ///
  /// In en, this message translates to:
  /// **'Check out this route on ADCC'**
  String get share_route_subject;

  /// No description provided for @pace_beginner_casual.
  ///
  /// In en, this message translates to:
  /// **'Beginner / Casual'**
  String get pace_beginner_casual;

  /// No description provided for @pace_fast_challenging.
  ///
  /// In en, this message translates to:
  /// **'Fast / Challenging'**
  String get pace_fast_challenging;

  /// No description provided for @google_sign_in_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in cancelled'**
  String get google_sign_in_cancelled;

  /// No description provided for @failed_to_get_google_token.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Google ID token'**
  String get failed_to_get_google_token;

  /// No description provided for @failed_to_get_facebook_token.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Facebook access token'**
  String get failed_to_get_facebook_token;

  /// No description provided for @facebook_login_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Facebook login cancelled'**
  String get facebook_login_cancelled;

  /// No description provided for @failed_to_fetch_communities.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch communities'**
  String get failed_to_fetch_communities;

  /// No description provided for @failed_to_fetch_community_types.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch community types'**
  String get failed_to_fetch_community_types;

  /// No description provided for @failed_to_join_community.
  ///
  /// In en, this message translates to:
  /// **'Failed to join community'**
  String get failed_to_join_community;

  /// No description provided for @failed_to_fetch_member_status.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch member status'**
  String get failed_to_fetch_member_status;

  /// No description provided for @community_left_successfully.
  ///
  /// In en, this message translates to:
  /// **'Community left successfully'**
  String get community_left_successfully;

  /// No description provided for @failed_to_leave_community.
  ///
  /// In en, this message translates to:
  /// **'Failed to leave community'**
  String get failed_to_leave_community;

  /// No description provided for @failed_to_fetch_community.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch community'**
  String get failed_to_fetch_community;

  /// No description provided for @no_categories_found.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get no_categories_found;

  /// No description provided for @failed_to_fetch_categories.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch categories'**
  String get failed_to_fetch_categories;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get network_error;

  /// No description provided for @failed_to_fetch_events.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch events'**
  String get failed_to_fetch_events;

  /// No description provided for @failed_to_register.
  ///
  /// In en, this message translates to:
  /// **'Failed to register'**
  String get failed_to_register;

  /// No description provided for @registered_successfully.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get registered_successfully;

  /// No description provided for @registration_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled'**
  String get registration_cancelled;

  /// No description provided for @failed_to_cancel_registration.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel registration'**
  String get failed_to_cancel_registration;

  /// No description provided for @invalid_event_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid event format'**
  String get invalid_event_format;

  /// No description provided for @failed_to_fetch_event.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch event'**
  String get failed_to_fetch_event;

  /// No description provided for @failed_to_fetch_leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch leaderboard'**
  String get failed_to_fetch_leaderboard;

  /// No description provided for @failed_to_get_member_status.
  ///
  /// In en, this message translates to:
  /// **'Failed to get member status'**
  String get failed_to_get_member_status;

  /// No description provided for @failed_to_fetch_event_results.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch event results'**
  String get failed_to_fetch_event_results;

  /// No description provided for @something_went_wrong_tracks.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while fetching tracks.'**
  String get something_went_wrong_tracks;

  /// No description provided for @something_went_wrong_track_details.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while fetching track details.'**
  String get something_went_wrong_track_details;

  /// No description provided for @something_went_wrong_track_events.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while fetching track events.'**
  String get something_went_wrong_track_events;

  /// No description provided for @event_label.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event_label;

  /// No description provided for @failed_to_fetch_summary.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch completed summary'**
  String get failed_to_fetch_summary;

  /// No description provided for @minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutes_ago(Object count);

  /// No description provided for @hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hours_ago(Object count);

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String days_ago(Object count);

  /// No description provided for @challenge_title.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge_title;

  /// No description provided for @recently_posted.
  ///
  /// In en, this message translates to:
  /// **'Recently posted'**
  String get recently_posted;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enter_your_name;

  /// No description provided for @enter_your_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get enter_your_phone;

  /// No description provided for @enter_your_street_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your street address'**
  String get enter_your_street_address;

  /// No description provided for @enter_your_area.
  ///
  /// In en, this message translates to:
  /// **'Enter your area'**
  String get enter_your_area;

  /// No description provided for @enter_your_emirate.
  ///
  /// In en, this message translates to:
  /// **'Enter your emirate'**
  String get enter_your_emirate;

  /// No description provided for @enter_your_city.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enter_your_city;

  /// No description provided for @enter_your_country.
  ///
  /// In en, this message translates to:
  /// **'Enter your country'**
  String get enter_your_country;

  /// No description provided for @intermediate_rider.
  ///
  /// In en, this message translates to:
  /// **'Intermediate rider'**
  String get intermediate_rider;

  /// No description provided for @uv_title_high.
  ///
  /// In en, this message translates to:
  /// **'High UV Alert'**
  String get uv_title_high;

  /// No description provided for @uv_title_advisory.
  ///
  /// In en, this message translates to:
  /// **'UV Advisory'**
  String get uv_title_advisory;

  /// No description provided for @uv_title_update.
  ///
  /// In en, this message translates to:
  /// **'UV Update'**
  String get uv_title_update;

  /// No description provided for @uv_message.
  ///
  /// In en, this message translates to:
  /// **'UV index is {index} today. Avoid midday rides, bring water and sunscreen.'**
  String uv_message(Object index);

  /// No description provided for @wind_title_advisory.
  ///
  /// In en, this message translates to:
  /// **'Wind Advisory'**
  String get wind_title_advisory;

  /// No description provided for @wind_title_update.
  ///
  /// In en, this message translates to:
  /// **'Wind Update'**
  String get wind_title_update;

  /// No description provided for @wind_message.
  ///
  /// In en, this message translates to:
  /// **'Wind speed is {speed} km/h right now. Ride with caution.'**
  String wind_message(Object speed);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
