import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/event_details/view/sections/event_image_banner.dart';
import 'package:adcc/features/event_details/view/sections/internal_event_registration_section.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Registration page of an internal event, same as the website's: open to
/// guests too. Pops with `true` once registered so the event screen can refresh.
class InternalEventRegistrationScreen extends StatefulWidget {
  final Event event;
  final bool isGuest;

  const InternalEventRegistrationScreen({
    super.key,
    required this.event,
    this.isGuest = false,
  });

  @override
  State<InternalEventRegistrationScreen> createState() =>
      _InternalEventRegistrationScreenState();
}

class _InternalEventRegistrationScreenState
    extends State<InternalEventRegistrationScreen> {
  final _eventsService = EventsService();

  bool _isCheckingStatus = true;
  bool _isAlreadyJoined = false;
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    _checkMemberStatus();
  }

  Future<void> _checkMemberStatus() async {
    if (widget.isGuest) {
      setState(() => _isCheckingStatus = false);
      return;
    }
    final result = await _eventsService.getMemberStatus(eventId: widget.event.id);
    if (!mounted) return;
    setState(() {
      _isAlreadyJoined = result.success && (result.data ?? false);
      _isCheckingStatus = false;
    });
  }

  void _close() => Navigator.pop(context, _isAlreadyJoined || _registered);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final description = widget.event.description?.trim() ?? '';

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(EventsImgs.eventBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventImageBanner(
                    base64Image: widget.event.mainImage,
                    height: 220,
                    onBackTap: _close,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.internalEventIntroTitle(widget.event.title),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (_isCheckingStatus)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_isAlreadyJoined)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFA5D6A7)),
                      ),
                      child: Text(
                        l10n.you_already_registered_for_event,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                    )
                  else
                    InternalEventRegistrationSection(
                      event: widget.event,
                      isGuest: widget.isGuest,
                      onRegistered: () => setState(() => _registered = true),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
