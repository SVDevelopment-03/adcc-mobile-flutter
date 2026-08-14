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
  /// **'language'**
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
  /// **'Above AED 200'**
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
