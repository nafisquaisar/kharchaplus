import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../viewmodel/profile_view_model.dart';
import '../widgets/InfoRow.dart';
import '../widgets/SectionCard.dart';
import '../widgets/SettingTile.dart';
import '../widgets/SummaryGrid.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProfileViewModel>().loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔹 HEADER
            ProfileHeader(
              name: vm.name,
              email: vm.email,
            ),

            /// 🔹 SUMMARY CARDS
            SummaryGrid(vm: vm),

            /// 💳 SUBSCRIPTION
            SectionCard(
              title: "Subscription",
              icon: Icons.workspace_premium,
                child: Container(
                  padding: const EdgeInsets.all(10), // 🔻 reduced
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff5B5FEF),
                        Color(0xff7C3AED),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        blurRadius: 8, // 🔻 reduced
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      /// LEFT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PLAN",
                              style: TextStyle(
                                fontSize: 10, // 🔻 reduced
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              vm.plan,
                              style: const TextStyle(
                                fontSize: 18, // 🔻 reduced
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Premium features",
                              style: TextStyle(
                                fontSize: 11, // 🔻 reduced
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// BUTTON
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, // 🔻 reduced
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Upgrade",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5B5FEF),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Column  (
              children: [

                /// 🔹 LOGOUT
                GestureDetector(
                  onTap: vm.logout,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.logout, color: Colors.blue),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),

                /// 🔥 DELETE ACCOUNT (DANGER STYLE)
                GestureDetector(
                  onTap: () {
                    _showDeleteDialog(context, vm);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.red.withOpacity(0.08),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.15),
                          ),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ),

                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }



  void _showDeleteDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Delete Account"),
        content: const Text(
          "This action is permanent and cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

}