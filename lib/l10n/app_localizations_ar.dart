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
  String get continue_button => 'يكمل';

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
}
