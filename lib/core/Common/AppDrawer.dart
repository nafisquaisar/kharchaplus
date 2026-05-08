import 'package:cached_network_image/cached_network_image.dart';
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

    final width = MediaQuery.of(context).size.width;

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
        bottom: false,

        child: Column(
          children: [
            /// =========================
            /// PREMIUM HEADER
            /// =========================
            Container(
              width: double.infinity,

              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 18,

                left: 18,
                right: 18,
                bottom: 22,
              ),

              decoration: const BoxDecoration(
                gradient: AppColors.kharchaGradient,

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),

                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// TOP ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      /// APP NAME
                      Text(
                        "Kharcha Plus",

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: width * 0.05,

                          fontWeight: FontWeight.w700,

                          letterSpacing: 0.4,
                        ),
                      ),

                      /// CLOSE BUTTON
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Container(
                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.14),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.close_rounded,

                            color: Colors.white,

                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  /// PREMIUM / FREE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,

                          color: Colors.amber,

                          size: 16,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "Premium",

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: width * 0.03,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// PROFILE SECTION
                  Row(
                    children: [
                      /// PROFILE IMAGE
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),

                              blurRadius: 18,

                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),

                        child: Container(
                          padding: const EdgeInsets.all(3),

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,

                            color: Colors.white,
                          ),

                          child: CircleAvatar(
                            radius: 36,

                            backgroundColor: Colors.white,

                            child: ClipOval(
                              child: photo != null && photo.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: photo,

                                      width: 72,
                                      height: 72,

                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.person_rounded,

                                      size: 34,

                                      color: AppColors.accent,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      /// USER INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              name,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: width * 0.05,

                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              email,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.white.withOpacity(0.84),

                                fontSize: width * 0.031,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// =========================
            /// MENU ITEMS
            /// =========================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: Column(
                  children: [
                    _buildItem(context, Icons.home_rounded, "Home", 0),

                    _buildItem(
                      context,
                      Icons.account_balance_wallet_rounded,
                      "Expense",
                      1,
                    ),

                    _buildItem(
                      context,
                      Icons.track_changes_rounded,
                      "Tracking",
                      2,
                    ),

                    // _buildItem(context, Icons.people_rounded, "Friend", 3),

                    _buildItem(context, Icons.person_rounded, "Profile", 3),

                    const SizedBox(height: 10),

                    Divider(color: AppColors.border),

                    const SizedBox(height: 6),

                    _buildItem(context, Icons.settings, "Settings", -1),

                    _buildLogoutItem(context),
                  ],
                ),
              ),
            ),

            /// =========================
            /// VERSION
            /// =========================
            Padding(
              padding: const EdgeInsets.only(bottom: 18),

              child: Column(
                children: [
                  Text(
                    "Version 1.0.0",

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: width * 0.03,

                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "Built with ❤️ by Kharcha Plus",

                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),

                      fontSize: width * 0.026,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// MENU ITEM
  /// =========================
  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () {
            Navigator.pop(context);

            if (index != -1) {
              onItemTap(index);
            }
          },

          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.10)
                  : Colors.transparent,

              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              children: [
                Icon(
                  icon,

                  size: 22,

                  color: isSelected ? AppColors.primary : AppColors.accent,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    style: TextStyle(
                      fontSize: 15,

                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,

                      color: isSelected
                          ? AppColors.primary
                          : AppColors.colorText,
                    ),
                  ),
                ),

                if (isSelected)
                  Container(
                    width: 8,
                    height: 8,

                    decoration: const BoxDecoration(
                      color: AppColors.primary,

                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Widget _buildLogoutItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () async {
            Navigator.pop(context);

            final vm = context.read<AuthViewModel>();

            await vm.logout();
          },

          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

            child: Row(
              children: [
                Icon(Icons.logout_rounded, color: AppColors.deleteBackground),

                const SizedBox(width: 14),

                Text(
                  "Logout",

                  style: TextStyle(
                    fontSize: 15,

                    fontWeight: FontWeight.w600,

                    color: AppColors.deleteBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
