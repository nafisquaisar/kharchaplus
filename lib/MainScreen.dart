import 'package:flutter/material.dart';
import 'core/Common/AppDrawer.dart';
import 'core/Common/CommonAppBar.dart';
import 'core/Common/CustomBottomNav.dart';
import 'core/constants/colors.dart';
import 'features/Expense/expense_screen.dart';
import 'features/Friend/FriendHome.dart';
import 'features/Home/home_screen.dart';
import 'features/Profile/presentation/view/profile_screen.dart';
import 'features/Track/tracking_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home(),
    ExpenseScreen(),
    TrackingScreen(),
    FriendScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    "Home",
    "Expense",
    "Tracking",
    "Friend",
    "Profile",
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,

      // DRAWER
      drawer: AppDrawer(
        onItemTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CommonAppBar(
          isHome: _currentIndex == 0,
          title: _titles[_currentIndex],
          userName: "Nafis Sir",
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          onNotificationTap: () {},
        ),
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
