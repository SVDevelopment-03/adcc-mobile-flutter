import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';

class ClubStoreScreen extends StatelessWidget {
  const ClubStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.club_store_title)),
      body: Center(
        child: Text(
          l10n.club_store_home,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
