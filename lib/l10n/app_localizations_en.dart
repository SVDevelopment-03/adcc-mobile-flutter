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
  String get otp_verify_your_number => 'Verify Your Number';

  @override
  String get otp_enter_code_sent => 'Enter the 6-digit code sent to you';

  @override
  String get otp_sent_mobile_number => 'We have sent OTP on your mobile number';

  @override
  String get otp_enter_valid_6_digit => 'Enter a valid 6-digit OTP';

  @override
  String get otp_resend_in => 'Resend the OTP in ';

  @override
  String get otp_resend_now => 'now';

  @override
  String get otp_seconds => 'sec';

  @override
  String get otp_resend_failed => 'OTP resend failed';

  @override
  String get otp_failed_default => 'Failed';

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

  @override
  String get otp_too_many_attempts =>
      'Too many OTP attempts from this device. Please wait and try again later.';

  @override
  String get otp_failed => 'OTP Failed';

  @override
  String get google_login_failed => 'Google login failed';

  @override
  String get facebook_login_failed => 'Facebook login failed';

  @override
  String get error_prefix => 'Error:';

  @override
  String get login_to_your_account => 'Login to your account';

  @override
  String get or_continue_with => 'Or continue with';

  @override
  String get dont_have_account => 'Don\'t have an account? ';

  @override
  String get sign_up => 'Sign up';

  @override
  String get register_ride_connect => 'Ride. Connect.';

  @override
  String get register_join_community =>
      'Join Abu Dhabi\'s premier cycling community App';

  @override
  String get register_skip_continue_as => 'Skip and continue as';

  @override
  String get register_continue_with_mobile => 'Continue With Mobile Number';

  @override
  String get register_continue_as_guest => 'Continue as Guest';

  @override
  String get register_policy_text =>
      'By continuing, you agree to ADCycling\'s Terms of Service\nand Privacy Policy';

  @override
  String get create_account_phone_prompt =>
      'Enter your phone number to continue.\nWe will send an OTP for verification.';

  @override
  String get guest_login_failed => 'Guest login failed';

  @override
  String get common_or => 'Or';

  @override
  String get profile_setup_title => 'Set up your Profile';

  @override
  String get profile_full_name_hint => 'Enter your full name';

  @override
  String get profile_full_name_required => 'Full name is required';

  @override
  String get profile_email_hint => 'Enter your email';

  @override
  String get profile_email_required => 'Email is required';

  @override
  String get profile_email_invalid => 'Enter a valid email';

  @override
  String get profile_birth_date_placeholder => 'Choose your birth date';

  @override
  String get profile_gender_placeholder => 'Choose your Gender';

  @override
  String get profile_country_placeholder => 'Choose your Country';

  @override
  String get profile_city_placeholder => 'Choose your City';

  @override
  String get profile_cities_loading => 'Cities are still loading';

  @override
  String get profile_gender_male => 'Male';

  @override
  String get profile_gender_female => 'Female';

  @override
  String get profile_gender_prefer_not_to_say => 'Prefer not to say';

  @override
  String get profile_country_uae => 'UAE';

  @override
  String get profile_country_saudi_arabia => 'Saudi Arabia';

  @override
  String get profile_country_qatar => 'Qatar';

  @override
  String get profile_country_oman => 'Oman';

  @override
  String get profile_country_kuwait => 'Kuwait';

  @override
  String get profile_country_bahrain => 'Bahrain';

  @override
  String get profile_terms_prefix => 'I\'ve read and agreed to ';

  @override
  String get profile_terms_and => ' and ';

  @override
  String get profile_terms_user_agreement => 'User Agreement';

  @override
  String get profile_terms_privacy_policy => 'Privacy Policy';

  @override
  String get profile_select_birth_date => 'Please select your birth date';

  @override
  String get profile_select_gender => 'Please select your gender';

  @override
  String get profile_select_country => 'Please select your country';

  @override
  String get profile_select_city => 'Please select your city';

  @override
  String get profile_accept_terms =>
      'Please accept the Terms & Conditions to continue.';

  @override
  String get profile_registration_failed => 'Registration failed';

  @override
  String get event_registration_only_logged_in =>
      'Event registration is available only for logged in users.';

  @override
  String get login_to_continue => 'Login to continue';

  @override
  String get event_id_missing_message =>
      'Event ID missing. Please open the event from its details page.';

  @override
  String get common_go_back => 'Go back';

  @override
  String get common_retry => 'Retry';

  @override
  String get you_already_registered_for_event =>
      'You are already registered for this event.';

  @override
  String get personal_information => 'Personal Information';

  @override
  String get field_full_name => 'Full Name *';

  @override
  String get field_email_address => 'Email Address *';

  @override
  String get field_phone_number => 'Phone Number *';

  @override
  String get field_blood_group => 'Blood Group *';

  @override
  String get select_country => 'Select country';

  @override
  String get cycling_information => 'Cycling Information';

  @override
  String get field_have_bike => 'Do you have your own bike?';

  @override
  String get field_bike_type => 'Bike Type *';

  @override
  String get select_bike_type => 'Select bike type';

  @override
  String get select_option => 'Select option';

  @override
  String get event_id_not_found =>
      'Event ID not found. Please reopen the event.';

  @override
  String get complete_required_fields =>
      'Please complete all required selections.';

  @override
  String get please_select_have_bike =>
      'Please select whether you have your own bike.';

  @override
  String get already_joined_for_event =>
      'You are already joined for this event.';

  @override
  String get product_details => 'Product Details';

  @override
  String get unable_to_load_product_details =>
      'Unable to load product details.';

  @override
  String get community_details => 'Community Details';

  @override
  String get unable_to_load_community_details =>
      'Unable to load community details.';

  @override
  String get location_services_disabled =>
      'Location services are disabled. Please enable them.';

  @override
  String get location_permissions_denied => 'Location permissions are denied.';

  @override
  String get location_permissions_permanently_denied =>
      'Location permissions are permanently denied. Please enable them in settings.';

  @override
  String get delete_account_title => 'Delete Account';

  @override
  String get delete_account_message =>
      'Are you sure? This action cannot be undone.';

  @override
  String get delete_account_cancel => 'Cancel';

  @override
  String get delete_account_confirm => 'Delete';

  @override
  String get account_deleted_successfully => 'Account deleted successfully';

  @override
  String get failed_delete_account =>
      'Failed to delete account. Please try again.';

  @override
  String get challenge_complete_title => 'Challenge Complete!';

  @override
  String get challenge_difficulty_question => 'How was the difficulty?';

  @override
  String get challenge_difficulty_too_easy => 'Too Easy';

  @override
  String get challenge_difficulty_just_right => 'Just Right';

  @override
  String get challenge_difficulty_too_hard => 'Too Hard';

  @override
  String get challenge_rate_experience => 'Rate Your Experience';

  @override
  String get challenge_how_was_your_experience => 'How was your experience?';

  @override
  String get challenge_enjoyment_question => 'What did you enjoy?';

  @override
  String get challenge_enjoyment_great_challenge => 'Great Challenge';

  @override
  String get challenge_enjoyment_perfect_difficulty => 'Perfect Difficulty';

  @override
  String get challenge_enjoyment_motivating => 'Motivating';

  @override
  String get challenge_enjoyment_achievable_goals => 'Achievable Goals';

  @override
  String get challenge_additional_thoughts => 'Additional Thoughts';

  @override
  String get challenge_thoughts_hint => 'Share details about your experience.';

  @override
  String get challenge_achievements_unlocked => 'Achievements Unlocked';

  @override
  String get challenge_badge_completed => 'Challenge Completed';

  @override
  String challenge_completed_title(Object challengeTitle) {
    return 'You completed \"$challengeTitle\"';
  }

  @override
  String challenge_reward_points_value(Object rewardPoints) {
    return '+$rewardPoints Reward Points';
  }

  @override
  String get challenge_reward_points_missing => 'nulled Reward Points';

  @override
  String get challenge_reward_points_added => 'Added to your account';

  @override
  String get challenge_reward_badge_title => 'Reward Badge';

  @override
  String get challenge_reward_badge_description =>
      'You earned a reward for completing this challenge.';

  @override
  String get challenge_share_button => 'Share Your Challenge';

  @override
  String get challenge_share_subject => 'Check out my challenge on ADCC';

  @override
  String get challenge_joined => 'Joined';

  @override
  String get challenge_join_now => 'Join Challenge';

  @override
  String get challenge_mark_complete => 'Mark as complete';

  @override
  String get challenge_progress_incomplete => 'Progress incomplete';

  @override
  String get challenge_join_failed => 'Failed to join challenge';

  @override
  String get challenge_complete_requirement =>
      'You can only mark the challenge complete after you reach the target progress.';

  @override
  String get challenge_update_failed => 'Failed to update challenge progress';

  @override
  String get challenge_registered_title => 'You\'re registered!';

  @override
  String challenge_registered_message(Object title) {
    return 'You joined \"$title\" successfully. Get ready for the challenge!';
  }

  @override
  String get challenge_view_all => 'View All';

  @override
  String get challenge_no_performers =>
      'No performers yet. Join the challenge to appear here.';

  @override
  String get challenge_progress => 'Progress';

  @override
  String challenge_days_left(Object daysLeft) {
    return '$daysLeft days left';
  }

  @override
  String get challenge_joined_label => 'Joined';

  @override
  String get challenge_days_left_label => 'Days Left';

  @override
  String get challenge_points_label => 'Points';

  @override
  String get challenge_active_challenges => 'Active Challenges';

  @override
  String get challenge_leaderboard => 'Leaderboard';

  @override
  String get challenge_search_events => 'Search events...';

  @override
  String get challenge_no_active_challenges => 'No active challenges found';

  @override
  String get challenge_no_recent_challenges => 'No recent challenges';

  @override
  String get challenge_recent_challenges => 'Recent Challenges';

  @override
  String get challenge_connect_devices => 'Connect Devices';

  @override
  String get challenge_top_riders_this_month => 'Top riders this month';

  @override
  String get challenge_no_riders_found => 'No riders found';

  @override
  String challenge_your_month_stats(Object monthName) {
    return 'Your $monthName Stats';
  }

  @override
  String get challenge_total_km => 'Total KM';

  @override
  String get challenge_rides => 'Rides';

  @override
  String get challenge_rank_change => 'Rank Change';

  @override
  String get my_challenges_title => 'My challenges';

  @override
  String get my_challenges_no_challenges => 'No challenges yet';

  @override
  String get challenge_tab_completed => 'Completed';

  @override
  String get challenge_tab_upcoming => 'Upcoming';

  @override
  String get challenge_tab_cancelled => 'Cancelled';

  @override
  String get cart_title => 'My Cart';

  @override
  String get removed_from_cart => 'Removed from cart';

  @override
  String get cart_empty_message =>
      'Add items from the club store and review them here before checkout.';

  @override
  String get cart_continue_shopping => 'Continue shopping';

  @override
  String get checkout_title => 'Checkout';

  @override
  String get order_summary => 'Order Summary';

  @override
  String get delivery_address => 'Delivery Address';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get order_notes => 'Order Notes';

  @override
  String get price_details => 'Price Details';

  @override
  String get cart_empty_title => 'Your cart is empty.';

  @override
  String get order_place_failed => 'Failed to place order';

  @override
  String get payment_credit_title => 'Credit / Debit Card';

  @override
  String get payment_credit_sub => 'Visa, Mastercard, AMEX';

  @override
  String get payment_apple_title => 'Apple Pay';

  @override
  String get payment_apple_sub => 'Touch ID / Face ID';

  @override
  String get payment_tabby_title => 'Tabby – Pay in 4';

  @override
  String get payment_tabby_sub => 'Split into 4 payments';

  @override
  String get payment_cod_title => 'Cash on Delivery';

  @override
  String get payment_cod_sub => 'Pay when you receive';

  @override
  String get checkout_place_order => 'Place Order';

  @override
  String get checkout_terms =>
      'By placing your order you agree to ADCC\'s Terms & Conditions';

  @override
  String get club_store_title => 'Club Store';

  @override
  String get club_store_home => 'Club Store Home';

  @override
  String get color_not_set => 'Color not set';

  @override
  String get size_not_set => 'Size not set';

  @override
  String get subtotal => 'Subtotal';

  @override
  String checkout_with_count(Object count) {
    return 'Checkout ($count)';
  }

  @override
  String get colorLabel => 'Color';

  @override
  String get sizeLabel => 'Size';

  @override
  String get selectedVariantOutOfStock => 'Selected variant is out of stock.';

  @override
  String maxAvailableQuantity(Object count) {
    return 'Maximum available quantity is $count.';
  }

  @override
  String get addedToCart => 'Added to cart successfully';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get noDescriptionAvailable => 'No description available.';

  @override
  String get specificationsLabel => 'Specifications';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get featureFreeDelivery => 'Free Delivery';

  @override
  String get featureFreeDeliverySub => 'Above AED 200';

  @override
  String get featureEasyReturns => 'Easy Returns';

  @override
  String get featureEasyReturnsSub => '7-day policy';

  @override
  String get featureAuthentic => 'Authentic';

  @override
  String get featureAuthenticSub => 'Secure payment';

  @override
  String get quantityLabel => 'Quantity :';

  @override
  String get addToCartLabel => 'Add to cart';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get orderConfirmedTitle => 'Order Confirmed!';

  @override
  String get thankYouForShopping => 'Thank you for shopping with ADCC';

  @override
  String productVariantInfo(Object color, Object quantity, Object size) {
    return '$color · $size · Qty $quantity';
  }

  @override
  String get delivery => 'Delivery';

  @override
  String get payment => 'Payment';

  @override
  String get cardEnding => 'Card ending';

  @override
  String get orderNote => 'Order Note';

  @override
  String orderNumber(Object orderNumber) {
    return 'Order #$orderNumber';
  }

  @override
  String get orderConfirmed => 'Order Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get failedToLoadMerchandise =>
      'Failed to load merchandise. Please try again.';

  @override
  String get latestProducts => 'Latest Products';

  @override
  String get viewAll => 'View all';

  @override
  String get community_store => 'Community Store';

  @override
  String get recentlyPosted => 'Recently Posted';

  @override
  String get noMorePosts => 'No more posts';

  @override
  String get swipeBrowsePosts => 'Swipe left or right to browse posts.';

  @override
  String get like => 'LIKE';

  @override
  String get nope => 'NOPE';

  @override
  String get noClubMerchandiseFound => 'No club merchandise found.';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get noFeaturedProducts => 'No featured products available.';

  @override
  String get merchandiseComingSoon => 'Merchandise coming soon';

  @override
  String get merchandiseHelpText =>
      'Use the search bar and category chips above to explore club store items.';

  @override
  String get clubMerchandiseTitle => 'Club Merchandise';

  @override
  String get searchHint => 'Search events, communities, cities, or tracks...';

  @override
  String get allCategory => 'All';

  @override
  String get viewStore => 'View store';

  @override
  String get allProductsTitle => 'All Products';

  @override
  String get loadMore => 'Load more';

  @override
  String get exploreCommunity => 'Explore Community →';

  @override
  String get membersLabel => 'members';

  @override
  String get eventsLabel => 'events';

  @override
  String get categoryWomen => 'Women';

  @override
  String get categoryYouth => 'Youth';

  @override
  String get categoryEndurance => 'Endurance';

  @override
  String get categoryFamilySocial => 'Family / Social';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryRacing => 'Racing';

  @override
  String get welcomeToCommunity => 'Welcome to the Community!';

  @override
  String get youHaveSuccessfullyJoined => 'You have successfully joined';

  @override
  String get whatsNext => 'What\'s Next?';

  @override
  String get notificationsEnabled => 'Notifications Enabled';

  @override
  String get notificationsComingSoon => 'Notifications feature coming soon';

  @override
  String get joinCommunityChats => 'Join Community Chats';

  @override
  String get chatComingSoon => 'Chat feature coming soon';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get startExploring => 'Start Exploring';

  @override
  String communityDescription(Object location) {
    return 'The main cycling community in $location, bringing together...';
  }

  @override
  String get locationLabel => 'Location';

  @override
  String get login_required_title => 'Login required';

  @override
  String get login_required_message => 'Please log in to access this feature.';

  @override
  String get discover_adcc => 'Discover ADCC';

  @override
  String get explore_button => 'Explore';

  @override
  String get welcome_guest => 'Welcome, Guest';

  @override
  String get could_not_load_feed => 'Could not load feed';

  @override
  String get ride_in_abu_dhabi => 'Ride in Abu Dhabi';

  @override
  String get pleaseSelectReasonForLeaving =>
      'Please select a reason for leaving';

  @override
  String get youHaveLeftTheCommunity => 'You have left the community';

  @override
  String get failedToLeaveCommunity => 'Failed to leave community';

  @override
  String get leaveCommunityTitle => 'Leave Community';

  @override
  String get leaveCommunitySubtitle =>
      'We\'re sorry to see you go.\nYour feedback helps us improve.';

  @override
  String get reasonLabel => 'Reason:';

  @override
  String get additionalFeedback => 'Additional feedback';

  @override
  String get tellUsMoreHint => 'Tell Us More....';

  @override
  String get leaving => 'Leaving...';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get reasonNotActiveAnymore => 'Not Active Anymore';

  @override
  String get reasonScheduleConflict => 'Schedule Conflict';

  @override
  String get reasonNotMatchingInterest => 'Community Not Matching My Interest';

  @override
  String get reasonFoundAnotherCommunity => 'Found Another Community';

  @override
  String get reasonTemporaryBreak => 'Temporary Break';

  @override
  String get reasonOther => 'Other';

  @override
  String get myCommunitiesTitle => 'My Communities';

  @override
  String get noCommunitiesFound => 'No communities found';

  @override
  String get typeLabel => 'Type';

  @override
  String get communityLabel => 'Community';

  @override
  String get cityLabel => 'City';

  @override
  String get trackLabel => 'Track';

  @override
  String get organizedBy => 'Organized By';

  @override
  String get viewCommunity => 'View Community';

  @override
  String get eventSchedule => 'Event Schedule';

  @override
  String get participantsPreview => 'Participants Preview';

  @override
  String get loading => 'Loading...';

  @override
  String ridersRegistered(Object count) {
    return '$count riders registered';
  }

  @override
  String get loginToRegister => 'Login to register';

  @override
  String get viewPastResult => 'View Past Result';

  @override
  String get joinEvent => 'Join Event';

  @override
  String get guestCannotRegister =>
      'Guests cannot access event registration. Please login to continue.';

  @override
  String get cancelledSuccessfully => 'Cancelled successfully';

  @override
  String get cancelRegistration => 'Cancel Registration';

  @override
  String get aboutThisEvent => 'About this Event';

  @override
  String get quickInfo => 'Quick Info';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get maxRidersLabel => 'Max Riders';

  @override
  String get registeredLabel => 'Registered';

  @override
  String get registrationLabel => 'Registration';

  @override
  String get whoCanJoin => 'Who Can Join';

  @override
  String ageWithPlus(Object age) {
    return 'Age: $age+';
  }

  @override
  String get helmetRequired => 'Helmet required';

  @override
  String get helmetNotRequired => 'Helmet not required';

  @override
  String get roadBikeMandatory => 'Road Bike\nMandatory';

  @override
  String get roadBikeNotMandatory => 'Road bike not mandatory';

  @override
  String experienceLabel(Object level) {
    return 'Experience: $level';
  }

  @override
  String genderLabel(Object gender) {
    return 'Gender: $gender';
  }

  @override
  String get search => 'Search...';

  @override
  String get amenities => 'Amenities';

  @override
  String get rewardsAndBadges => 'Rewards & Badges';

  @override
  String get requiredGear => 'Required Gear';

  @override
  String get helmetMandatory => 'Helmet\n(Mandatory)';

  @override
  String get helmetRecommended => 'Helmet\n(Recommended)';

  @override
  String get frontRearLights => 'Front & Rear\nLights';

  @override
  String get roadBikeRecommended => 'Road Bike\nRecommended';

  @override
  String get waterBottles => 'Water\nBottles';

  @override
  String get doYouHaveBike => 'Do you have a bike?';

  @override
  String get races => 'Races';

  @override
  String get communityRides => 'Community\nRides';

  @override
  String get trainingClinics => 'Training &\nClinics';

  @override
  String get awarenessRides => 'Awareness\nRides';

  @override
  String get corporateEvents => 'Corporate\nEvents';

  @override
  String get nationalEvents => 'National\nEvents';

  @override
  String get eventsByCategory => 'Events by Category';

  @override
  String get communityHighlights => 'Community Highlights';

  @override
  String get eventsTab => 'Events';

  @override
  String get tracksTab => 'Tracks';

  @override
  String get galleryTab => 'Gallery';

  @override
  String get updatesTab => 'Updates';

  @override
  String get foundedLabel => 'Founded';

  @override
  String get activeMembersLabel => 'Active Members';

  @override
  String get trackDistanceLabel => 'Track Distance';

  @override
  String get averageRideRatingLabel => 'Average Ride Rating';

  @override
  String get free => 'Free';

  @override
  String get noEventsFound => 'No events found';

  @override
  String get eventsByCategorySubtitle =>
      'Competitive cycling events organized by ADCC communities';

  @override
  String get communityRidesSingle => 'Community Ride';

  @override
  String get noUpcomingEvents => 'No upcoming events';

  @override
  String get familyAndKids => 'Family & Kids';

  @override
  String get corporateShort => 'Corporate';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get emergencyContactNameLabel => 'Emergency Contact Name *';

  @override
  String get emergencyContactNameHint => 'Contact person name';

  @override
  String get emergencyContactPhoneLabel => 'Emergency Contact Phone *';

  @override
  String get emergencyContactPhoneHint => '+971 50 123 4567';

  @override
  String get unknownEventTitle => 'Test demo';

  @override
  String get unknownEventLocation => 'test demo';

  @override
  String get whenLabel => 'When';

  @override
  String get defaultCity => 'Abu Dhabi';

  @override
  String get joinedLabel => 'Joined';

  @override
  String get defaultDate => '18 July 2026';

  @override
  String get backToEvent => 'Back to Event';

  @override
  String get checkYourEventSchedule => 'Check your Event\nSchedule';

  @override
  String get chooseDateHint => 'Choose a date to see what is happening next.';

  @override
  String get viewDetails => 'View Details';

  @override
  String get failedToLoadJoinedEvents => 'Failed to load joined events';

  @override
  String get retry => 'Retry';

  @override
  String get filterAll => 'All';

  @override
  String get filterThisWeek => 'This Week';

  @override
  String get filterThisMonth => 'This Month';

  @override
  String get filterLater => 'Later';

  @override
  String get failedToLoadUpcomingEvents => 'Failed to load upcoming events';

  @override
  String get upcomingEventsSubtitle =>
      'The next rides, races, and training sessions on the ADCC calendar';

  @override
  String get noRewardsAvailable => 'No rewards available';

  @override
  String get riderCheckIn => 'Rider Check-in';

  @override
  String get safetyBriefing => 'Safety briefing';

  @override
  String get raceStart => 'Race start';

  @override
  String get finalLap => 'Final lap';

  @override
  String get finish => 'Finish';

  @override
  String get awardsCeremony => 'Awards ceremony';

  @override
  String get facilityWater => 'Water';

  @override
  String get facilityToilets => 'Toilets';

  @override
  String get facilityParking => 'Parking';

  @override
  String get facilityMedical => 'Medical';

  @override
  String get facilityLights => 'Lights';

  @override
  String get communityInfoNotAvailable => 'Community information not available';

  @override
  String get invalidCommunityId => 'Invalid community ID';

  @override
  String get failedToLoadCommunity => 'Failed to load community';

  @override
  String get pleaseSignInToJoinCommunities =>
      'Please sign in to join communities.';

  @override
  String get communityJoinedSuccessfully => 'Community joined successfully! 🎉';

  @override
  String get joinFailed => 'Join failed';

  @override
  String get communityLeftSuccessfully => 'Community left successfully';

  @override
  String get points => 'Points';

  @override
  String get joinChecking => 'Checking...';

  @override
  String get community_no_upcoming_events =>
      'No upcoming events for this community';

  @override
  String get community_no_gallery_images => 'No gallery images available';

  @override
  String get community_no_track_data => 'No track data available';

  @override
  String get community_no_updates => 'No community updates yet';

  @override
  String get pleaseSelectReason => 'Please select a reason';

  @override
  String get cancelFailed => 'Cancel failed';

  @override
  String get cancelRegistrationSubtitle =>
      'Please let us know why you\'re\ncancelling';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get noLeaderboardData => 'No leaderboard data available yet';

  @override
  String get failedToLoadEventDetails => 'Failed to load event details.';

  @override
  String get failedToLoadEventOrProfile =>
      'Failed to load event or profile data. Please try again.';

  @override
  String get failedToCompleteRegistration => 'Failed to complete registration.';

  @override
  String get hintFullName => 'Full name';

  @override
  String get hintEmailAddress => 'Email address';

  @override
  String get hintPhoneNumber => 'Phone number';

  @override
  String get pleaseSelectBloodGroup => 'Please select blood group';

  @override
  String get countryLabel2 => 'Country *';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get bikeTypeRoad => 'Road Bike';

  @override
  String get bikeTypeMountain => 'Mountain Bike';

  @override
  String get bikeTypeHybrid => 'Hybrid Bike';

  @override
  String get alreadyJoined => 'Already Joined';

  @override
  String get completeRegistration => 'Complete Registration';

  @override
  String get joinEventTerms =>
      'I accept the terms and confirm that all information\nprovided is accurate. I understand the safety\nrequirements and will comply with all event guidelines.';

  @override
  String get purposeBasedEvents => 'Purpose Based Events';

  @override
  String get noPurposeBasedEvents => 'No purpose-based events found';

  @override
  String get countryLabel => 'Country';

  @override
  String get ownBike => 'Own Bike';

  @override
  String get bikeType => 'Bike Type';

  @override
  String get emergencyPhone => 'Emergency Phone';

  @override
  String get youAreRegistered => 'You\'re registered!';

  @override
  String get getReadyForRide =>
      'Get ready for an amazing ride with\nthe community!';

  @override
  String get addToCalendar => 'Add to Calendar';

  @override
  String get shareWithFriends => 'Share with Friends';

  @override
  String get viewMyEvents => 'View My Events';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get eventLocation => 'Event location';

  @override
  String get yourRegistration => 'Your Registration';

  @override
  String get unableToBuildCalendarLink => 'Unable to build calendar link.';

  @override
  String get calendarLinkOpened => 'Calendar link opened successfully.';

  @override
  String get unableToOpenCalendarLink => 'Unable to open calendar link.';

  @override
  String registeredForEvent(Object title) {
    return 'I just registered for $title.';
  }

  @override
  String get registrationCopied => 'Registration details copied to clipboard.';

  @override
  String get myEvents => 'My Events';

  @override
  String get failedToLoadEvents => 'Failed to load events';

  @override
  String get noCancelledEvents => 'No cancelled events';

  @override
  String get cancelledEventsHint =>
      'Cancelled events will appear here when available.';

  @override
  String get eventHistoryHint =>
      'Your event history will appear here once data is loaded.';

  @override
  String get loadingSearchResults => 'Loading search results...';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get myCyclingDetails => 'My cycling details';

  @override
  String get riderLevel => 'Rider Level';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get totalRides => 'Total Rides';

  @override
  String get badgesEarned => 'Badges Earned';

  @override
  String get yourRidesAndEvents => 'Your Rides & Events';

  @override
  String get noCompletedRidesYet => 'No completed rides yet';

  @override
  String get noJoinedCommunitiesYet => 'No joined communities yet';

  @override
  String get yourListedGear => 'Your Listed Gear';

  @override
  String get noListedGearYet => 'No listed gear yet';

  @override
  String get citiesAreLoading => 'Cities are still loading';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get noCompletedEventsYet => 'No completed events yet';

  @override
  String get noChallengesFound => 'No challenges found';

  @override
  String usePoints(Object points) {
    return 'Use $points pts';
  }

  @override
  String get failedToLoadTracks => 'Failed to load tracks';

  @override
  String get noTracksFound => 'No tracks found';

  @override
  String get markAsSold => 'Mark as sold';

  @override
  String get markItemAsSoldQuestion => 'Mark this item as sold?';

  @override
  String get markedSold => 'Marked sold';

  @override
  String get failed => 'Failed';

  @override
  String get delete => 'Delete';

  @override
  String get deleteListing => 'Delete listing';

  @override
  String get deleteListingConfirm =>
      'Are you sure you want to delete this listing?';

  @override
  String get loginToPostOrLike => 'Please login to post or like feed updates.';

  @override
  String get tapMapToSelectLocation => 'Tap the map to select a location.';

  @override
  String get selectLocation => 'Select location';

  @override
  String get postSubmittedForApproval => 'Post submitted for approval';

  @override
  String get noEventsAvailable => 'No events available';

  @override
  String get selectAnEvent => 'Select an event';

  @override
  String get noTracksAvailable => 'No tracks available';

  @override
  String get selectATrack => 'Select a track';

  @override
  String get fillAllRequiredFields => 'Please fill all required listing fields';

  @override
  String get pleaseSelectCity => 'Please select a city';

  @override
  String get pleaseSelectContactMethod => 'Please select a contact method';

  @override
  String get phoneRequiredForContactMethod =>
      'Phone number is required for selected contact method';

  @override
  String get uploadAtLeastOnePhoto =>
      'Please upload at least one product photo';

  @override
  String get listingUpdated => 'Listing updated';

  @override
  String get failedToSaveListing => 'Failed to save listing';

  @override
  String get negotiable => 'Negotiable';

  @override
  String get sellerPhoneNotAvailable => 'Seller phone not available';

  @override
  String get cannotOpenWhatsApp => 'Cannot open WhatsApp';

  @override
  String get whatsappSeller => 'WhatsApp Seller';

  @override
  String get cannotMakeCall => 'Cannot make call';

  @override
  String get sellYourProduct => 'Sell your product';

  @override
  String showingResults(Object count) {
    return 'Showing $count Results';
  }

  @override
  String get filter => 'Filter';

  @override
  String get filters => 'Filters';

  @override
  String get minPriceAed => 'Min price (AED)';

  @override
  String get maxPriceAed => 'Max price (AED)';

  @override
  String get cityOptional => 'City (optional)';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceLowHigh => 'Price: Low to High';

  @override
  String get sortPriceHighLow => 'Price: High to Low';

  @override
  String get apply => 'Apply';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get community => 'Community';

  @override
  String get tracks => 'Tracks';

  @override
  String get challenges => 'Challenges';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get bikeExperience => 'Bike Experience';

  @override
  String get rideFeed => 'Ride Feed';

  @override
  String get clubStore => 'Club Store';

  @override
  String get nearbyTracks => 'Nearby Tracks';

  @override
  String get officialCyclingRoutes => 'Official Cycling Routes';

  @override
  String get exploreSafeRoutes => 'Explore safe routes across Abu Dhabi';

  @override
  String get trackSafetyGuidelines => 'Track Safety & Guidelines';

  @override
  String get staySafeEveryRide => 'Stay safe on every ride';

  @override
  String get searchAcrossHint =>
      'Search across events, communities, tracks, and more.';

  @override
  String get noResultsFound => 'No results found.';

  @override
  String get members => 'members';

  @override
  String get soldBy => 'Sold by';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String get exploreByCity => 'Explore by City';

  @override
  String get officialCyclingTracks => 'Official Cycling\nTracks';

  @override
  String get rideByStyle => 'Ride by Style';

  @override
  String get tracksNearYou => 'Tracks Near You';

  @override
  String get routeDetailsPdf => 'Route Details (PDF)';

  @override
  String get safetyGuidelinesPdf => 'Safety Guidelines (PDF)';

  @override
  String get safetyInformation => 'Safety Information';

  @override
  String get openInLinkMyRide => 'Open in Link My Ride';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get startRide => 'Start Ride';

  @override
  String get trackDetails => 'Track Details';

  @override
  String get call => 'Call';

  @override
  String get searchMarketplace => 'Search marketplace...';

  @override
  String get availableAsGuest => 'Available as a guest:';

  @override
  String get browseEvents => 'Browse Events';

  @override
  String get exploreCommunityButton => 'Explore Community';

  @override
  String get viewTracks => 'View Tracks';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updatePersonalInfo => 'Update your personal information';

  @override
  String get english => 'English';

  @override
  String get units => 'Units';

  @override
  String get metricComingSoon => 'Metric (km, kg)\nComing soon!';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get rideGuidelinesEtiquette => 'Ride Guidelines / Etiquette';

  @override
  String get helpCenterComingSoon => 'Help Center (Coming soon!)';

  @override
  String get termsConditionsComingSoon => 'Terms & Conditions (Coming soon!)';

  @override
  String get privacyPolicyComingSoon => 'Privacy Policy (Coming soon!)';

  @override
  String get eventReminders => 'Event Reminders';

  @override
  String get eventRemindersSub => 'Get notified before events start';

  @override
  String get communityUpdates => 'Community Updates';

  @override
  String get communityUpdatesSub => 'New posts and announcements';

  @override
  String get newMessages => 'New Messages';

  @override
  String get newMessagesSub => 'Direct messages from riders';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementsSub => 'When you unlock badges';

  @override
  String get myEventsAndCalendar => 'My Events & Calendar';

  @override
  String get badgesAndAchievements => 'Badges & achievements';

  @override
  String get myChallenges => 'My Challenges';

  @override
  String get rewardsAndPoints => 'Rewards and points';

  @override
  String get settingsAndPreferences => 'Settings & preferences';

  @override
  String get myBadges => 'My Badges';

  @override
  String get joinedEvents => 'Joined Events';

  @override
  String get distance => 'Distance';

  @override
  String get time => 'Time';

  @override
  String get position => 'Position';

  @override
  String get averageCompletionRate => 'Average\nCompletion Rate';

  @override
  String get averageEventDistance => 'Average Event\nDistance';

  @override
  String get bestCategory => 'Best Category';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advancedLevel => 'Advanced';

  @override
  String get ambassador => 'Ambassador';

  @override
  String get latestAchievement => 'Latest Achievement';

  @override
  String get completed => 'Completed';

  @override
  String get objective => 'Objective';

  @override
  String get inProgress => 'In Progress';
}
