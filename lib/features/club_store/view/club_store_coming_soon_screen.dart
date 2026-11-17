import 'package:flutter/material.dart';

import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';

/// Shown instead of the Club Store while it is closed
/// (`AppFeatures.clubStoreLaunched == false`). Matches the website's
/// coming-soon store page: hero, preview of what the store will sell, and a
/// "notify me" email sign-up saved as a newsletter subscription.
class ClubStoreComingSoonScreen extends StatefulWidget {
  const ClubStoreComingSoonScreen({super.key});

  @override
  State<ClubStoreComingSoonScreen> createState() =>
      _ClubStoreComingSoonScreenState();
}

class _ClubStoreComingSoonScreenState extends State<ClubStoreComingSoonScreen> {
  static const _green = Color(0xFF019839);
  static const _background = Color(0xFFEAF4FF);
  static const _notifyBackground = Color(0xFF435974);
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final _emailController = TextEditingController();
  bool _saving = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty) {
      setState(() => _error = l10n.store_coming_soon_email_required);
      return;
    }
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _error = l10n.store_coming_soon_email_invalid);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ApiClient.instance.post<dynamic>(
        '/v1/newsletter-subscriptions',
        data: {'email': email, 'source': 'app-store-coming-soon'},
      );
      if (!mounted) return;
      setState(() {
        _done = true;
        _saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.store_coming_soon_subscribe_error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final previews = [
      (
        Icons.checkroom_rounded,
        l10n.store_coming_soon_jerseys,
        l10n.store_coming_soon_jerseys_text,
      ),
      (
        Icons.shopping_bag_outlined,
        l10n.store_coming_soon_accessories,
        l10n.store_coming_soon_accessories_text,
      ),
      (
        Icons.build_outlined,
        l10n.store_coming_soon_gear,
        l10n.store_coming_soon_gear_text,
      ),
    ];

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_none_rounded,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      l10n.store_coming_soon_badge.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title + subtitle
              Text(
                l10n.club_store_title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.store_coming_soon_subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 28),

              // What the store will sell
              for (final (icon, title, text) in previews) ...[
                _PreviewCard(icon: icon, title: title, text: text),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),

              // Notify me
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _notifyBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.store_coming_soon_notify_title,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.store_coming_soon_notify_text,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_done)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF7CE0A0), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.store_coming_soon_notify_thanks,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        style: const TextStyle(
                            fontFamily: 'Outfit', color: Colors.black),
                        decoration: InputDecoration(
                          hintText: l10n.store_coming_soon_email_hint,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                _green.withValues(alpha: 0.6),
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  l10n.store_coming_soon_notify_button,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _error!,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: Color(0xFFFFB4B4),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Explore events
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const EventsScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 1.2),
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: Text(
                  l10n.store_coming_soon_explore_events,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _PreviewCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _ClubStoreComingSoonScreenState._green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
