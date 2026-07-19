import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'routes_screen.dart';

class RoutesScreenWrapper extends StatelessWidget {
  const RoutesScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: const RoutesTab(),
    );
  }
}

