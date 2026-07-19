import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


enum MessageType { warning, info, success, error }

class WarningMessage extends StatelessWidget {
  final String message; // Description
  final String? title; // Optional title
  final MessageType type;

  const WarningMessage({
    super.key,
    required this.message,
    this.title,
    this.type = MessageType.warning,
  });

  Color get _backgroundColor {
    switch (type) {
      case MessageType.warning:
        return AppColors.buttonGuest; 
      case MessageType.info:
        return Colors.blue;
      case MessageType.success:
        return AppColors.paleGreen;
      case MessageType.error:
     return const Color(0xFFC12D32);

    }
  }

  IconData get _icon {
    switch (type) {
      case MessageType.warning:
        return Icons.warning_amber_rounded;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.success:
        return Icons.check_circle_outline;
      case MessageType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
return Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: _backgroundColor,
    borderRadius: BorderRadius.circular(12),
  ),
  child: IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
    
        Center(
          child: Icon(
            _icon,
            color: Colors.black,
            size: 17,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: title != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                   Text(
  message,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.31, // 17 / 13 ≈ 1.31
    letterSpacing: 0,
    color:AppColors.textDark,
  ),
),
                  ],
                )
              : Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ],
    ),
  ),
);

  }
}

