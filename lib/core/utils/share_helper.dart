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

  static String event(String title, String id) {
    final path = '/events/details/$id';
    return 'Check out this event on ADCC:\n$title\n\nOpen in app:\n${_deepLink(path)}\n${_webLink(path)}';
  }

  static String challenge(String title, String id) {
    final path = '/challenges/details/$id';
    return 'Check out this challenge on ADCC:\n$title\n\nOpen in app:\n${_deepLink(path)}\n${_webLink(path)}';
  }

  static String route(String title, String id) {
    final path = '/routes/details/$id';
    return 'Check out this route on ADCC:\n$title\n\nOpen in app:\n${_deepLink(path)}\n${_webLink(path)}';
  }

  static String community(String title, String id) {
    final path = '/communities/details/$id';
    return 'Check out this community on ADCC:\n$title\n\nOpen in app:\n${_deepLink(path)}\n${_webLink(path)}';
  }

  static String achievements() {
    return 'Check out my achievements on ADCC!\n\nOpen the ADCC app to see more.\n${_appWeb}/';
  }

  static String ride() {
    return 'I just completed a ride on ADCC!\n\nOpen the ADCC app to track rides and join events.\n${_appWeb}/';
  }
}
