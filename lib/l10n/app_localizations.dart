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
