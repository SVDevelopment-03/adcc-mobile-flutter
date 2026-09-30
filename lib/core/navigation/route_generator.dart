import 'package:flutter/material.dart';
import 'package:adcc/core/navigation/app_routes.dart';
import 'package:adcc/features/auth/view/communityScreen/community.dart';
import 'package:adcc/features/auth/view/otpScreen/otp.dart';
import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/features/auth/view/setupProfile/setup_profile_screen.dart';
import 'package:adcc/features/club_store/view/cart_screen.dart';
import 'package:adcc/features/club_store/view/checkout_screen.dart';
import 'package:adcc/features/club_store/view/club_store_screen.dart';
import 'package:adcc/features/club_store/view/final_screen.dart';
import 'package:adcc/features/club_store/view/view_all_products_screen.dart';
import 'package:adcc/features/challenges/view/challenge_details_screen.dart';
import 'package:adcc/features/challenges/view/challenges_screen.dart';
import 'package:adcc/features/challenges/view/leaderboard_screen.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:adcc/features/events/view/cancel_registration.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/features/events/view/join_event.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/features/languageOption/view/languageSelectionScreen.dart';
import 'package:adcc/features/notifications/view/notifications_screen.dart';
import 'package:adcc/features/profile/view/screens/badges_achievement.screen.dart';
import 'package:adcc/features/profile/view/screens/cycling_details_screen.dart';
import 'package:adcc/features/profile/view/screens/edit_profile_screen.dart';
import 'package:adcc/features/profile/view/screens/event_history_screen.dart';
import 'package:adcc/features/profile/view/screens/my_challenges_screen.dart';
import 'package:adcc/features/profile/view/screens/profile_screen.dart';
import 'package:adcc/features/profile/view/screens/rewards_point_screen.dart';
import 'package:adcc/features/profile/view/screens/ride_completed_screen.dart';
import 'package:adcc/features/profile/view/screens/settings_screen.dart';
import 'package:adcc/features/ride_feed/view/ride_feed_screen.dart';
import 'package:adcc/features/splash/view/splash_screen.dart';
import 'package:adcc/features/store/view/Screen/store_details_screen.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/store/view/listings_screen.dart';
import 'package:adcc/features/store/view/live_posted_screen.dart';
import 'package:adcc/features/store/view/sell_product_screen.dart';
import 'package:adcc/core/navigation/club_store_details_loader.dart';
import 'package:adcc/core/navigation/community_details_loader.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/view/city_tracks_page.dart';
import 'package:adcc/features/routes/view/official_cycling_track_page.dart';
import 'package:adcc/features/routes/view/track_near_you_all.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? AppRoutes.splash);
    final args = settings.arguments;

    if (uri.path == AppRoutes.splash || uri.path == '/') {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    }

    if (uri.path == AppRoutes.home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }

    if (uri.path == AppRoutes.login ||
        uri.path == AppRoutes.emailLogin ||
        uri.path == AppRoutes.register) {
      return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
    }

    if (uri.path == AppRoutes.otp) {
      final verificationId = uri.queryParameters['verificationId'];
      final phone = uri.queryParameters['phone'];
      if (verificationId != null && phone != null) {
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            verificationId: verificationId,
            phone: phone,
          ),
        );
      }
      return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
    }

    if (uri.path == AppRoutes.setupProfile) {
      return MaterialPageRoute(builder: (_) => const SetupProfileScreen());
    }

    if (uri.path == AppRoutes.communityAuth) {
      return MaterialPageRoute(builder: (_) => const CommunityScreen());
    }

    if (uri.path == AppRoutes.notifications) {
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());
    }

    if (uri.path == AppRoutes.profile) {
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    }

    if (uri.path == AppRoutes.editProfile) {
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    }

    if (uri.path == AppRoutes.settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    }

    if (uri.path == AppRoutes.myChallenges) {
      return MaterialPageRoute(builder: (_) => const MyChallengesScreen());
    }

    if (uri.path == AppRoutes.eventHistory) {
      return MaterialPageRoute(builder: (_) => const EventHistoryScreen());
    }

    if (uri.path == AppRoutes.rewards) {
      return MaterialPageRoute(builder: (_) => const RewardsPointsScreen());
    }

    if (uri.path == AppRoutes.cyclingDetails) {
      return MaterialPageRoute(builder: (_) => const CyclingDetailsScreen());
    }

    if (uri.path == AppRoutes.badges) {
      return MaterialPageRoute(
          builder: (_) => const BadgesAchievementsScreen());
    }

    if (uri.path == AppRoutes.rideCompleted) {
      return MaterialPageRoute(builder: (_) => const RideCompletedScreen());
    }

    if (uri.path == AppRoutes.languageSelection) {
      return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
    }

    if (uri.path == AppRoutes.feed) {
      return MaterialPageRoute(builder: (_) => const RideFeedScreen());
    }

    if (uri.path == AppRoutes.feedCreate) {
      return MaterialPageRoute(builder: (_) => const CreateFeedPostScreen());
    }

    if (uri.path == AppRoutes.feedLocationPicker) {
      return MaterialPageRoute(builder: (_) => const LocationPickerScreen());
    }

    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'feed' &&
        uri.pathSegments[1] == 'post') {
      return MaterialPageRoute(
        builder: (_) => FeedDetailScreen(
          postId: uri.pathSegments[2],
          isGuest: false,
          onLoginRequired: () {},
        ),
      );
    }

    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments[0] == 'store' &&
        uri.pathSegments.length == 2) {
      return MaterialPageRoute(
          builder: (_) => StoreDetailsScreen(productId: uri.pathSegments[1]));
    }

    if (uri.path == AppRoutes.store) {
      return MaterialPageRoute(builder: (_) => const StoreScreen());
    }

    if (uri.path == AppRoutes.sellProduct) {
      return MaterialPageRoute(builder: (_) => const SellProductScreen());
    }

    if (uri.path == AppRoutes.listings) {
      return MaterialPageRoute(builder: (_) => const ListingsScreen());
    }

    if (uri.path == AppRoutes.livePosted) {
      final title = uri.queryParameters['title'] ?? '';
      final price = uri.queryParameters['price'] ?? '';
      return MaterialPageRoute(
          builder: (_) => LivePostedScreen(title: title, price: price));
    }

    if (uri.path == AppRoutes.clubStore) {
      return MaterialPageRoute(builder: (_) => const ClubStoreScreen());
    }

    if (uri.path == AppRoutes.clubStoreCart) {
      return MaterialPageRoute(builder: (_) => const ClubStoreCartScreen());
    }

    if (uri.path == AppRoutes.clubStoreCheckout) {
      return MaterialPageRoute(builder: (_) => const ClubStoreCheckoutScreen());
    }

    if (uri.path == AppRoutes.clubStoreFinal) {
      if (args is Map<String, dynamic>) {
        return MaterialPageRoute(
          builder: (_) => ClubStoreFinalScreen(order: args),
        );
      }
      return MaterialPageRoute(builder: (_) => const ClubStoreCheckoutScreen());
    }

    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'club-store' &&
        uri.pathSegments[1] == 'details') {
      return MaterialPageRoute(
        builder: (_) =>
            ClubStoreDetailsLoaderScreen(itemId: uri.pathSegments[2]),
      );
    }

    if (uri.path == AppRoutes.clubStoreProducts) {
      return MaterialPageRoute(
          builder: (_) => const ClubStoreAllProductsScreen());
    }

    if (uri.path == AppRoutes.events) {
      return MaterialPageRoute(builder: (_) => const EventsScreen());
    }

    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'events') {
      return _handleEventRoutes(uri);
    }

    if (uri.path == AppRoutes.challenges) {
      return MaterialPageRoute(builder: (_) => const ChallengesScreen());
    }

    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'challenges') {
      return _handleChallengeRoutes(uri);
    }

    if (uri.path == AppRoutes.communities) {
      return MaterialPageRoute(builder: (_) => const CommunitiesScreen());
    }

    if (uri.path == AppRoutes.communitiesExplore) {
      return MaterialPageRoute(builder: (_) => const CommunitiesScreen());
    }

    if (uri.path == AppRoutes.communitiesViewAll) {
      return MaterialPageRoute(builder: (_) => const CommunitiesScreen());
    }

    if (uri.path == AppRoutes.communityType) {
      return MaterialPageRoute(builder: (_) => const CommunitiesScreen());
    }

    if (uri.path == AppRoutes.communityPurpose) {
      return MaterialPageRoute(builder: (_) => const CommunitiesScreen());
    }

    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'communities' &&
        uri.pathSegments[1] == 'details') {
      return MaterialPageRoute(
        builder: (_) =>
            CommunityDetailsLoaderScreen(communityId: uri.pathSegments[2]),
      );
    }

    if (uri.path == AppRoutes.routes) {
      return MaterialPageRoute(builder: (_) => const TrackNearAllPage());
    }

    if (uri.path == AppRoutes.officialTracks) {
      return MaterialPageRoute(
          builder: (_) => const OfficialCyclingTracksPage());
    }

    if (uri.path == AppRoutes.cityTracks) {
      final cityName = uri.queryParameters['cityName'] ?? '';
      return MaterialPageRoute(
          builder: (_) => CityTracksPage(cityName: cityName));
    }

    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'routes') {
      return _handleRouteRoutes(uri);
    }

    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }

  static Route<dynamic> _handleEventRoutes(Uri uri) {
    if (uri.pathSegments.length >= 2) {
      final secondSegment = uri.pathSegments[1];
      if (secondSegment == 'join' && uri.pathSegments.length == 3) {
        return MaterialPageRoute(
            builder: (_) => JoinEvent(eventId: uri.pathSegments[2]));
      }
      if (secondSegment == 'cancel' && uri.pathSegments.length == 3) {
        return MaterialPageRoute(
            builder: (_) =>
                CancelRegistrationScreen(eventId: uri.pathSegments[2]));
      }
      return MaterialPageRoute(
          builder: (_) => EventDetailsScreen(eventId: uri.pathSegments[1]));
    }
    return MaterialPageRoute(builder: (_) => const EventsScreen());
  }

  static Route<dynamic> _handleChallengeRoutes(Uri uri) {
    if (uri.pathSegments.length == 2) {
      final secondSegment = uri.pathSegments[1];
      if (secondSegment == 'leaderboard') {
        return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
      }
      return MaterialPageRoute(
          builder: (_) => ChallengeDetailsScreen(challengeId: secondSegment));
    }
    return MaterialPageRoute(builder: (_) => const ChallengesScreen());
  }

  static Route<dynamic> _handleRouteRoutes(Uri uri) {
    if (uri.pathSegments.length == 2) {
      return MaterialPageRoute(
        builder: (_) => RouteDetailsScreen(
          routeData: {'id': uri.pathSegments[1]},
        ),
      );
    }
    return MaterialPageRoute(builder: (_) => const TrackNearAllPage());
  }
}
