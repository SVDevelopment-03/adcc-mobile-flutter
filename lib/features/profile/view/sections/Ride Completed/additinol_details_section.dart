import 'package:flutter/material.dart';

class AdditionalThoughtsCard extends StatelessWidget {
  const AdditionalThoughtsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADING
        const Text(
          "Additional Thoughts",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 12),

        /// TEXT BOX CONTAINER
        Container(
          width: 356,
          height: 159,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffE9E4DB),
            borderRadius: BorderRadius.circular(16.4),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.1659,
            ),
          ),
          child: TextField(
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: "Share details about your experience.",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}