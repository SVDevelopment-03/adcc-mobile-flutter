import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';
import 'package:adcc/core/navigation/app_navigation.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  StreamSubscription<Uri?>? _sub;

  Future<void> initialize() async {
    await _handleInitialLink();
    _sub = uriLinkStream.listen(_handleUri, onError: _handleError);
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        _navigateToUri(uri);
      }
    } catch (error) {
      debugPrint('[DeepLink] initial uri error: $error');
    }
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    _navigateToUri(uri);
  }

  void _handleError(Object error) {
    debugPrint('[DeepLink] uri stream error: $error');
  }

  void _navigateToUri(Uri uri) {
    final uriPath = _normalizeUriToRoute(uri);
    if (uriPath.isEmpty) return;

    debugPrint('[DeepLink] navigating to path: $uriPath');

    if (appNavigatorKey.currentState != null) {
      appNavigatorKey.currentState?.pushNamed(uriPath);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appNavigatorKey.currentState?.pushNamed(uriPath);
    });
  }

  String _normalizeUriToRoute(Uri uri) {
    final hasQuery = uri.hasQuery;
    final query = hasQuery ? '?${uri.query}' : '';

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      final hostPath = uri.host.isNotEmpty ? '/${uri.host}' : '';
      final route = '$hostPath${uri.path}${query}';
      return route.isEmpty ? '/' : route;
    }

    return '${uri.path}$query';
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
