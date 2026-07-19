import 'package:flutter/material.dart';

class AppHeaderLogin extends StatelessWidget {
  final VoidCallback? onBack;

  const AppHeaderLogin({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
     
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:  Image.asset(
                    'assets/icons/leftArrow.png',
                    height: 50,
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
