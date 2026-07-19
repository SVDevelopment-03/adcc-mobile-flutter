import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'sections/my_cycling_details_header_section.dart';
import 'sections/my_cycling_details_summary_section.dart';

class MyCyclingDetailsScreen extends StatelessWidget {
  const MyCyclingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: const [
            MyCyclingDetailsHeaderSection(),
            SizedBox(height: 16),
            MyCyclingDetailsSummarySection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

