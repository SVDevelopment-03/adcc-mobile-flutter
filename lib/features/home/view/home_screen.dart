import 'package:adcc/features/events/view/events.dart';
import 'package:adcc/features/home/view/home_tab.dart';
import 'package:adcc/features/routes/view/routes_screen.dart';
import 'package:adcc/features/profile/view/screens/profile_screen.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/permission_service.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  final bool fromGuest;
  final int initialIndex;

  const HomeScreen({
    super.key,
    this.fromGuest = false,
    this.initialIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  bool _hasRequestedPermissions = false;

  static const Color _homeBackgroundColor = Color(0xFFEAF3FF);

  List<Widget> get _pages => [
        HomeTab(
          onTabChange: _changeTab,
          fromGuest: widget.fromGuest,
        ),
        const EventsTab(),
        const CommunitiesScreen(),
        const RoutesTab(),
        const ProfileScreen(),
      ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _requestPermissions();
  }

  /// Request location permissions when user signs in
  Future<void> _requestPermissions() async {
    if (_hasRequestedPermissions) return;
    _hasRequestedPermissions = true;

    // Only request permission UI state if not already granted.
    final isGranted = await PermissionService.isLocationPermissionGranted();
    if (!mounted) return;
    if (!isGranted) {
      await PermissionService.requestLocationPermission(context);
    }
    // Do not fetch GPS location or save it—city should come from user profile.
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFEAF3FF),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFEAF3FF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: _homeBackgroundColor,
          body: _pages[_currentIndex],
          bottomNavigationBar: CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
