import 'package:flutter/material.dart';

class JoinEventEmergencyCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const JoinEventEmergencyCard({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 357,
        height: 284,
        padding: const EdgeInsets.only(
          top: 28,
          right: 27,
          bottom: 23,
          left: 27,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFffffff),
          borderRadius: BorderRadius.circular(20.6999),
          border: Border.all(
            color: const Color(0xFFffffff),
            width: 1.5083,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Text(
              "Emergency Contact",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20.6922),

            /// NAME LABEL
            const Text(
              "Emergency Contact Name *",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            _emergencyTextField(
              controller: nameController,
              hint: "Contact person name",
            ),

            const SizedBox(height: 20.6922),

            /// PHONE LABEL
            const Text(
              "Emergency Contact Phone *",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            _emergencyTextField(
              controller: phoneController,
              hint: "+971 50 123 4567",
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      width: 303,
      height: 43,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black38,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.only(
            top: 4,
            right: 12,
            bottom: 4,
            left: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
