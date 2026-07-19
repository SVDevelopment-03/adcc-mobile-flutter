import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/sections/purpose_based_event_card.dart';
import 'package:flutter/material.dart';

class PurposeBasedEventsViewAllScreen extends StatelessWidget {
  final List<Event> events;

  const PurposeBasedEventsViewAllScreen({super.key, required this.events});

  String _getImagePath(Event event) {
    final image = event.mainImage?.trim();
    if (image != null && image.isNotEmpty) {
      return image;
    }
    return 'assets/images/ride_events.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDFF),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Purpose Based Events',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    'No purpose-based events found',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              )
            else
              ...events.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: PurposeBasedEventCard(
                    imagePath: _getImagePath(event),
                    title: event.title,
                    date: event.formattedDate ?? 'TBD',
                    groupName: event.createdBy?['name']?.toString() ??
                        event.createdBy?['groupName']?.toString() ??
                        'null',
                    onTap: () {
                      if (event.id.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsScreen(eventId: event.id),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}