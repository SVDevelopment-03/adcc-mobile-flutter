import 'package:flutter/material.dart';

class PhotoUploadCard extends StatelessWidget {
  const PhotoUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADING
        const Text(
          "Share Your Photos (Optional)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 12),

        /// CONTAINER
        Container(
          width: 357,
          height: 105,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: const Color(0xffE5E5E5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// LEFT SIDE (ICON + TEXT)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                 Image.asset(
  "assets/icons/camera.png",
  width: 30,
  height: 30,
 color: Color(0XFFA3A3A3),
  fit: BoxFit.contain,
),
                  const SizedBox(height: 6),

                  const Text(
                    "Add Photo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )

                ],
              ),

              /// UPLOAD BUTTON
              Container(
                width: 94,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xffC12D32),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
Image.asset(
  "assets/icons/upload.png",
  width: 16,
  height: 16,
  color: Colors.white,
  fit: BoxFit.contain,
),
                    SizedBox(width: 6),

                    Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )

                  ],
                ),
              )

            ],
          ),
        ),
      ],
    );
  }
}