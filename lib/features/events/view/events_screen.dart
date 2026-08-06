import 'package:flutter/material.dart';
import 'events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const EventsTab(),
    );
  }
}
