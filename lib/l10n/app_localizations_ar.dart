// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get findRide => 'اعثر على رحلة';

  @override
  String get home_profileName => 'أحمد المنصوري';

  @override
  String get home_profileLocation => 'مدينة أبوظبي';

  @override
  String get home_currentLocationLabel => 'الموقع الحالي';

  @override
  String home_weatherHighLow(Object high, Object low) {
    return 'العظمى $high°C   الصغرى $low°C';
  }

  @override
  String get home_contentPlaceholder => 'محتوى الصفحة الرئيسية';

  @override
  String get cityAbuDhabi => 'أبوظبي';

  @override
  String get highTemp => 'ع';

  @override
  String get lowTemp => 'ص';

  @override
  String get temperatureUnit => '°م';

  @override
  String get choose => 'اختر الخاص بك';

  @override
  String get language => 'لغة';

  @override
  String get language_screen_title => 'مرحبًا بكم في\nنادي أبوظبي للدراجات';

  @override
  String get language_label_english => 'الإنجليزية';

  @override
  String get language_label_arabic => 'العربية';

  @override
  String get community_heading1 => 'انضم إلى المسؤول';

  @override
  String get community_heading2 => 'مجتمع أبو ظبي للدراجات';

  @override
  String get phone_action_card => 'تواصل مع الهاتف';

  @override
  String get email_action_card => 'أدخل بريدك الإلكتروني';

  @override
  String get create_button => 'إنشاء حساب';

  @override
  String get sign_in_option => 'أو قم بتسجيل الدخول باستخدام';

  @override
  String get policy =>
      'بمتابعتك، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا.';

  @override
  String get create_account_heading => 'أنشئ حسابك';

  @override
  String get create_account_title => 'انضم إلى مجتمع راكبي الدراجات اليوم';

  @override
  String get phone_number_placeholder => 'أدخل رقم هاتفك المحمول';

  @override
  String get continue_button => 'يكمل';

  @override
  String get login_link => 'هل لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get error_required_number => 'رقم الهاتف مطلوب';

  @override
  String get error_valid_number => 'أدخل رقم هاتف صحيح';
}
