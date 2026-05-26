import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../../core/constants/AppColors.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onEditTap;

  const ProfileHeader({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileViewModel, _ProfileHeaderData>(
      selector: (_, vm) => _ProfileHeaderData(
        vm.resolvedName,
        vm.resolvedEmail,
        vm.resolvedPhotoUrl,
      ),
      builder: (context, data, _) {
        final name = data.name.isNotEmpty ? data.name : "User";
        final email = data.email.isNotEmpty ? data.email : "No email";
        final photo = data.photoUrl;

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Stack(
            children: [
              Row(
                children: [
                  /// 🔥 PROFILE IMAGE
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.kharchaGradient,
                          ),
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: AppColors.background,
                            child: ClipOval(
                              child: photo != null && photo.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: photo,
                                      width: 76,
                                      height: 76,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => _avatarFallback(
                                        size: 38,
                                        isLoading: true,
                                      ),
                                      errorWidget: (_, __, ___) => _avatarFallback(
                                        size: 38,
                                        isLoading: false,
                                      ),
                                    )
                                  : _avatarFallback(size: 38, isLoading: false),
                            ),
                          ),
                        ),
                      ),

                      /// 📸 CAMERA BUTTON
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onEditTap,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: AppColors.kharchaGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.card,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  /// 🔥 TEXT SECTION
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// ✏️ EDIT BUTTON
                        GestureDetector(
                          onTap: onEditTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.accent),
                              color: AppColors.accent.withOpacity(0.05),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit,
                                    size: 14, color: AppColors.accent),
                                const SizedBox(width: 6),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// ➡️ ARROW
              Positioned(
                right: 1,
                top: 0,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatarFallback({required double size, required bool isLoading}) {
    if (isLoading) {
      return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Icon(
      Icons.person,
      size: size,
      color: AppColors.textSecondary,
    );
  }
}

class _ProfileHeaderData {
  final String name;
  final String email;
  final String? photoUrl;

  const _ProfileHeaderData(this.name, this.email, this.photoUrl);

  @override
  bool operator ==(Object other) {
    return other is _ProfileHeaderData &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode => Object.hash(name, email, photoUrl);
}
