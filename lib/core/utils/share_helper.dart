import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static const String _appScheme = 'adcc://';
  static const String _appWeb = 'https://adcc.app';

  static void share(
    BuildContext context,
    String text, {
    String? subject,
  }) {
    final renderObject = context.findRenderObject();
    final box = renderObject is RenderBox ? renderObject : null;
    final positionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : Rect.fromLTWH(0, 0, 1, 1);

    Share.share(
      text,
      subject: subject,
      sharePositionOrigin: positionOrigin,
    );
  }

  static String _deepLink(String path) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return '$_appScheme$normalized';
  }

  static String _webLink(String path) => '$_appWeb$path';

  static String event(String title, String id, AppLocalizations l10n) {
    final path = '/events/details/$id';
    return l10n.share_event_body(title, _deepLink(path), _webLink(path));
  }

  static String challenge(String title, String id, AppLocalizations l10n) {
    final path = '/challenges/details/$id';
    return l10n.share_challenge_body(title, _deepLink(path), _webLink(path));
  }

  static String route(String title, String id, AppLocalizations l10n) {
    final path = '/routes/details/$id';
    return l10n.share_route_body(title, _deepLink(path), _webLink(path));
  }

  static String community(String title, String id, AppLocalizations l10n) {
    final path = '/communities/details/$id';
    return l10n.share_community_body(title, _deepLink(path), _webLink(path));
  }

  static String achievements(AppLocalizations l10n) {
    return l10n.share_achievements_body('$_appWeb/');
  }

  static String ride(AppLocalizations l10n) {
    return l10n.share_ride_body('$_appWeb/');
  }
}
