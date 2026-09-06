/// API Endpoints constants
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  // Base API version
  static const String v1 = '/v1';

  // Events endpoints
  static const String events = '$v1/events';
  static const String homeEvents = '$v1/events/home';
  static String eventById(String id) => '$v1/events/$id';
  static String joinEvent(String eventId) => '/v1/events/$eventId/joinEvent';
  static String cancelEvent(String eventId) => '/v1/events/$eventId/cancel';
  static String addToCalendar(String eventId) =>
      '$v1/events/$eventId/add-to-calendar';
  static String memberStatus(String eventId) =>
      '$v1/events/$eventId/member-status';
  static String eventResults(String eventId) => '$v1/events/$eventId/results';

  // Community endpoints
  static const String communities = '$v1/communities';
  static const String communityMetadataCities = '$communities/metadata/cities';
  static String communityById(String id) => '$communities/$id';
  static String leaveCommunity(String id) => '$communities/$id/leave';
  static String joinCommunity(String id) => '$communities/$id/join';
  static String communityMemberStatus(String id) =>
      '$v1/communities/$id/member-status';
  static String communityGallery(String id) => '$communities/$id/gallery';

  static const String tracks = '$v1/tracks';
  static String trackRelatedEvents(String trackId) =>
      '$v1/tracks/$trackId/events/results';
  static String trackRelatedCommunities(String trackId) =>
      '$v1/tracks/$trackId/communities/results';
  static String trackById(String id) => '$v1/tracks/$id';

  // Authentication endpoints
  static const String auth = '$v1/auth';
  static const String authMe = '$auth/me';
  static const String authMeStats = '$auth/me/stats';
  static const String authMeMonthlyStats = '$auth/me/monthly-stats';
  static const String authMePerformanceInsights =
      '$auth/me/performance-insights';
  static String isMemberOfCommunity(String communityId) =>
      '$v1/communities/$communityId/isMemberOfCommunity';
  static const String authMeActiveParticipations =
      '$auth/me/active-participations';
  static const String authMeCompletedEvents = '$auth/me/completed-events';
  static const String authMeJoinedCommunities = '$auth/me/joined-communities';
  static const String authVerify = '$auth/verify';
  static const String authRefresh = '$auth/refresh';
  static const String authRegister = '$auth/register';
  static const String authEmailRegister = '$auth/email/register';
  static const String authEmailLogin = '$auth/email/login';
  static const String authLogout = '$auth/logout';
  static const String deleteAccount = '$auth/delete-account';
  static const String guestLogin = '$auth/guestLogin';

    // OTP (server-side) endpoints
    static const String otpSend = '$v1/otp/send';
    static const String otpVerify = '$v1/otp/verify';
    // User phone change confirm
    static const String userPhoneChangeConfirm = '$v1/user/phone-change/confirm';

  // Challenges
  static const String challenges = '$v1/challenges';
  static String challengeById(String id) => '$challenges/$id';
  static String joinChallenge(String id) => '$challenges/$id/join';
  static String challengeProgress(String id) => '$challenges/$id/progress';
  static String challengeMemberStatus(String id) =>
      '$challenges/$id/member-status';
  static const String challengeLeaderboard = '$challenges/leaderboard';

  // Badges
  static const String badges = '$v1/badges';
  static const String badgeIcons = '$v1/badges/icons';

  // Static data / lookups (dashboard-managed bilingual dropdowns)
  static const String lookups = '$v1/lookups';
  static String lookupsByType(String type) => '$lookups?type=$type';
    static const String staticData = '$v1/static-data';
  static const String lookupTypeEventCategory = 'event_category';
  static const String lookupTypeCommunityCategory = 'community_category';
  static const String lookupTypeCommunityPurpose = 'community_purpose';
  static const String lookupTypeCommunityTerrain = 'community_terrain';
  static const String lookupTypeCountry = 'country';
  static const String lookupTypeCity = 'city';
  static const String lookupTypeTrackFacility = 'track_facility';
  static const String lookupTypeEventAmenity = 'event_amenity';
  static const String lookupTypeChallengeType = 'challenge_type';
  static const String lookupTypeChallengeUnit = 'challenge_unit';
  static const String lookupTypeNewsCategory = 'news_category';

  // Store
  static const String storeItems = '$v1/store/items';
  static const String merchandiseItems = '$v1/merchandise/products';
  static const String merchandiseCategories = '$v1/merchandise/categories';
  static const String merchandiseOrders = '$v1/merchandise/orders';
  static String merchandiseItemById(String id) => '$merchandiseItems/$id';
  static String storeItemById(String id) => '$storeItems/$id';
  static const String storeMyItems = '$v1/store/my-items';
  static String storeItemApprove(String id) => '$storeItems/$id/approve';
  static String storeItemReject(String id) => '$storeItems/$id/reject';
  static String storeItemFeature(String id) => '$storeItems/$id/feature';
  static String storeItemMarkSold(String id) => '$storeItems/$id/sold';

  // Content settings (onboarding/home banners)
  static const String settingsContentList = '$v1/settings/content/list';
  static const String appBanners = '$v1/app-banners';
  static const String appBannersAr = '$v1/app-banners-ar';
    static const String productBanners = '$v1/product-banners';
    static const String productBannersAr = '$v1/product-banners-ar';

  // User notifications
  static const String pushNotificationsInbox = '$v1/push-notifications/inbox';
  static const String pushNotificationsReadAll =
      '$pushNotificationsInbox/read-all';
  static String pushNotificationRead(String id) =>
      '$pushNotificationsInbox/$id/read';
  static String pushNotificationDelete(String id) =>
      '$pushNotificationsInbox/$id';
  static const String pushNotificationsRegister =
      '$v1/push-notifications/register';
  static const String pushNotificationsUnregister =
      '$v1/push-notifications/unregister';

  // Community posts
  static String communityPosts(String communityId) =>
      '$communities/$communityId/community-posts';
  static String communityPostById(String communityId, String id) =>
      '${communityPosts(communityId)}/$id';

  // Feed posts
  // Public feed routes (mobile/web guests) are mounted under `/v1/feed`
  static const String feed = '$v1/feed';
  // Admin/moderation routes remain under `/v1/feed-posts`
  static const String feedPosts = '$v1/feed-posts';

  // Public endpoints (use `feed` base)
  static const String feedMyPosts = '$feed/my-posts';
  static String feedById(String id) => '$feed/$id';
  static String feedLike(String id) => '$feed/$id/like';
  static String feedComments(String id) => '$feed/$id/comments';
  static String feedCommentById(String id, String commentId) =>
      '$feed/$id/comments/$commentId';

  // Admin endpoints (use `feedPosts` base)
  static String feedPostById(String id) => '$feedPosts/$id';
}
