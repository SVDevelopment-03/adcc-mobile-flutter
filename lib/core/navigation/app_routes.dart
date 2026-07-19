abstract class AppRoutes {
  static const splash = '/';
  static const home = '/home';

  static const login = '/auth/login';
  static const emailLogin = '/auth/email-login';
  static const register = '/auth/register';
  static const otp = '/auth/otp';
  static const setupProfile = '/auth/setup-profile';
  static const communityAuth = '/auth/community';

  static const notifications = '/notifications';

  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const settings = '/profile/settings';
  static const myChallenges = '/profile/my-challenges';
  static const rideCompleted = '/profile/ride-completed';
  static const eventHistory = '/profile/event-history';
  static const rewards = '/profile/rewards';
  static const cyclingDetails = '/profile/cycling-details';
  static const badges = '/profile/badges';

  static const feed = '/feed';
  static const feedCreate = '/feed/create';
  static const feedLocationPicker = '/feed/location-picker';
  static const feedPost = '/feed/post';

  static String feedPostWithId(String id) => '/feed/post/$id';

  static const store = '/store';
  static const storeDetails = '/store/details';
  static const sellProduct = '/store/sell';
  static const listings = '/store/listings';
  static const livePosted = '/store/live-posted';

  static const clubStore = '/club-store';
  static const clubStoreCart = '/club-store/cart';
  static const clubStoreCheckout = '/club-store/checkout';
  static const clubStoreFinal = '/club-store/final';
  static const clubStoreProducts = '/club-store/products';
  static const clubStoreDetails = '/club-store/details';

  static const events = '/events';
  static const eventDetails = '/events/details';
  static const joinEvent = '/events/join';
  static const cancelRegistration = '/events/cancel';

  static const challenges = '/challenges';
  static const challengeDetails = '/challenges/details';
  static const leaderboard = '/challenges/leaderboard';

  static const communities = '/communities';
  static const communityDetails = '/communities/details';
  static const communitiesExplore = '/communities/explore';
  static const communitiesViewAll = '/communities/view-all';
  static const communityType = '/communities/type';
  static const communityPurpose = '/communities/purpose';

  static const routes = '/routes';
  static const routeDetails = '/routes/details';
  static const trackNearYou = '/routes/near-you';
  static const officialTracks = '/routes/official';
  static const cityTracks = '/routes/city';

  static const languageSelection = '/language-selection';

  static String eventDetailsWithId(String id) => '/events/details/$id';
  static String joinEventWithId(String id) => '/events/join/$id';
  static String cancelRegistrationWithId(String id) => '/events/cancel/$id';
  static String challengeDetailsWithId(String id) => '/challenges/details/$id';
  static String communityDetailsWithId(String id) => '/communities/details/$id';
  static String storeDetailsWithId(String id) => '/store/details/$id';
  static String clubStoreDetailsWithId(String id) => '/club-store/details/$id';
  static String routeDetailsWithId(String id) => '/routes/details/$id';
  static String profileWithTab(String tab) => '/profile/$tab';
}
