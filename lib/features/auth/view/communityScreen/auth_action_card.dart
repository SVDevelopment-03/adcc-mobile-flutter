import 'package:flutter/material.dart';

class AuthActionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final bool selected;

  const AuthActionCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color:selected ? Color.fromARGB(255, 149, 200, 255): Colors.grey.shade300, 
          width: 1.5),
          color: Colors.white.withValues( alpha: 0.6),
        ),
        child: Row(
          children: [
            /// Icon circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 18,
                  height: 18,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
