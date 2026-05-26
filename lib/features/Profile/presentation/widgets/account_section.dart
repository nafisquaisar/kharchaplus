import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:provider/provider.dart';

import '../../../auth/viewmodel/auth_viewmodel.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  Widget tile(
      String title,
      BuildContext context,
      IconData icon, {
        bool isDanger = false,
        VoidCallback? onTap,

      }) {
    final Color iconColor =
    isDanger ? AppColors.deleteBackground : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap ?? () {

          },

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              children: [
                // 🔥 ICON BOX
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 14),

                // 🔤 TEXT
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDanger
                          ? AppColors.deleteBackground
                          : AppColors.colorText,
                    ),
                  ),
                ),

                // ➡️ ARROW
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 SECTION TITLE
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            "Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.colorText,
            ),
          ),
        ),

        //
        // tile(
        //   "Linked Accounts",
        //   Icons.link,
        //   onTap: () {},
        // ),

        // 🔥 LOGOUT (DANGER STYLE)
        tile(
          "Logout",
          context,
          Icons.logout,
          isDanger: true,
          onTap: () async {
            final vm =context.read<AuthViewModel>();
            await vm.logout();
          },

        ),
      ],
    );
  }
}