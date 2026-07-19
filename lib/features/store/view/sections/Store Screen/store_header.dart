import 'package:flutter/material.dart';

class StoreHeader extends StatefulWidget {
  final String imagePath;
  final bool showBackButton;
  final bool showNotificationIcon;
  final VoidCallback? onBackTap;

  const StoreHeader({
    super.key,
    required this.imagePath,
    this.showBackButton = true,
    this.showNotificationIcon = false,
    this.onBackTap,
  });

  @override
  State<StoreHeader> createState() => _StoreHeaderState();
}

class _StoreHeaderState extends State<StoreHeader> {

  void _handleBack() {
    if (widget.onBackTap != null) {
      widget.onBackTap!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [

       
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 380,
                width: double.infinity,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),

         
            Positioned(
              top: 14,
              left: 14,
              right: 14,
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// Back Button
                    if (widget.showBackButton)
                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _handleBack,
                          child: const SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                    /// Notification Icon
                    if (widget.showNotificationIcon)
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

               
                              Image.asset(
                                "assets/icons/circle.png",
                                height: 35,
                                width: 35,
                                fit: BoxFit.contain,
                              ),

                              /// Notification icon
                              Image.asset(
                                "assets/icons/notification_red.png",
                                height: 17.5,
                                width: 17.5,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}