import 'package:flutter/material.dart';

class ClubStoreScreen extends StatelessWidget {
  const ClubStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Store')),
      body: const Center(
        child: Text(
          'Club Store Home',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
