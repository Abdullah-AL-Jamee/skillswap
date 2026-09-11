import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'screens/booking_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const SkillSwapApp());

/// SkillSwap front end.
///
/// Two screens of the Assessment 3 high-fidelity prototype are implemented:
/// Profile Creation and Skill Listing, and the Session Booking Calendar. The
/// matching feed, in-app chat and rating screens are still prototype-only, as
/// each depends on a backend service that has not been built yet.
class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}

/// Holds the two implemented screens behind a bottom navigation bar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final ProfileStore _store = ProfileStore();
  int _index = 0;

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          ProfileScreen(store: _store),
          const BookingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Booking',
          ),
        ],
      ),
    );
  }
}
