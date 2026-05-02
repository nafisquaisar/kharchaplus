import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../constants/KharchaThemeColors.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const AppDrawer({
    super.key,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // 🔥 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.totalContainerStart,
                    AppColors.totalContainerEnd,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nafis Sir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Welcome back 👋",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 MENU ITEMS
            _buildItem(Icons.home, "Home", 0),
            _buildItem(Icons.account_balance_wallet, "Expense", 1),
            _buildItem(Icons.track_changes, "Tracking", 2),
            _buildItem(Icons.people, "Friend", 3),
            _buildItem(Icons.person, "Profile", 4),

            const Spacer(),

            const Divider(),

            _buildItem(Icons.settings, "Settings", -1),
            _buildLogoutItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem() {
    return Builder(
      builder: (context) => ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        onTap: () async {
          Navigator.pop(context);

          final vm = context.read<AuthViewModel>();
          await vm.logout();
        },
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, int index) {
    return Builder(
      builder: (context) => ListTile(
        leading: Icon(icon, color: AppColors.textPrimary),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (index != -1) {
            onItemTap(index);
          }
        },
      ),
    );
  }
}