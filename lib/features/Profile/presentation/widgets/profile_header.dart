import 'package:flutter/material.dart';
import '../../../../core/constants/KharchaThemeColors.dart';
import '../../../../core/constants/colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 16), // 🔻 reduced
      decoration: const BoxDecoration(
        gradient: AppColors.authGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24), // 🔻 slightly reduced
        ),
      ),
      child: Column(
        children: [

          /// 🔹 PROFILE IMAGE + EDIT BUTTON
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3, // 🔻 reduced
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 30, // 🔻 reduced from 50
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.grey),
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.all(5), // 🔻 reduced
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.buttonGradient,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 10, // 🔻 reduced
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10), // 🔻 reduced

          /// 🔹 NAME
          Text(
            name,
            style: const TextStyle(
              fontSize: 18, // 🔻 reduced
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 2),

          /// 🔹 EMAIL
          Text(
            email,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontSize: 12, // 🔻 reduced
            ),
          ),

          const SizedBox(height: 8),

          /// 🔹 EDIT PROFILE CHIP
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10, // 🔻 reduced
                vertical: 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12, // 🔻 reduced
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}