import 'package:adcc/features/profile/view/sections/Ride%20Completed/Warpupweekcard.dart';
import 'package:adcc/features/profile/view/sections/Ride%20Completed/additinol_details_section.dart';
import 'package:adcc/features/profile/view/sections/Ride%20Completed/badge_card.dart';
import 'package:adcc/features/profile/view/sections/Ride%20Completed/photo_upload_card.dart';
import 'package:adcc/features/profile/view/sections/Ride%20Completed/share_ride_button.dart';
import 'package:flutter/material.dart';

class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({super.key});

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}

class _RideCompletedScreenState extends State<RideCompletedScreen> {
  int rating = 0;

  Widget buildStar(int index) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 26,
      ),
      onPressed: () {
        setState(() {
          rating = index + 1;
        });
      },
    );
  }

  Widget statItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9EF),
        elevation: 0,
         automaticallyImplyLeading: false,
        title: const Text(
          "Ride Completed!",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.close, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

             WrapUpWeekCard(),

              const SizedBox(height: 16),

             AdditionalThoughtsCard(),
              const SizedBox(height: 16),

          PhotoUploadCard(),

              const SizedBox(height: 20),

            BadgeCard(),

              const SizedBox(height: 16),

             ShareRideButton(),

              const SizedBox(height: 10),

             SizedBox(
  width: 358,
  height: 51,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xffFFF9EF),
      side: const BorderSide(
        color: Colors.black26,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 15),
    ),
    onPressed: () {},
    child: const Text(
      "Continue",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  ),
),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}