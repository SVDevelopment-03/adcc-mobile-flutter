import 'package:flutter/material.dart';
import 'package:adcc/features/languageOption/view/languageSelectionScreen.dart';

class GuestProfileSection extends StatelessWidget {
  final VoidCallback onSignUpLogin;
  final VoidCallback onBrowseEvents;
  final VoidCallback onExploreCommunity;
  final VoidCallback onViewRoutes;

  const GuestProfileSection({
    super.key,
    required this.onSignUpLogin,
    required this.onBrowseEvents,
    required this.onExploreCommunity,
    required this.onViewRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFF5257B5),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 37, 14, 110),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 304,
            padding: const EdgeInsets.fromLTRB(17, 31, 17, 26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F6FC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Color(0xFF5257B5),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to ADCC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 21.66,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    letterSpacing: 0.2,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Sign up to join events, connect with the community, and track your cycling journey.',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.28,
                    letterSpacing: 0.14,
                    color: const Color(0xFF333333).withValues(alpha: 0.95),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 328,
                  height: 51,
                  child: ElevatedButton(
                    onPressed: onSignUpLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5257B5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up / Login',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 37),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available as a guest:',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: Color(0xFF1A1C20),
                  ),
                ),
                const SizedBox(height: 18),
                _GuestOptionButton(
                  label: 'Browse Events',
                  onTap: onBrowseEvents,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'Explore Community',
                  onTap: onExploreCommunity,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'View Tracks',
                  onTap: onViewRoutes,
                ),
                const SizedBox(height: 14),
                _GuestOptionButton(
                  label: 'Language',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelectionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GuestOptionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13.3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(13.3),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: Color(0xFF1A1C20),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
