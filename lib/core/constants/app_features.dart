/// App-wide on/off switches for features.
class AppFeatures {
  AppFeatures._();

  /// Marketplace on the home page: the quick-action tile, the "recently
  /// posted" section and store items in home search. Set to true to show it
  /// again.
  static const bool showMarketplaceOnHome = false;

  /// Club Store (merchandise). While false, every way into the store (quick
  /// action, promo banners, links) shows a "Coming soon" page instead, like
  /// the website. Set to true when the store opens.
  static const bool clubStoreLaunched = false;
}
