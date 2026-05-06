import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../constants/KharchaThemeColors.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemTap;
  final int selectedIndex;

  const AppDrawer({
    super.key,
    required this.onItemTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final user = vm.currentUser;

    final name = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : "User";

    final email = (user?.email != null && user!.email!.isNotEmpty)
        ? user.email!
        : "No email";

    final photo = user?.photoUrl;

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔥 HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.totalContainerGradient,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 👤 Profile Image
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.card,
                      child: ClipOval(
                        child: photo != null && photo.isNotEmpty
                            ? Image.network(
                          photo,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.accent,
                          ),
                        )
                            : Icon(Icons.person,
                            size: 32, color: AppColors.accent),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 👤 Name
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// 📧 Email
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔥 MENU ITEMS
              _buildItem(context, Icons.home, "Home", 0),
              _buildItem(context, Icons.account_balance_wallet, "Expense", 1),
              _buildItem(context, Icons.track_changes, "Tracking", 2),
              _buildItem(context, Icons.people, "Friend", 3),
              _buildItem(context, Icons.person, "Profile", 4),

              const SizedBox(height: 10),

              Divider(color: AppColors.border),

              _buildItem(context, Icons.settings, "Settings", -1),
              _buildLogoutItem(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Menu Item (with selection highlight)
  Widget _buildItem(
      BuildContext context, IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.accent,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.colorText,
        ),
      ),
      tileColor:
      isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.pop(context);
        if (index != -1) {
          onItemTap(index);
        }
      },
    );
  }

  /// 🔹 Logout
  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: AppColors.deleteBackground),
      title: Text(
        "Logout",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.deleteBackground,
        ),
      ),
      onTap: () async {
        Navigator.pop(context);
        final vm = context.read<AuthViewModel>();
        await vm.logout();
      },
    );
  }
}