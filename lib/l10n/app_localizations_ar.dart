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
  String get otp_verify_your_number => 'تحقق من رقمك';

  @override
  String get otp_enter_code_sent =>
      'أدخل الرمز المكون من 6 أرقام الذي تم إرساله إليك';

  @override
  String get otp_sent_mobile_number =>
      'لقد أرسلنا رمز OTP إلى رقم هاتفك المحمول';

  @override
  String get otp_enter_valid_6_digit => 'أدخل رمز OTP صالحًا مكونًا من 6 أرقام';

  @override
  String get otp_resend_in => 'إعادة إرسال رمز OTP خلال ';

  @override
  String get otp_resend_now => 'الآن';

  @override
  String get otp_seconds => 'ثانية';

  @override
  String get otp_resend_failed => 'فشل إعادة إرسال رمز OTP';

  @override
  String get otp_failed_default => 'فشل';

  @override
  String get create_account_heading => 'أنشئ حسابك';

  @override
  String get create_account_title => 'انضم إلى مجتمع راكبي الدراجات اليوم';

  @override
  String get phone_number_placeholder => 'أدخل رقم هاتفك المحمول';

  @override
  String get continue_button => 'متابعة';

  @override
  String get login_link => 'هل لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get error_required_number => 'رقم الهاتف مطلوب';

  @override
  String get error_valid_number => 'أدخل رقم هاتف صحيح';

  @override
  String get otp_too_many_attempts =>
      'محاولات OTP كثيرة جدًا من هذا الجهاز. يرجى الانتظار والمحاولة مرة أخرى لاحقًا.';

  @override
  String get otp_failed => 'فشل OTP';

  @override
  String get google_login_failed => 'فشل تسجيل الدخول عبر Google';

  @override
  String get facebook_login_failed => 'فشل تسجيل الدخول عبر Facebook';

  @override
  String get error_prefix => 'خطأ:';

  @override
  String get login_to_your_account => 'تسجيل الدخول إلى حسابك';

  @override
  String get or_continue_with => 'أو متابعة باستخدام';

  @override
  String get dont_have_account => 'ليس لديك حساب؟ ';

  @override
  String get sign_up => 'إنشاء حساب';

  @override
  String get register_ride_connect => 'اركب. تواصل.';

  @override
  String get register_join_community =>
      'انضم إلى أفضل تطبيق مجتمعي للدراجات في أبوظبي';

  @override
  String get register_skip_continue_as => 'تخطي والمتابعة كـ';

  @override
  String get register_continue_with_mobile => 'المتابعة برقم الهاتف';

  @override
  String get register_continue_as_guest => 'المتابعة كضيف';

  @override
  String get register_policy_text =>
      'بمتابعتك، فإنك توافق على شروط خدمة ADCycling وسياسة الخصوصية';

  @override
  String get create_account_phone_prompt =>
      'أدخل رقم هاتفك للمتابعة.\nسنرسل لك رمز OTP للتحقق.';

  @override
  String get guest_login_failed => 'فشل تسجيل الدخول كضيف';

  @override
  String get common_or => 'أو';

  @override
  String get profile_setup_title => 'إعداد ملفك الشخصي';

  @override
  String get profile_full_name_hint => 'أدخل اسمك الكامل';

  @override
  String get profile_full_name_required => 'اسمك الكامل مطلوب';

  @override
  String get profile_email_hint => 'أدخل بريدك الإلكتروني';

  @override
  String get profile_email_required => 'البريد الإلكتروني مطلوب';

  @override
  String get profile_email_invalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get profile_birth_date_placeholder => 'اختر تاريخ ميلادك';

  @override
  String get profile_gender_placeholder => 'اختر جنسك';

  @override
  String get profile_country_placeholder => 'اختر بلدك';

  @override
  String get profile_city_placeholder => 'اختر مدينتك';

  @override
  String get profile_cities_loading => 'المدن قيد التحميل';

  @override
  String get profile_gender_male => 'ذكر';

  @override
  String get profile_gender_female => 'أنثى';

  @override
  String get profile_gender_prefer_not_to_say => 'أفضل عدم الإفصاح';

  @override
  String get profile_country_uae => 'الإمارات';

  @override
  String get profile_country_saudi_arabia => 'السعودية';

  @override
  String get profile_country_qatar => 'قطر';

  @override
  String get profile_country_oman => 'عمان';

  @override
  String get profile_country_kuwait => 'الكويت';

  @override
  String get profile_country_bahrain => 'البحرين';

  @override
  String get profile_terms_prefix => 'لقد قرأت ووافقت على ';

  @override
  String get profile_terms_and => ' و ';

  @override
  String get profile_terms_user_agreement => 'اتفاقية المستخدم';

  @override
  String get profile_terms_privacy_policy => 'سياسة الخصوصية';

  @override
  String get profile_select_birth_date => 'يرجى اختيار تاريخ ميلادك';

  @override
  String get profile_select_gender => 'يرجى اختيار جنسك';

  @override
  String get profile_select_country => 'يرجى اختيار بلدك';

  @override
  String get profile_select_city => 'يرجى اختيار مدينتك';

  @override
  String get profile_accept_terms => 'يرجى قبول الشروط والأحكام للمتابعة.';

  @override
  String get profile_registration_failed => 'فشل التسجيل';

  @override
  String get event_registration_only_logged_in =>
      'التسجيل في الحدث متاح فقط للمستخدمين المسجلين دخولهم.';

  @override
  String get login_to_continue => 'تسجيل الدخول للمتابعة';

  @override
  String get event_id_missing_message =>
      'معرّف الحدث مفقود. يرجى فتح الحدث من صفحة التفاصيل.';

  @override
  String get common_go_back => 'عودة';

  @override
  String get common_retry => 'إعادة المحاولة';

  @override
  String get you_already_registered_for_event =>
      'أنت مسجل بالفعل في هذا الحدث.';

  @override
  String get personal_information => 'المعلومات الشخصية';

  @override
  String get field_full_name => 'الاسم الكامل *';

  @override
  String get field_email_address => 'البريد الإلكتروني *';

  @override
  String get field_phone_number => 'رقم الهاتف *';

  @override
  String get field_blood_group => 'فصيلة الدم *';

  @override
  String get select_country => 'اختر الدولة';

  @override
  String get cycling_information => 'معلومات ركوب الدراجات';

  @override
  String get field_have_bike => 'هل لديك دراجة خاصة بك؟';

  @override
  String get field_bike_type => 'نوع الدراجة *';

  @override
  String get select_bike_type => 'اختر نوع الدراجة';

  @override
  String get select_option => 'اختر خيار';

  @override
  String get event_id_not_found =>
      'لم يتم العثور على معرف الحدث. يرجى إعادة فتح الحدث.';

  @override
  String get complete_required_fields => 'يرجى إكمال جميع الاختيارات المطلوبة.';

  @override
  String get please_select_have_bike =>
      'يرجى تحديد ما إذا كان لديك دراجة خاصة بك.';

  @override
  String get already_joined_for_event => 'أنت مشترك بالفعل في هذا الحدث.';

  @override
  String get product_details => 'تفاصيل المنتج';

  @override
  String get unable_to_load_product_details => 'تعذر تحميل تفاصيل المنتج.';

  @override
  String get community_details => 'تفاصيل المجتمع';

  @override
  String get unable_to_load_community_details => 'تعذر تحميل تفاصيل المجتمع.';

  @override
  String get location_services_disabled => 'خدمات الموقع معطلة. يرجى تفعيلها.';

  @override
  String get location_permissions_denied => 'تم رفض أذونات الموقع.';

  @override
  String get location_permissions_permanently_denied =>
      'تم رفض أذونات الموقع بشكل دائم. يرجى تفعيلها في الإعدادات.';

  @override
  String get delete_account_title => 'حذف الحساب';

  @override
  String get deleting_account => 'جارٍ حذف الحساب...';

  @override
  String get delete_account_message =>
      'هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get delete_account_cancel => 'إلغاء';

  @override
  String get delete_account_confirm => 'حذف';

  @override
  String get account_deleted_successfully => 'تم حذف الحساب بنجاح';

  @override
  String get failed_delete_account => 'فشل حذف الحساب. يرجى المحاولة مرة أخرى.';

  @override
  String get challenge_complete_title => 'التحدي مكتمل!';

  @override
  String get challenge_difficulty_question => 'كيف كانت الصعوبة؟';

  @override
  String get challenge_difficulty_too_easy => 'سهل جدًا';

  @override
  String get challenge_difficulty_just_right => 'مناسب';

  @override
  String get challenge_difficulty_too_hard => 'صعب جدًا';

  @override
  String get challenge_rate_experience => 'قيّم تجربتك';

  @override
  String get challenge_how_was_your_experience => 'كيف كانت تجربتك؟';

  @override
  String get challenge_enjoyment_question => 'ماذا استمتعت به؟';

  @override
  String get challenge_enjoyment_great_challenge => 'تحدي رائع';

  @override
  String get challenge_enjoyment_perfect_difficulty => 'صعوبة مثالية';

  @override
  String get challenge_enjoyment_motivating => 'محفّز';

  @override
  String get challenge_enjoyment_achievable_goals => 'أهداف قابلة للتحقيق';

  @override
  String get challenge_additional_thoughts => 'آراء إضافية';

  @override
  String get challenge_thoughts_hint => 'شارك تفاصيل عن تجربتك.';

  @override
  String get challenge_achievements_unlocked => 'الإنجازات التي تم فتحها';

  @override
  String get challenge_badge_completed => 'تم إكمال التحدي';

  @override
  String challenge_completed_title(Object challengeTitle) {
    return 'أكملت \"$challengeTitle\"';
  }

  @override
  String challenge_reward_points_value(Object rewardPoints) {
    return '+$rewardPoints نقطة مكافأة';
  }

  @override
  String get challenge_reward_points_missing => 'نقاط مكافأة غير متاحة';

  @override
  String get challenge_reward_points_added => 'تمت إضافتها إلى حسابك';

  @override
  String get challenge_reward_badge_title => 'شارة المكافأة';

  @override
  String get challenge_reward_badge_description =>
      'حصلت على مكافأة لإكمال هذا التحدي.';

  @override
  String get challenge_share_button => 'شارك تحديك';

  @override
  String get challenge_share_subject => 'تحقق من تحديّ على ADCC';

  @override
  String get challenge_joined => 'منضم';

  @override
  String get challenge_join_now => 'انضم إلى التحدي';

  @override
  String get challenge_mark_complete => 'وضع علامة مكتمل';

  @override
  String get challenge_progress_incomplete => 'التقدم غير مكتمل';

  @override
  String get challenge_join_failed => 'فشل الانضمام إلى التحدي';

  @override
  String get challenge_complete_requirement =>
      'يمكنك تحديد التحدي مكتمل فقط بعد الوصول إلى التقدم المطلوب.';

  @override
  String get challenge_update_failed => 'فشل تحديث تقدم التحدي';

  @override
  String get challenge_registered_title => 'أنت مسجّل!';

  @override
  String challenge_registered_message(Object title) {
    return 'انضممت إلى \"$title\" بنجاح. استعد للتحدي!';
  }

  @override
  String get challenge_view_all => 'عرض الكل';

  @override
  String get challenge_no_performers =>
      'لا يوجد متسابقون بعد. انضم إلى التحدي لتظهر هنا.';

  @override
  String get challenge_progress => 'التقدم';

  @override
  String challenge_days_left(Object daysLeft) {
    return '$daysLeft يومًا متبقيًا';
  }

  @override
  String get challenge_joined_label => 'منضم';

  @override
  String get challenge_days_left_label => 'الأيام المتبقية';

  @override
  String get challenge_points_label => 'النقاط';

  @override
  String get challenge_active_challenges => 'التحديات النشطة';

  @override
  String get challenge_leaderboard => 'المتصدرون';

  @override
  String get challenge_search_events => 'البحث عن الفعاليات...';

  @override
  String get challenge_no_active_challenges => 'لم يتم العثور على تحديات نشطة';

  @override
  String get challenge_no_recent_challenges => 'لا توجد تحديات حديثة';

  @override
  String get challenge_recent_challenges => 'التحديات الأخيرة';

  @override
  String get challenge_connect_devices => 'ربط الأجهزة';

  @override
  String get challenge_top_riders_this_month => 'أفضل الدراجين هذا الشهر';

  @override
  String get challenge_no_riders_found => 'لم يتم العثور على أي دراجين';

  @override
  String challenge_your_month_stats(Object monthName) {
    return 'إحصائياتك لشهر $monthName';
  }

  @override
  String get challenge_total_km => 'إجمالي الكيلومترات';

  @override
  String get challenge_rides => 'الرحلات';

  @override
  String get challenge_rank_change => 'تغير الرتبة';

  @override
  String get my_challenges_title => 'تحدياتي';

  @override
  String get my_challenges_no_challenges => 'لا توجد تحديات بعد';

  @override
  String get challenge_tab_completed => 'مكتمل';

  @override
  String get challenge_tab_upcoming => 'قادم';

  @override
  String get challenge_tab_cancelled => 'ملغي';

  @override
  String get cart_title => 'سلة مشترياتي';

  @override
  String get removed_from_cart => 'تمت الإزالة من السلة';

  @override
  String get cart_empty_message =>
      'أضف عناصر من متجر النادي واستعرضها هنا قبل الخروج.';

  @override
  String get cart_continue_shopping => 'مواصلة التسوق';

  @override
  String get checkout_title => 'الدفع';

  @override
  String get order_summary => 'ملخص الطلب';

  @override
  String get delivery_address => 'عنوان التوصيل';

  @override
  String get payment_method => 'طريقة الدفع';

  @override
  String get order_notes => 'ملاحظات الطلب';

  @override
  String get price_details => 'تفاصيل السعر';

  @override
  String get cart_empty_title => 'سلة التسوق فارغة';

  @override
  String get order_place_failed => 'فشل في إرسال الطلب';

  @override
  String get payment_credit_title => 'بطاقة ائتمان/خصم';

  @override
  String get payment_credit_sub => 'فيزا، ماستركارد، أمريكان اكسبريس';

  @override
  String get payment_apple_title => 'آبل باي';

  @override
  String get payment_apple_sub => 'بصمة أو تعرف على الوجه';

  @override
  String get payment_tabby_title => 'تابي - الدفع على 4';

  @override
  String get payment_tabby_sub => 'قسّم المبلغ على 4 دفعات';

  @override
  String get payment_cod_title => 'الدفع عند الاستلام';

  @override
  String get payment_cod_sub => 'ادفع عند الاستلام';

  @override
  String get checkout_place_order => 'أرسل الطلب';

  @override
  String get checkout_terms =>
      'بتقديم الطلب فإنك توافق على الشروط والأحكام الخاصة بـ ADCC';

  @override
  String get club_store_title => 'متجر النادي';

  @override
  String get club_store_home => 'الرئيسية لمتجر النادي';

  @override
  String get color_not_set => 'اللون غير محدد';

  @override
  String get size_not_set => 'المقاس غير محدد';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String checkout_with_count(Object count) {
    return 'المتابعة (\$$count)';
  }

  @override
  String get colorLabel => 'اللون';

  @override
  String get sizeLabel => 'المقاس';

  @override
  String get selectedVariantOutOfStock => 'المتغير المحدد غير متوفر.';

  @override
  String maxAvailableQuantity(Object count) {
    return 'الكمية القصوى المتاحة هي $count.';
  }

  @override
  String get addedToCart => 'تمت الإضافة إلى السلة بنجاح';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح.';

  @override
  String get specificationsLabel => 'المواصفات';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get featureFreeDelivery => 'توصيل مجاني';

  @override
  String get featureFreeDeliverySub => 'فوق 200 درهم';

  @override
  String get featureEasyReturns => 'إرجاع سهل';

  @override
  String get featureEasyReturnsSub => 'سياسة 7 أيام';

  @override
  String get featureAuthentic => 'أصلي';

  @override
  String get featureAuthenticSub => 'دفع آمن';

  @override
  String get quantityLabel => 'الكمية :';

  @override
  String get addToCartLabel => 'أضف إلى السلة';

  @override
  String get downloadInvoice => 'تحميل الفاتورة';

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get orderConfirmedTitle => 'تم تأكيد الطلب!';

  @override
  String get thankYouForShopping => 'شكرًا لتسوقك مع ADCC';

  @override
  String productVariantInfo(Object color, Object quantity, Object size) {
    return '$color · $size · الكمية $quantity';
  }

  @override
  String get delivery => 'التوصيل';

  @override
  String get payment => 'طريقة الدفع';

  @override
  String get cardEnding => 'نهاية البطاقة';

  @override
  String get orderNote => 'ملاحظة الطلب';

  @override
  String orderNumber(Object orderNumber) {
    return 'الطلب #$orderNumber';
  }

  @override
  String get orderConfirmed => 'تم تأكيد الطلب';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get totalPaid => 'إجمالي المدفوع';

  @override
  String get failedToLoadMerchandise =>
      'فشل تحميل البضائع. يرجى المحاولة مرة أخرى.';

  @override
  String get latestProducts => 'أحدث المنتجات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get community_store => 'متجر المجتمع';

  @override
  String get recentlyPosted => 'تم النشر مؤخرًا';

  @override
  String get noMorePosts => 'لا مزيد من المشاركات';

  @override
  String get swipeBrowsePosts => 'اسحب لليسار أو اليمين لتصفح المنشورات.';

  @override
  String get like => 'إعجاب';

  @override
  String get nope => 'لا';

  @override
  String get noClubMerchandiseFound => 'لم يتم العثور على بضائع النادي.';

  @override
  String get featuredProducts => 'المنتجات المميزة';

  @override
  String get noFeaturedProducts => 'لا توجد منتجات مميزة متاحة.';

  @override
  String get merchandiseComingSoon => 'ستتوفر البضائع قريبًا';

  @override
  String get merchandiseHelpText =>
      'استخدم شريط البحث وشرائح الفئات أعلاه لاستعراض منتجات متجر النادي.';

  @override
  String get clubMerchandiseTitle => 'بضائع النادي';

  @override
  String get searchHint => 'ابحث عن فعاليات، مجتمعات، مدن، أو مسارات...';

  @override
  String get allCategory => 'الكل';

  @override
  String get viewStore => 'عرض المتجر';

  @override
  String get allProductsTitle => 'جميع المنتجات';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get exploreCommunity => 'استكشف المجتمع →';

  @override
  String get membersLabel => 'أعضاء';

  @override
  String get eventsLabel => 'فعاليات';

  @override
  String get categoryWomen => 'نساء';

  @override
  String get categoryYouth => 'شباب';

  @override
  String get categoryEndurance => 'تحمل';

  @override
  String get categoryFamilySocial => 'عائلي / اجتماعي';

  @override
  String get categorySocial => 'اجتماعي';

  @override
  String get categoryRacing => 'سباقات';

  @override
  String get welcomeToCommunity => 'مرحبًا بك في المجتمع!';

  @override
  String get youHaveSuccessfullyJoined => 'لقد انضممت بنجاح إلى';

  @override
  String get whatsNext => 'ما التالي؟';

  @override
  String get notificationsEnabled => 'الإشعارات مفعلة';

  @override
  String get notificationsComingSoon => 'ميزة الإشعارات قادمة قريبًا';

  @override
  String get joinCommunityChats => 'انضم إلى محادثات المجتمع';

  @override
  String get chatComingSoon => 'ميزة الدردشة قادمة قريبًا';

  @override
  String get upcomingEvents => 'الفعاليات القادمة';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String communityDescription(Object location) {
    return 'المجتمع الرئيسي لركوب الدراجات في $location، يجمع بين...';
  }

  @override
  String get locationLabel => 'الموقع';

  @override
  String get login_required_title => 'مطلوب تسجيل الدخول';

  @override
  String get login_required_message =>
      'يرجى تسجيل الدخول للوصول إلى هذه الميزة.';

  @override
  String get discover_adcc => 'اكتشف ADCC';

  @override
  String get explore_button => 'استكشف';

  @override
  String get welcome_guest => 'مرحبًا، زائر';

  @override
  String get could_not_load_feed => 'تعذر تحميل الخلاصات';

  @override
  String get ride_in_abu_dhabi => 'اركب في أبوظبي';

  @override
  String get pleaseSelectReasonForLeaving => 'يرجى تحديد سبب المغادرة';

  @override
  String get youHaveLeftTheCommunity => 'لقد غادرت المجتمع';

  @override
  String get failedToLeaveCommunity => 'فشل في مغادرة المجتمع';

  @override
  String get leaveCommunityTitle => 'مغادرة المجتمع';

  @override
  String get leaveCommunitySubtitle =>
      'نأسف لرؤيتك تغادر.\nملاحظاتك تساعدنا على التحسن.';

  @override
  String get reasonLabel => 'السبب:';

  @override
  String get additionalFeedback => 'ملاحظات إضافية';

  @override
  String get tellUsMoreHint => 'أخبرنا المزيد....';

  @override
  String get leaving => 'جاري المغادرة...';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get reasonNotActiveAnymore => 'لم يعد نشطًا';

  @override
  String get reasonScheduleConflict => 'تعارض في الجدول';

  @override
  String get reasonNotMatchingInterest => 'المجتمع لا يطابق اهتمامي';

  @override
  String get reasonFoundAnotherCommunity => 'وجدت مجتمعًا آخر';

  @override
  String get reasonTemporaryBreak => 'استراحة مؤقتة';

  @override
  String get reasonOther => 'أخرى';

  @override
  String get myCommunitiesTitle => 'مجتمعاتي';

  @override
  String get noCommunitiesFound => 'لم يتم العثور على مجتمعات';

  @override
  String get typeLabel => 'النوع';

  @override
  String get communityLabel => 'المجتمع';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get trackLabel => 'المسار';

  @override
  String get organizedBy => 'تنظيم';

  @override
  String get viewCommunity => 'عرض المجتمع';

  @override
  String get eventSchedule => 'جدول الفعالية';

  @override
  String get participantsPreview => 'معاينة المشاركين';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String ridersRegistered(Object count) {
    return '$count متسابق مسجل';
  }

  @override
  String get loginToRegister => 'سجّل الدخول للتسجيل';

  @override
  String get viewPastResult => 'عرض النتائج السابقة';

  @override
  String get joinEvent => 'انضم إلى الحدث';

  @override
  String get guestCannotRegister =>
      'الضيوف لا يمكنهم الوصول إلى تسجيل الفعالية. يرجى تسجيل الدخول للمتابعة.';

  @override
  String get cancelledSuccessfully => 'تم الإلغاء بنجاح';

  @override
  String get cancelRegistration => 'إلغاء التسجيل';

  @override
  String get aboutThisEvent => 'حول هذه الفعالية';

  @override
  String get quickInfo => 'معلومات سريعة';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get maxRidersLabel => 'أقصى عدد متسابقين';

  @override
  String get registeredLabel => 'المسجلون';

  @override
  String get registrationLabel => 'التسجيل';

  @override
  String get whoCanJoin => 'من يمكنه الانضمام';

  @override
  String ageWithPlus(Object age) {
    return 'العمر: $age+';
  }

  @override
  String get helmetRequired => 'الخُوذة مطلوبة';

  @override
  String get helmetNotRequired => 'الخُوذة غير مطلوبة';

  @override
  String get roadBikeMandatory => 'دراجة طريق\n(إلزامي)';

  @override
  String get roadBikeNotMandatory => 'دراجة الطريق غير مطلوبة';

  @override
  String experienceLabel(Object level) {
    return 'الخبرة: $level';
  }

  @override
  String genderLabel(Object gender) {
    return 'النوع: $gender';
  }

  @override
  String get search => 'بحث...';

  @override
  String get amenities => 'وسائل الراحة';

  @override
  String get rewardsAndBadges => 'المكافآت والشارات';

  @override
  String get requiredGear => 'المعدات المطلوبة';

  @override
  String get helmetMandatory => 'خوذة\n(إلزامي)';

  @override
  String get helmetRecommended => 'خوذة\n(مستحسن)';

  @override
  String get frontRearLights => 'أمام وخلف\nأضواء';

  @override
  String get roadBikeRecommended => 'دراجة طريق\n(مستحسن)';

  @override
  String get waterBottles => 'زجاجات\nالماء';

  @override
  String get doYouHaveBike => 'هل لديك دراجة؟';

  @override
  String get races => 'سباقات';

  @override
  String get communityRides => 'جولات\nالمجتمع';

  @override
  String get trainingClinics => 'تدريب و\nإرشادات';

  @override
  String get awarenessRides => 'جولات\nالتوعية';

  @override
  String get corporateEvents => 'فعاليات\nالشركات';

  @override
  String get nationalEvents => 'فعاليات\nالوطنية';

  @override
  String get eventsByCategory => 'فعاليات حسب الفئة';

  @override
  String get communityHighlights => 'معالم المجتمع';

  @override
  String get eventsTab => 'فعاليات';

  @override
  String get tracksTab => 'المسارات';

  @override
  String get galleryTab => 'معرض';

  @override
  String get updatesTab => 'التحديثات';

  @override
  String get foundedLabel => 'سنة التأسيس';

  @override
  String get activeMembersLabel => 'الأعضاء النشطون';

  @override
  String get trackDistanceLabel => 'مسافة المسار';

  @override
  String get averageRideRatingLabel => 'متوسط تقييم الرحلة';

  @override
  String get free => 'مجاني';

  @override
  String get noEventsFound => 'لم يتم العثور على فعاليات';

  @override
  String get eventsByCategorySubtitle =>
      'فعاليات سباق تنافسية تنظمها مجتمعات ADCC';

  @override
  String get communityRidesSingle => 'جولة المجتمع';

  @override
  String get noUpcomingEvents => 'لا توجد فعاليات قادمة';

  @override
  String get familyAndKids => 'العائلة والأطفال';

  @override
  String get corporateShort => 'شركات';

  @override
  String get emergencyContact => 'جهة الاتصال في حالة الطوارئ';

  @override
  String get emergencyContactNameLabel => 'اسم جهة الاتصال في حالة الطوارئ *';

  @override
  String get emergencyContactNameHint => 'اسم جهة الاتصال';

  @override
  String get emergencyContactPhoneLabel => 'هاتف جهة الاتصال في حالة الطوارئ *';

  @override
  String get emergencyContactPhoneHint => '+971 50 123 4567';

  @override
  String get unknownEventTitle => 'اختبار تجريبي';

  @override
  String get unknownEventLocation => 'اختبار تجريبي';

  @override
  String get whenLabel => 'الوقت';

  @override
  String get defaultCity => 'أبوظبي';

  @override
  String get joinedLabel => 'منضم';

  @override
  String get defaultDate => '18 يوليو 2026';

  @override
  String get backToEvent => 'العودة إلى الحدث';

  @override
  String get checkYourEventSchedule => 'تحقق من جدول الأحداث\nخاصتك';

  @override
  String get chooseDateHint => 'اختر تاريخًا لمعرفة ما يحدث بعد ذلك.';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get failedToLoadJoinedEvents => 'فشل في تحميل الفعاليات المسجلة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterThisWeek => 'هذا الأسبوع';

  @override
  String get filterThisMonth => 'هذا الشهر';

  @override
  String get filterLater => 'لاحقًا';

  @override
  String get failedToLoadUpcomingEvents => 'فشل في تحميل الفعاليات القادمة';

  @override
  String get upcomingEventsSubtitle =>
      'أقرب الجولات والسباقات وجلسات التدريب في تقويم ADCC';

  @override
  String get noRewardsAvailable => 'لا توجد مكافآت متاحة';

  @override
  String get riderCheckIn => 'تسجيل وصول المتسابقين';

  @override
  String get safetyBriefing => 'الإحاطة الأمنية';

  @override
  String get raceStart => 'بداية السباق';

  @override
  String get finalLap => 'اللفة الأخيرة';

  @override
  String get finish => 'النهاية';

  @override
  String get awardsCeremony => 'حفل توزيع الجوائز';

  @override
  String get facilityWater => 'ماء';

  @override
  String get facilityToilets => 'دورات مياه';

  @override
  String get facilityParking => 'موقف سيارات';

  @override
  String get facilityMedical => 'طبي';

  @override
  String get facilityLights => 'إضاءات';

  @override
  String get communityInfoNotAvailable => 'معلومات المجتمع غير متوفرة';

  @override
  String get invalidCommunityId => 'معرّف المجتمع غير صالح';

  @override
  String get failedToLoadCommunity => 'فشل تحميل المجتمع';

  @override
  String get pleaseSignInToJoinCommunities =>
      'يرجى تسجيل الدخول للانضمام إلى المجتمعات.';

  @override
  String get communityJoinedSuccessfully => 'تم الانضمام إلى المجتمع بنجاح! 🎉';

  @override
  String get joinFailed => 'فشل الانضمام';

  @override
  String get communityLeftSuccessfully => 'تم مغادرة المجتمع بنجاح';

  @override
  String get points => 'نقاط';

  @override
  String get joinChecking => 'جارٍ التحقق...';

  @override
  String get community_no_upcoming_events =>
      'لا توجد فعاليات قادمة لهذا المجتمع';

  @override
  String get community_no_gallery_images => 'لا توجد صور معرض متاحة';

  @override
  String get community_no_track_data => 'لا توجد بيانات مسار متاحة';

  @override
  String get community_no_updates => 'لا توجد تحديثات للمجتمع بعد';

  @override
  String get pleaseSelectReason => 'يرجى اختيار سبب';

  @override
  String get cancelFailed => 'فشل الإلغاء';

  @override
  String get cancelRegistrationSubtitle => 'يرجى إخبارنا بسبب\nإلغائك';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get noLeaderboardData => 'لا توجد بيانات المتصدرين متاحة بعد';

  @override
  String get failedToLoadEventDetails => 'فشل تحميل تفاصيل الفعالية.';

  @override
  String get failedToLoadEventOrProfile =>
      'فشل تحميل بيانات الفعالية أو الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get failedToCompleteRegistration => 'فشل إكمال التسجيل.';

  @override
  String get hintFullName => 'الاسم الكامل';

  @override
  String get hintEmailAddress => 'البريد الإلكتروني';

  @override
  String get hintPhoneNumber => 'رقم الهاتف';

  @override
  String get pleaseSelectBloodGroup => 'يرجى اختيار فصيلة الدم';

  @override
  String get countryLabel2 => 'الدولة *';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get bikeTypeRoad => 'دراجة طريق';

  @override
  String get bikeTypeMountain => 'دراجة جبلية';

  @override
  String get bikeTypeHybrid => 'دراجة هجينة';

  @override
  String get alreadyJoined => 'منضم بالفعل';

  @override
  String get completeRegistration => 'إكمال التسجيل';

  @override
  String get joinEventTerms =>
      'أوافق على الشروط وأؤكد أن جميع المعلومات\nالمقدمة دقيقة. أتفهم متطلبات السلامة وسألتزم\nبجميع إرشادات الفعالية.';

  @override
  String get purposeBasedEvents => 'فعاليات حسب الغرض';

  @override
  String get noPurposeBasedEvents => 'لم يتم العثور على فعاليات حسب الغرض';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get ownBike => 'دراجة خاصة';

  @override
  String get bikeType => 'نوع الدراجة';

  @override
  String get emergencyPhone => 'هاتف الطوارئ';

  @override
  String get youAreRegistered => 'أنت مسجل!';

  @override
  String get getReadyForRide => 'استعد لرحلة رائعة مع\nالمجتمع!';

  @override
  String get addToCalendar => 'أضف إلى التقويم';

  @override
  String get shareWithFriends => 'شارك مع الأصدقاء';

  @override
  String get viewMyEvents => 'عرض فعالياتي';

  @override
  String get returnToHome => 'العودة إلى الرئيسية';

  @override
  String get eventLocation => 'موقع الفعالية';

  @override
  String get yourRegistration => 'تسجيلك';

  @override
  String get unableToBuildCalendarLink => 'تعذر إنشاء رابط التقويم.';

  @override
  String get calendarLinkOpened => 'تم فتح رابط التقويم بنجاح.';

  @override
  String get unableToOpenCalendarLink => 'تعذر فتح رابط التقويم.';

  @override
  String registeredForEvent(Object title) {
    return 'لقد سجلت للتو في $title.';
  }

  @override
  String get registrationCopied => 'تم نسخ تفاصيل التسجيل إلى الحافظة.';

  @override
  String get myEvents => 'فعالياتي';

  @override
  String get failedToLoadEvents => 'فشل تحميل الفعاليات';

  @override
  String get noCancelledEvents => 'لا توجد فعاليات ملغاة';

  @override
  String get cancelledEventsHint => 'ستظهر الفعاليات الملغاة هنا عند توفرها.';

  @override
  String get eventHistoryHint => 'سيظهر سجل فعالياتك هنا بمجرد تحميل البيانات.';

  @override
  String get loadingSearchResults => 'جارٍ تحميل نتائج البحث...';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get noNotificationsYet => 'لا توجد إشعارات بعد';

  @override
  String get anErrorOccurred => 'حدث خطأ';

  @override
  String get myCyclingDetails => 'تفاصيل ركوب الدراجات الخاصة بي';

  @override
  String get riderLevel => 'مستوى الدراج';

  @override
  String get totalDistance => 'المسافة الإجمالية';

  @override
  String get totalRides => 'إجمالي الرحلات';

  @override
  String get badgesEarned => 'الشارات المكتسبة';

  @override
  String get yourRidesAndEvents => 'رحلاتك وفعالياتك';

  @override
  String get noCompletedRidesYet => 'لا توجد رحلات مكتملة بعد';

  @override
  String get noJoinedCommunitiesYet => 'لا توجد مجتمعات منضم إليها بعد';

  @override
  String get yourListedGear => 'معداتك المدرجة';

  @override
  String get noListedGearYet => 'لا توجد معدات مدرجة بعد';

  @override
  String get citiesAreLoading => 'المدن لا تزال قيد التحميل';

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get noCompletedEventsYet => 'لا توجد فعاليات مكتملة بعد';

  @override
  String get noChallengesFound => 'لم يتم العثور على تحديات';

  @override
  String usePoints(Object points) {
    return 'استخدم $points نقطة';
  }

  @override
  String get failedToLoadTracks => 'فشل تحميل المسارات';

  @override
  String get noTracksFound => 'لم يتم العثور على مسارات';

  @override
  String get markAsSold => 'وضع علامة كمباع';

  @override
  String get markItemAsSoldQuestion =>
      'هل تريد وضع علامة على هذا العنصر كمباع؟';

  @override
  String get markedSold => 'تم وسمه كمباع';

  @override
  String get failed => 'فشل';

  @override
  String get delete => 'حذف';

  @override
  String get deleteListing => 'حذف الإعلان';

  @override
  String get deleteListingConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذا الإعلان؟';

  @override
  String get loginToPostOrLike =>
      'يرجى تسجيل الدخول للنشر أو الإعجاب بالتحديثات.';

  @override
  String get tapMapToSelectLocation => 'انقر على الخريطة لاختيار موقع.';

  @override
  String get selectLocation => 'اختر الموقع';

  @override
  String get postSubmittedForApproval => 'تم إرسال المنشور للموافقة';

  @override
  String get noEventsAvailable => 'لا توجد فعاليات متاحة';

  @override
  String get selectAnEvent => 'اختر فعالية';

  @override
  String get noTracksAvailable => 'لا توجد مسارات متاحة';

  @override
  String get selectATrack => 'اختر مسارًا';

  @override
  String get fillAllRequiredFields => 'يرجى ملء جميع حقول الإعلان المطلوبة';

  @override
  String get pleaseSelectCity => 'يرجى اختيار مدينة';

  @override
  String get pleaseSelectContactMethod => 'يرجى اختيار طريقة التواصل';

  @override
  String get phoneRequiredForContactMethod =>
      'رقم الهاتف مطلوب لطريقة التواصل المحددة';

  @override
  String get uploadAtLeastOnePhoto => 'يرجى تحميل صورة منتج واحدة على الأقل';

  @override
  String get listingUpdated => 'تم تحديث الإعلان';

  @override
  String get failedToSaveListing => 'فشل حفظ الإعلان';

  @override
  String get negotiable => 'قابل للتفاوض';

  @override
  String get sellerPhoneNotAvailable => 'هاتف البائع غير متوفر';

  @override
  String get cannotOpenWhatsApp => 'تعذر فتح واتساب';

  @override
  String get whatsappSeller => 'راسل البائع عبر واتساب';

  @override
  String get cannotMakeCall => 'تعذر إجراء المكالمة';

  @override
  String get sellYourProduct => 'بيع منتجك';

  @override
  String showingResults(Object count) {
    return 'عرض $count نتيجة';
  }

  @override
  String get filter => 'تصفية';

  @override
  String get filters => 'الفلاتر';

  @override
  String get minPriceAed => 'الحد الأدنى للسعر (درهم)';

  @override
  String get maxPriceAed => 'الحد الأقصى للسعر (درهم)';

  @override
  String get cityOptional => 'المدينة (اختياري)';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortPriceLowHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get sortPriceHighLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get apply => 'تطبيق';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get community => 'المجتمع';

  @override
  String get tracks => 'المسارات';

  @override
  String get challenges => 'التحديات';

  @override
  String get marketplace => 'السوق';

  @override
  String get bikeExperience => 'تجربة ركوب الدراجة';

  @override
  String get rideFeed => 'خلاصة الرحلات';

  @override
  String get clubStore => 'متجر النادي';

  @override
  String get nearbyTracks => 'مسارات قريبة';

  @override
  String get officialCyclingRoutes => 'مسارات ركوب الدراجات الرسمية';

  @override
  String get exploreSafeRoutes => 'استكشف مسارات آمنة في أنحاء أبوظبي';

  @override
  String get trackSafetyGuidelines => 'سلامة المسار والإرشادات';

  @override
  String get staySafeEveryRide => 'ابقَ آمنًا في كل رحلة';

  @override
  String get searchAcrossHint =>
      'ابحث في الفعاليات والمجتمعات والمسارات والمزيد.';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج.';

  @override
  String get members => 'أعضاء';

  @override
  String get soldBy => 'يُباع بواسطة';

  @override
  String get fetchingLocation => 'جارٍ جلب الموقع...';

  @override
  String get exploreByCity => 'استكشف حسب المدينة';

  @override
  String get officialCyclingTracks => 'مسارات ركوب\nالدراجات الرسمية';

  @override
  String get rideByStyle => 'اركب حسب الأسلوب';

  @override
  String get tracksNearYou => 'مسارات قريبة منك';

  @override
  String get routeDetailsPdf => 'تفاصيل المسار (PDF)';

  @override
  String get safetyGuidelinesPdf => 'إرشادات السلامة (PDF)';

  @override
  String get safetyInformation => 'معلومات السلامة';

  @override
  String get openInLinkMyRide => 'فتح في Link My Ride';

  @override
  String get openInMaps => 'فتح في الخرائط';

  @override
  String get startRide => 'ابدأ الرحلة';

  @override
  String get trackDetails => 'تفاصيل المسار';

  @override
  String get call => 'اتصال';

  @override
  String get searchMarketplace => 'ابحث في السوق...';

  @override
  String get availableAsGuest => 'متاح كضيف:';

  @override
  String get browseEvents => 'تصفح الفعاليات';

  @override
  String get exploreCommunityButton => 'استكشف المجتمع';

  @override
  String get viewTracks => 'عرض المسارات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updatePersonalInfo => 'تحديث معلوماتك الشخصية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get units => 'الوحدات';

  @override
  String get metricComingSoon => 'متري (كم، كجم)\nقريبًا!';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get rideGuidelinesEtiquette => 'إرشادات وآداب الرحلة';

  @override
  String get helpCenterComingSoon => 'مركز المساعدة (قريبًا!)';

  @override
  String get termsConditionsComingSoon => 'الشروط والأحكام (قريبًا!)';

  @override
  String get privacyPolicyComingSoon => 'سياسة الخصوصية (قريبًا!)';

  @override
  String get eventReminders => 'تذكيرات الفعاليات';

  @override
  String get eventRemindersSub => 'احصل على إشعار قبل بدء الفعاليات';

  @override
  String get communityUpdates => 'تحديثات المجتمع';

  @override
  String get communityUpdatesSub => 'منشورات وإعلانات جديدة';

  @override
  String get newMessages => 'رسائل جديدة';

  @override
  String get newMessagesSub => 'رسائل مباشرة من الدراجين';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get achievementsSub => 'عند فتح الشارات';

  @override
  String get myEventsAndCalendar => 'فعالياتي والتقويم';

  @override
  String get badgesAndAchievements => 'الشارات والإنجازات';

  @override
  String get myChallenges => 'تحدياتي';

  @override
  String get rewardsAndPoints => 'المكافآت والنقاط';

  @override
  String get settingsAndPreferences => 'الإعدادات والتفضيلات';

  @override
  String get myBadges => 'شاراتي';

  @override
  String get joinedEvents => 'الفعاليات المنضم إليها';

  @override
  String get distance => 'المسافة';

  @override
  String get time => 'الوقت';

  @override
  String get position => 'المركز';

  @override
  String get averageCompletionRate => 'متوسط\nمعدل الإنجاز';

  @override
  String get averageEventDistance => 'متوسط مسافة\nالحدث';

  @override
  String get bestCategory => 'أفضل فئة';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advancedLevel => 'متقدم';

  @override
  String get ambassador => 'سفير';

  @override
  String get latestAchievement => 'آخر إنجاز';

  @override
  String get completed => 'مكتمل';

  @override
  String get objective => 'هدف';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get full_name => 'الاسم الكامل';

  @override
  String get phone => 'هاتف';

  @override
  String get street_villa_apartment => 'الشارع / الفيلا / الشقة';

  @override
  String get area => 'المنطقة';

  @override
  String get emirate => 'الإمارة';

  @override
  String get card_last_4_digits => 'آخر 4 أرقام من البطاقة';

  @override
  String get additional_notes_optional => 'ملاحظات إضافية (اختيارية)';

  @override
  String get delivery_fee => 'رسوم التوصيل';

  @override
  String get join_failed => 'فشل الانضمام';

  @override
  String get category => 'الفئة';

  @override
  String get primary_track => 'المسار الأساسي';

  @override
  String get members_1 => 'الأعضاء';

  @override
  String get founded_year => 'سنة التأسيس';

  @override
  String get community_rides => 'جولات المجتمع';

  @override
  String get training_clinics => 'التدريب والعيادات';

  @override
  String get awareness_rides => 'جولات التوعية';

  @override
  String get corporate_events => 'فعاليات الشركات';

  @override
  String get national_events => 'فعاليات وطنية';

  @override
  String get completed_event_result => 'نتيجة الحدث المكتملة';

  @override
  String get rank => 'الرتبة';

  @override
  String get points_earned => 'النقاط المكتسبة';

  @override
  String get pointsearned => 'النقاط المكتسبة';

  @override
  String get badge => 'الشارة';

  @override
  String get trek_domane => 'تريك دومان';

  @override
  String get total_distance => 'المسافة الكلية';

  @override
  String get rides_this_month => 'مشاوير هذا الشهر';

  @override
  String get days_in_saddle => 'أيام في السرج';

  @override
  String get level_progress => 'مستوى التقدم';

  @override
  String get identity_score => 'درجة الهوية';

  @override
  String get style_badge => 'شارة النمط';

  @override
  String get your_cycling_journey_starts_here =>
      'تبدأ رحلتك لركوب الدراجات من هنا';

  @override
  String get join_the_ride_live_the_passion => 'انضم إلى الرحلة، عش الشغف';

  @override
  String get shop_share_with_cyclists => 'تسوق وشارك مع راكبي الدراجات';

  @override
  String get create_your_own_ride => 'أنشئ رحلتك الخاصة';

  @override
  String get badges_achivements => 'الشارات والإنجازات';

  @override
  String get ride => 'الرحلة';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get date_of_birth => 'تاريخ الميلاد';

  @override
  String get event_history => 'سجل الفعاليات';

  @override
  String get badges => 'الشارات';

  @override
  String get logging_out => 'تسجيل الخروج ...';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get back_to_feed => 'العودة إلى الخلاصة';

  @override
  String get add_photos_videos => 'أضف الصور ومقاطع الفيديو';

  @override
  String get write_your_experience => 'اكتب تجربتك';

  @override
  String get share_your_ride_event_experience =>
      'شارك تجربة رحلتك أو فعاليتك...';

  @override
  String get tag_event_optional => 'حدد الفعالية (اختياري)';

  @override
  String get select_event => 'اختر الفعالية';

  @override
  String get start_time => 'وقت البدء';

  @override
  String get special_instructions => 'تعليمات خاصة';

  @override
  String get tag_track_optional => 'حدد المسار (اختياري)';

  @override
  String get select_track => 'اختر المسار';

  @override
  String get location_optional => 'موقع (اختياري)';

  @override
  String get add_a_comment => 'أضف تعليقًا';

  @override
  String get pace => 'السرعة';

  @override
  String get featured => 'مميز';

  @override
  String get edit => 'تحرير';

  @override
  String get mark_sold => 'وضع علامة كمباع';

  @override
  String get deleted => 'محذوف';

  @override
  String get active_listings => 'الإعلانات النشطة';

  @override
  String get sold_items => 'العناصر المباعة';

  @override
  String get e_g_specialized_tarmac_sl7 => 'مثال: Specialized Tarmac SL7';

  @override
  String get select_category => 'اختر الفئة';

  @override
  String get select_condition => 'تحديد الحالة';

  @override
  String get lighting => 'الإضاءة';

  @override
  String get water_stataion => 'محطة المياه';

  @override
  String get restroom => 'دورات المياه';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'رحلتك في ركوب الدراجات تبدأ هنا';

  @override
  String get onboardingDesc1 =>
      'تتبع رحلاتك، واستكشف المسارات الخلابة، وانضم إلى الفعاليات، وتواصل مع مجتمع ركوب الدراجات في الإمارات.';

  @override
  String get onboardingTitle2 => 'انضم إلى الرحلة، وعِش الشغف';

  @override
  String get onboardingDesc2 =>
      'اكتشف مسارات ركوب الدراجات، وجولات المجتمع، والفعاليات المصممة لكل دراج.';

  @override
  String get onboardingTitle3 => 'تسوق وشارك مع الدراجين';

  @override
  String get onboardingDesc3 =>
      'تصفح معدات ركوب الدراجات، وتواصل مع زملائك الدراجين، ونمِّ مجموعة معداتك.';

  @override
  String get onboardingTitle4 => 'أنشئ رحلتك الخاصة';

  @override
  String get onboardingDesc4 =>
      'خطط للمسارات، وحدد الأهداف، وتتبع تقدمك لتركب لمسافات أبعد كل يوم.';

  @override
  String get about_me => 'عني';

  @override
  String get bio => 'نبذة';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get tell_us_about => 'أخبرنا عن نفسك وعن رحلتك في ركوب الدراجات...';

  @override
  String get select_date_of_birth => 'حدد تاريخ الميلاد';

  @override
  String get yourResult => 'نتيجتك';

  @override
  String get communities_using_track => 'المجتمعات التي تستخدم هذا المسار';

  @override
  String get error_loading_communities => 'خطأ في تحميل المجتمعات';

  @override
  String get no_communities_for_track => 'لا توجد مجتمعات لهذا المسار';

  @override
  String get tracks_description => 'وصف المسارات';

  @override
  String get upcoming_events_on_track => 'الفعاليات القادمة على هذا المسار';

  @override
  String get route_preview => 'معاينة المسار';

  @override
  String subtotal_items(Object count) {
    return 'المجموع الفرعي ($count عناصر)';
  }

  @override
  String get total_badges => 'إجمالي الشارات';

  @override
  String get total_points => 'إجمالي النقاط';

  @override
  String get total_events => 'إجمالي الفعاليات';

  @override
  String get podium_finishes => 'مرات الصعود للمنصة';

  @override
  String get earned_this_month => 'المكتسب هذا الشهر';

  @override
  String get reward_claimed => 'المكافآت المُستلمة';

  @override
  String get current_tier => 'المستوى الحالي';

  @override
  String get rewards_and_points => 'المكافآت والنقاط';

  @override
  String get earn_points_subtitle => 'اكسب النقاط بإكمال التحديات';

  @override
  String get distance_champion_badge => 'شارة بطل المسافة';

  @override
  String get earned_today => 'حُصِل عليه اليوم';

  @override
  String get reward_points_100 => '+100 نقطة مكافأة';

  @override
  String get added_to_your_account => 'أُضيفت إلى حسابك';

  @override
  String get challenge_top_performers => 'أفضل المؤدين';

  @override
  String get your_cycling_identity => 'هويتك في ركوب الدراجات';

  @override
  String get communities_in_your_city => 'المجتمعات في مدينتك';

  @override
  String get purpose_based_communities => 'مجتمعات حسب الغرض';

  @override
  String get most_active => 'الأكثر نشاطًا';

  @override
  String get most_members => 'الأكثر أعضاءً';

  @override
  String get recently_created => 'أُنشئت مؤخرًا';

  @override
  String get all_cycling_communities =>
      'جميع مجتمعات ركوب الدراجات النشطة بالقرب منك';

  @override
  String get communities_purpose_subtitle => 'مجتمعات مبنية على الهدف والأهداف';

  @override
  String get family_leisure => 'العائلة والترفيه';

  @override
  String get racing_performance => 'السباقات والأداء';

  @override
  String get women_sherides => 'النساء (SheRides)';

  @override
  String get youth_cycling => 'دراجات الشباب';

  @override
  String get social_weekend => 'اجتماعي / عطلة نهاية الأسبوع';

  @override
  String get night_riders => 'الدراجون الليليون';

  @override
  String get mtb_trail => 'الدراجات الجبلية / المسارات';

  @override
  String get awareness_charity => 'التوعية والأعمال الخيرية';

  @override
  String get challenge_completion_badge => 'شارة الإكمال';

  @override
  String get challenge_completion_badge_subtitle => 'عمل رائع لإتمامك التحدي!';

  @override
  String get challenge_your_progress => 'تقدمك';

  @override
  String get challenge_rules => 'قواعد التحدي';

  @override
  String challenge_progress_to_go(
      Object percentage, Object remaining, Object unit) {
    return '$percentage% متبقٍ • $remaining $unit متبقٍ';
  }

  @override
  String get month_january => 'يناير';

  @override
  String get month_february => 'فبراير';

  @override
  String get month_march => 'مارس';

  @override
  String get month_april => 'أبريل';

  @override
  String get month_may => 'مايو';

  @override
  String get month_june => 'يونيو';

  @override
  String get month_july => 'يوليو';

  @override
  String get month_august => 'أغسطس';

  @override
  String get month_september => 'سبتمبر';

  @override
  String get month_october => 'أكتوبر';

  @override
  String get month_november => 'نوفمبر';

  @override
  String get month_december => 'ديسمبر';

  @override
  String get reward_earned => 'المكافأة المكتسبة';

  @override
  String get failed_to_load_products =>
      'فشل تحميل المنتجات. يرجى المحاولة مرة أخرى.';

  @override
  String get no_products_found => 'لا توجد منتجات.';

  @override
  String get product_label => 'المنتج';

  @override
  String get join_community_button => 'انضم إلى المجتمع';

  @override
  String get not_available => 'غير متاح';

  @override
  String get share_community_fallback_title => 'اطّلع على هذا المجتمع';

  @override
  String get share_community_fallback_description =>
      'اكتشف هذا المجتمع على تطبيق ADCC.';

  @override
  String get share_community_footer =>
      'استكشفه على تطبيق نادي أبوظبي للدراجات.';

  @override
  String get share_community_subject => 'اطّلع على هذا المجتمع';

  @override
  String get gear => 'المعدات';

  @override
  String get event_badge_national => 'وطني';

  @override
  String get event_badge_corporate => 'شركات';

  @override
  String get event_badge_awareness => 'توعية';

  @override
  String get event_badge_training => 'تدريب';

  @override
  String get event_badge_race => 'سباق';

  @override
  String get event_badge_community_ride => 'جولة مجتمعية';

  @override
  String get event_badge_tbd => 'سيُحدد لاحقاً';

  @override
  String get riders_suffix => 'درّاجين';

  @override
  String get share_event_subject => 'اطّلع على هذه الفعالية على ADCC';

  @override
  String get failed_to_load_event_results => 'فشل تحميل نتائج الفعالية';

  @override
  String get leaderboard_top_10 => 'لوحة الصدارة (أفضل 10)';

  @override
  String get you_label => 'أنت';

  @override
  String get rider_label => 'درّاج';

  @override
  String get date_unavailable => 'التاريخ غير متاح';

  @override
  String get time_unavailable => 'الوقت غير متاح';

  @override
  String get time_am => 'ص';

  @override
  String get time_pm => 'م';

  @override
  String get month_short_jan => 'يناير';

  @override
  String get month_short_feb => 'فبراير';

  @override
  String get month_short_mar => 'مارس';

  @override
  String get month_short_apr => 'أبريل';

  @override
  String get month_short_may => 'مايو';

  @override
  String get month_short_jun => 'يونيو';

  @override
  String get month_short_jul => 'يوليو';

  @override
  String get month_short_aug => 'أغسطس';

  @override
  String get month_short_sep => 'سبتمبر';

  @override
  String get month_short_oct => 'أكتوبر';

  @override
  String get month_short_nov => 'نوفمبر';

  @override
  String get month_short_dec => 'ديسمبر';

  @override
  String get event_status_open => 'مفتوح';

  @override
  String get popular_communities => 'المجتمعات الشائعة';

  @override
  String get featured_events => 'فعاليات مميزة';

  @override
  String get view_all_label => 'عرض الكل';

  @override
  String get posted_by => 'نشر بواسطة ';

  @override
  String get choose_your_language => 'اختر\nلغتك';

  @override
  String get rider_level_membership => 'عضوية مستوى الدرّاج';

  @override
  String get your_communities => 'مجتمعاتك';

  @override
  String get explore_label => 'استكشف ›';

  @override
  String get just_now => 'الآن';

  @override
  String notification_type(Object type) {
    return 'النوع: $type';
  }

  @override
  String get notification_inbox => 'صندوق الإشعارات';

  @override
  String unread_notifications(Object count) {
    return '$count إشعارات غير مقروءة';
  }

  @override
  String get rider_level_locked => 'مقفل';

  @override
  String get unlocked_badges => 'الشارات المفتوحة';

  @override
  String get no_badges_available => 'لا توجد شارات متاحة بعد';

  @override
  String get failed_to_load_cycling_details => 'فشل تحميل تفاصيل ركوب الدراجات';

  @override
  String get unable_to_update_profile =>
      'تعذر تحديث الملف الشخصي. يرجى التحقق من بياناتك والمحاولة مرة أخرى.';

  @override
  String get unable_to_update_profile_generic =>
      'تعذر تحديث الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get completed_events => 'الفعاليات المكتملة';

  @override
  String get upcoming_events_section => 'الفعاليات القادمة';

  @override
  String get ride_completed => 'اكتملت الجولة!';

  @override
  String get settings_and_preferences_title => 'الإعدادات والتفضيلات';

  @override
  String get check_out_my_achievements => 'اطّلع على إنجازاتي على ADCC';

  @override
  String get navigate => 'تنقّل';

  @override
  String get performance_insights => 'رؤى الأداء';

  @override
  String get welcome_to_adcc => 'مرحباً بك في ADCC';

  @override
  String get sign_up_prompt =>
      'سجّل للانضمام إلى الفعاليات والتواصل مع المجتمع وتتبع رحلتك في ركوب الدراجات.';

  @override
  String get sign_up_login => 'تسجيل الدخول / إنشاء حساب';

  @override
  String get available_rewards => 'المكافآت المتاحة';

  @override
  String get claim_now => 'استلم الآن';

  @override
  String get additional_thoughts => 'أفكار إضافية';

  @override
  String get share_details_hint => 'شارك تفاصيل تجربتك.';

  @override
  String get new_badge_formed => 'شارة جديدة!';

  @override
  String get century_explorer => 'مستكشف القرن';

  @override
  String get share_your_photos_optional => 'شارك صورك (اختياري)';

  @override
  String get add_photo => 'أضف صورة';

  @override
  String get upload => 'رفع';

  @override
  String get share_your_ride => 'شارك جولتك';

  @override
  String get i_just_completed_ride => 'أكملت للتو جولة على ADCC';

  @override
  String get wrap_up_week => 'اختتام الأسبوع';

  @override
  String get great_job_completing_ride => 'عمل رائع على إكمال هذه الجولة!';

  @override
  String get duration => 'المدة';

  @override
  String get avg_speed => 'متوسط السرعة';

  @override
  String get calories => 'السعرات';

  @override
  String get elevation_gain => 'ارتفاع الكسب';

  @override
  String get account => 'الحساب';

  @override
  String get app_preferences => 'تفضيلات التطبيق';

  @override
  String get app_version => 'إصدار التطبيق';

  @override
  String get app_version_value => 'v1.0.0 (الإصدار 100)';

  @override
  String get ride_feed => 'موجز الجولات';

  @override
  String get join_abu_dhabi_community => 'انضم إلى مجتمع أبوظبي للدراجات!';

  @override
  String get post_your_ride => 'انشر جولتك';

  @override
  String earned_count(Object count) {
    return '$count تم الحصول عليها';
  }

  @override
  String completion_rate(Object value) {
    return 'اكتمال $value';
  }

  @override
  String get reward => 'مكافأة';

  @override
  String cycling_community_subtitle(Object trackName) {
    return 'مجتمع الدراجات • $trackName';
  }

  @override
  String get various_tracks => 'مسارات متنوعة';

  @override
  String get unknown_members => 'أعضاء غير معروفين';

  @override
  String members_count(Object count) {
    return '$count أعضاء';
  }

  @override
  String get elevation => 'الارتفاع';

  @override
  String get type_label => 'النوع';

  @override
  String get avg_time => 'متوسط الوقت';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get live => 'مباشر';

  @override
  String get cancelled => 'ملغى';

  @override
  String get route_permission_message =>
      'مطلوب إذن الموقع لتتبع مسارك. يرجى تفعيله في الإعدادات.';

  @override
  String get helmets_mandatory => 'الخوذة إلزامية.';

  @override
  String get safety_ride_early =>
      'انطلق في الصباح الباكر أو في وقت متأخر من المساء في الصيف.';

  @override
  String get safety_carry_water => 'احمل كمية كافية من الماء.';

  @override
  String get safety_follow_regulations => 'اتبع لوائح المرور وقواعد المسار.';

  @override
  String tracks_in_city(Object city) {
    return 'المسارات في $city';
  }

  @override
  String tracks_found(Object count) {
    return 'تم العثور على $count مسارات';
  }

  @override
  String get find_a_track => 'ابحث عن مسار';

  @override
  String get track => 'مسار';

  @override
  String get route => 'طريق';

  @override
  String get cycling_tracks_closest =>
      'مسارات الدراجات الأقرب إلى موقعك الحالي';

  @override
  String get official_cycling_tracks_title => 'مسارات الدراجات الرسمية';

  @override
  String get hill_elevation_training => 'تدريب التلال والمرتفعات';

  @override
  String get night_riding_routes => 'مسارات الركوب الليلي';

  @override
  String get sunrise_rides => 'جولات الشروق';

  @override
  String get family_youth_friendly => 'مناسب للعائلة والشباب';

  @override
  String routes_count(Object count) {
    return '$count مسارات';
  }

  @override
  String get product_photos => 'صور المنتج';

  @override
  String get product_name => 'اسم المنتج';

  @override
  String get condition => 'الحالة';

  @override
  String get currency => 'العملة';

  @override
  String get price => 'السعر';

  @override
  String get preferred_contact_method => 'طريقة التواصل المفضلة';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get select_contact_method => 'اختر طريقة التواصل';

  @override
  String get select_city => 'اختر المدينة';

  @override
  String get describe_item_hint => 'صف منتجك وحالته وأي تفاصيل ذات صلة...';

  @override
  String get your_item_is_live => 'منتجك منشور الآن';

  @override
  String get successfully_posted_listing => 'تم نشر الإعلان\nبنجاح';

  @override
  String get view_listing => 'عرض الإعلان';

  @override
  String get post_another_item => 'انشر منتجاً آخر';

  @override
  String posted_by_time_ago(Object time) {
    return 'نُشر بواسطة $time منذ';
  }

  @override
  String get cycling_marketplace => 'سوق الدراجات';

  @override
  String get safety_tips => 'نصائح السلامة';

  @override
  String get meet_the_seller_tip =>
      'قابل البائع في مكان عام آمن وافحص المنتج قبل الدفع.';

  @override
  String listings_count(Object count) {
    return '$count إعلانات';
  }

  @override
  String get unknown_seller => 'بائع غير معروف';

  @override
  String get listing_label => 'إعلان';

  @override
  String get profile_title => 'الملف الشخصي';

  @override
  String get no_achievements_yet => 'لا توجد إنجازات بعد';

  @override
  String get no_badges_yet => 'لا توجد شارات بعد';

  @override
  String get no_joined_events_yet => 'لا توجد فعاليات منضم إليها بعد';

  @override
  String get facilities => 'المرافق';

  @override
  String get tracks_views_community_photos => 'مناظر المسارات وصور المجتمع';

  @override
  String get my_listings => 'إعلاناتي';

  @override
  String get no_sold_items_yet => 'لا توجد عناصر مباعة بعد';

  @override
  String get listed_in_community_store => 'مُدرج في متجر المجتمع';

  @override
  String get route_details_title => 'تفاصيل المسار';

  @override
  String get post_not_found => 'المنشور غير موجود';

  @override
  String get club_update => 'تحديث النادي';

  @override
  String get comments => 'التعليقات';

  @override
  String get confirm => 'تأكيد';

  @override
  String get create_post => 'إنشاء منشور';

  @override
  String get upload_media => 'رفع الوسائط';

  @override
  String get images_videos_gifs => 'صور أو فيديوهات أو GIF';

  @override
  String get upload_a_new_photo => 'رفع صورة جديدة';

  @override
  String get failed_to_load_communities => 'فشل تحميل المجتمعات';

  @override
  String get photo_size_hint => 'JPG أو PNG أو GIF. الحجم الأقصى 2 ميغابايت';

  @override
  String get total_amount => 'المبلغ الإجمالي';

  @override
  String get view_available_offers => 'عرض العروض المتاحة';

  @override
  String get no_comments_yet => 'لا توجد تعليقات بعد.';

  @override
  String get no_approved_posts => 'لا توجد منشورات معتمدة بعد.';

  @override
  String get keep_riding_to_level_up => 'واصل الركوب للارتقاء بالمستوى.';

  @override
  String get list_item_for_sale => 'أدرج منتجاً للبيع';

  @override
  String get listing_terms =>
      'بإدراج منتجك، فإنك توافق على شروط الخدمة وإرشادات السوق.';

  @override
  String get meet_in_public_tip =>
      'قابل البائع في مكان عام وافحص المنتج قبل الدفع. ADCC لا تتعامل مع المعاملات';

  @override
  String get search_track_name_hint =>
      'ابحث باسم المسار أو المدينة أو المسافة أو التضاريس...';

  @override
  String get search_tracks_hint =>
      'ابحث عن المسارات أو المدينة أو المسافة أو التضاريس...';

  @override
  String get cycling_stats_from_events =>
      'إحصائيات ركوب الدراجات تأتي من الفعاليات والجولات.';

  @override
  String get total => 'الإجمالي';

  @override
  String get image_unavailable => 'الصورة غير متاحة';

  @override
  String get two_days_ago => 'قبل يومين';

  @override
  String get posted_two_mins_ago => 'نُشر قبل دقيقتين';

  @override
  String rank_number(Object rank) {
    return 'المرتبة #$rank';
  }

  @override
  String get view_all_arrow => 'عرض الكل ›';

  @override
  String get completed_rides_count => 'الجولات المكتملة: 18';

  @override
  String get drt_830_road_shoes => 'حذاء الطريق DRT 830';

  @override
  String get post => 'نشر';

  @override
  String get join_event_hint =>
      'انضم إلى فعالية مجتمع أبوظبي للدراجات!\nانطلق عبر شوارع المدينة الجميلة و\nتواصل مع زملائك من عشاق ركوب الدراجات.\nاحتفل بركوب الدراجات وروح المجتمع!';

  @override
  String selected_location(Object location) {
    return 'الموقع المحدد: $location';
  }

  @override
  String cycling_tracks_in_city(Object city) {
    return 'مسارات الدراجات الأقرب إلى موقعك الحالي في $city';
  }

  @override
  String get tap_slot_add_photos =>
      'اضغط على خانة لإضافة صورك. يمكنك رفع حتى 5 صور.';

  @override
  String get club_tees => 'قمصان النادي';

  @override
  String get club_tees_sub => 'تصفح أحدث الملابس ذات العلامة التجارية';

  @override
  String get ride_gear => 'معدات الركوب';

  @override
  String get ride_gear_sub => 'اعثر على الخوذ والقفازات ومعدات الحماية';

  @override
  String get bike_tools => 'أدوات الدراجة';

  @override
  String get bike_tools_sub => 'تسوّق الأساسيات للصيانة';

  @override
  String get no_community_groups => 'لم يتم العثور على مجموعات مجتمعية';

  @override
  String get communities_title => 'المجتمعات';

  @override
  String get community_types => 'أنواع المجتمعات';

  @override
  String get choose_communities_subtitle =>
      'اختر المجتمعات بناءً على تفضيلك في الركوب';

  @override
  String get elite_community => 'مجتمع النخبة';

  @override
  String get awareness_rides_community => 'مجتمع جولات التوعية';

  @override
  String get uae_national_events_riders => 'دراجو الفعاليات الوطنية الإماراتية';

  @override
  String get breast_cancer_awareness_riders => 'دراجو التوعية بسرطان الثدي';

  @override
  String completed_rides(Object rides) {
    return 'الجولات المكتملة: $rides';
  }

  @override
  String get reward_earned_newline => 'مكافأة\nمكتسبة';

  @override
  String get available_points => 'النقاط المتاحة';

  @override
  String get progress_to_gold_tier => 'التقدم نحو المستوى الذهبي';

  @override
  String get complete_5_rides_same_condo => 'أكمل 5 جولات في نفس الكوندو';

  @override
  String get no_communities_found => 'لم يتم العثور على مجتمعات';

  @override
  String get search_events_communities_hint =>
      'ابحث عن الفعاليات والمجتمعات والمدن أو المسارات...';

  @override
  String get explore_community_plus => 'استكشف المجتمع +';

  @override
  String communities_in_city(Object city) {
    return 'المجتمعات في $city';
  }

  @override
  String communities_found_count(Object count) {
    return 'تم العثور على $count مجتمعات';
  }

  @override
  String share_event_body(Object title, Object deepLink, Object webLink) {
    return 'اطّلع على هذه الفعالية على ADCC:\n$title\n\nافتح في التطبيق:\n$deepLink\n$webLink';
  }

  @override
  String share_challenge_body(Object title, Object deepLink, Object webLink) {
    return 'اطّلع على هذا التحدي على ADCC:\n$title\n\nافتح في التطبيق:\n$deepLink\n$webLink';
  }

  @override
  String share_route_body(Object title, Object deepLink, Object webLink) {
    return 'اطّلع على هذا المسار على ADCC:\n$title\n\nافتح في التطبيق:\n$deepLink\n$webLink';
  }

  @override
  String share_community_body(Object title, Object deepLink, Object webLink) {
    return 'اطّلع على هذا المجتمع على ADCC:\n$title\n\nافتح في التطبيق:\n$deepLink\n$webLink';
  }

  @override
  String share_achievements_body(Object webLink) {
    return 'اطّلع على إنجازاتي على ADCC!\n\nافتح تطبيق ADCC لرؤية المزيد.\n$webLink';
  }

  @override
  String share_ride_body(Object webLink) {
    return 'لقد أكملت للتو جولة على ADCC!\n\nافتح تطبيق ADCC لتتبع الجولات والانضمام إلى الفعاليات.\n$webLink';
  }

  @override
  String get connection_timeout =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get no_internet_connection =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من إعدادات الشبكة.';

  @override
  String get request_cancelled => 'تم إلغاء الطلب';

  @override
  String get ssl_certificate_error => 'خطأ في شهادة SSL. يرجى المحاولة لاحقاً.';

  @override
  String get unexpected_error => 'حدث خطأ غير متوقع';

  @override
  String get bad_request => 'طلب غير صالح. يرجى التحقق من بياناتك.';

  @override
  String get unauthorized_login_again =>
      'غير مصرح. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get forbidden_no_permission =>
      'ممنوع. ليس لديك إذن للوصول إلى هذا المورد.';

  @override
  String get resource_not_found => 'المورد غير موجود.';

  @override
  String get conflict_exists => 'تعارض. المورد موجود بالفعل.';

  @override
  String get validation_error => 'خطأ في التحقق. يرجى التحقق من بياناتك.';

  @override
  String get too_many_requests => 'طلبات كثيرة جداً. يرجى المحاولة لاحقاً.';

  @override
  String get internal_server_error =>
      'خطأ داخلي في الخادم. يرجى المحاولة لاحقاً.';

  @override
  String get bad_gateway => 'بوابة خاطئة. يرجى المحاولة لاحقاً.';

  @override
  String get service_unavailable => 'الخدمة غير متاحة. يرجى المحاولة لاحقاً.';

  @override
  String get gateway_timeout => 'انتهت مهلة البوابة. يرجى المحاولة لاحقاً.';

  @override
  String error_status_code(Object statusCode) {
    return 'حدث خطأ. رمز الحالة: $statusCode';
  }

  @override
  String get share_route_subject => 'اطّلع على هذا المسار على ADCC';

  @override
  String get pace_beginner_casual => 'مبتدئ / عادي';

  @override
  String get pace_fast_challenging => 'سريع / صعب';

  @override
  String get google_sign_in_cancelled => 'تم إلغاء تسجيل الدخول عبر Google';

  @override
  String get failed_to_get_google_token => 'فشل الحصول على رمز Google ID';

  @override
  String get failed_to_get_facebook_token =>
      'فشل الحصول على رمز الوصول من Facebook';

  @override
  String get facebook_login_cancelled => 'تم إلغاء تسجيل الدخول عبر Facebook';

  @override
  String get failed_to_fetch_communities => 'فشل تحميل المجتمعات';

  @override
  String get failed_to_fetch_community_types => 'فشل تحميل أنواع المجتمعات';

  @override
  String get failed_to_join_community => 'فشل الانضمام إلى المجتمع';

  @override
  String get failed_to_fetch_member_status => 'فشل تحميل حالة العضوية';

  @override
  String get community_left_successfully => 'تم مغادرة المجتمع بنجاح';

  @override
  String get failed_to_leave_community => 'فشل مغادرة المجتمع';

  @override
  String get failed_to_fetch_community => 'فشل تحميل المجتمع';

  @override
  String get no_categories_found => 'لم يتم العثور على فئات';

  @override
  String get failed_to_fetch_categories => 'فشل تحميل الفئات';

  @override
  String get network_error => 'خطأ في الشبكة';

  @override
  String get failed_to_fetch_events => 'فشل تحميل الفعاليات';

  @override
  String get failed_to_register => 'فشل التسجيل';

  @override
  String get registered_successfully => 'تم التسجيل بنجاح';

  @override
  String get registration_cancelled => 'تم إلغاء التسجيل';

  @override
  String get failed_to_cancel_registration => 'فشل إلغاء التسجيل';

  @override
  String get invalid_event_format => 'تنسيق فعالية غير صالح';

  @override
  String get failed_to_fetch_event => 'فشل تحميل الفعالية';

  @override
  String get failed_to_fetch_leaderboard => 'فشل تحميل لوحة الصدارة';

  @override
  String get failed_to_get_member_status => 'فشل الحصول على حالة العضوية';

  @override
  String get failed_to_fetch_event_results => 'فشل تحميل نتائج الفعالية';

  @override
  String get something_went_wrong_tracks => 'حدث خطأ أثناء تحميل المسارات.';

  @override
  String get something_went_wrong_track_details =>
      'حدث خطأ أثناء تحميل تفاصيل المسار.';

  @override
  String get something_went_wrong_track_events =>
      'حدث خطأ أثناء تحميل فعاليات المسار.';

  @override
  String get event_label => 'فعالية';

  @override
  String get failed_to_fetch_summary => 'فشل تحميل ملخص الفعالية المكتملة';

  @override
  String minutes_ago(Object count) {
    return 'قبل $count دقائق';
  }

  @override
  String hours_ago(Object count) {
    return 'قبل $count ساعات';
  }

  @override
  String days_ago(Object count) {
    return 'قبل $count أيام';
  }

  @override
  String get challenge_title => 'تحدي';

  @override
  String get recently_posted => 'نُشر مؤخراً';

  @override
  String get enter_your_name => 'أدخل اسمك';

  @override
  String get enter_your_phone => 'أدخل رقم هاتفك';

  @override
  String get enter_your_street_address => 'أدخل عنوان الشارع';

  @override
  String get enter_your_area => 'أدخل المنطقة';

  @override
  String get enter_your_emirate => 'أدخل الإمارة';

  @override
  String get enter_your_city => 'أدخل مدينتك';

  @override
  String get enter_your_country => 'أدخل بلدك';

  @override
  String get intermediate_rider => 'درّاج متوسط المستوى';

  @override
  String get uv_title_high => 'تنبيه: مؤشر أشعة فوق بنفسجية مرتفع';

  @override
  String get uv_title_advisory => 'تحذير من الأشعة فوق البنفسجية';

  @override
  String get uv_title_update => 'تحديث مؤشر الأشعة فوق البنفسجية';

  @override
  String uv_message(Object index) {
    return 'مؤشر الأشعة فوق البنفسجية هو $index اليوم. تجنّب القيادة في منتصف النهار، وأحضر الماء وواقي الشمس.';
  }

  @override
  String get wind_title_advisory => 'تحذير من الرياح';

  @override
  String get wind_title_update => 'تحديث حالة الرياح';

  @override
  String wind_message(Object speed) {
    return 'سرعة الرياح الآن $speed كم/س. قُد بحذر.';
  }
}
