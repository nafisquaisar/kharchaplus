import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/Common/AppDrawer.dart';
import 'core/Common/CommonAppBar.dart';
import 'core/Common/CustomBottomNav.dart';

import 'core/constants/KharchaThemeColors.dart';

import 'features/Expense/presentation/screens/expense_screen.dart';
import 'features/Home/home_screen.dart';
import 'features/Profile/presentation/view/profile_screen.dart';
import 'features/Track/tracking_screen.dart';

import 'features/auth/viewmodel/auth_viewmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int _currentIndex = 0;

  final GlobalKey<ScaffoldState>
  _scaffoldKey = GlobalKey();

  late final List<Widget> _screens;

  final List<String> _titles = [
    "Home",
    "Expense",
    "Tracking",
    "Profile",
  ];

  @override
  void initState() {
    super.initState();

    /// ✅ KEEP SCREEN STATE
    _screens = const [
      Home(),
      ExpenseScreen(),
      TrackingScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final vm =
    context.watch<AuthViewModel>();

    final user = vm.currentUser;

    final name =
    (user?.displayName != null &&
        user!
            .displayName!
            .isNotEmpty)
        ? user.displayName!
        : "User";

    return Scaffold(
      key: _scaffoldKey,

      /// ✅ BODY BEHIND NAVBAR
      extendBody: true,

      resizeToAvoidBottomInset: true,

      backgroundColor:
      AppColors.background,

      /// DRAWER
      drawer: AppDrawer(
        selectedIndex: _currentIndex,

        onItemTap: (index) {

          setState(() {
            _currentIndex = index;
          });

          Navigator.pop(context);
        },
      ),

      /// APP BAR
      appBar: PreferredSize(
        preferredSize: Size(
          size.width,
          70,
        ),

        child: CommonAppBar(
          isHome: _currentIndex == 0,

          isDashboard: true,

          title:
          _titles[_currentIndex],

          userName: name,

          onMenuTap: () {
            _scaffoldKey.currentState
                ?.openDrawer();
          },

          onNotificationTap: () {},
        ),
      ),

      /// ✅ RESPONSIVE BODY
      body: SafeArea(
        bottom: false,

        child: IndexedStack(
          index: _currentIndex,

          children: _screens,
        ),
      ),

      /// ✅ FLOATING GLASS NAV
      bottomNavigationBar:
      CustomBottomNav(
        currentIndex: _currentIndex,

        onTap: (index) {

          if (_currentIndex == index) {
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}