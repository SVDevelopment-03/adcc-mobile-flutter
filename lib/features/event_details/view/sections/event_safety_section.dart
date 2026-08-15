import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../shared/widgets/warning_message.dart';

class EventSafetySection extends StatelessWidget {
  final String safetyMessage;

  const EventSafetySection({
    super.key,
    required this.safetyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: WarningMessage(
        title: AppLocalizations.of(context)!.safetyInformation,
        message: safetyMessage,
        type: MessageType.warning,
      ),
    );
  }
}
