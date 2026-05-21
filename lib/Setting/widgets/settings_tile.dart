import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/AppColors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  /// optional toggle
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

   SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
  });

  bool get hasSwitch =>
      switchValue != null && onSwitchChanged != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: hasSwitch ? null : onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        child: Row(
          children: [
            /// 🔥 ICON BOX
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarybg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.accent,
                size: 21,
              ),
            ),

             SizedBox(width: 14),

            /// 🔥 TITLE
            Expanded(
              child: Text(
                title,
                style:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),

            /// 🔥 SWITCH / ARROW
            hasSwitch
                ? Transform.scale(
              scale: .9,
              child: CupertinoSwitch(
                value: switchValue!,
                activeTrackColor: AppColors.primary,
                onChanged: onSwitchChanged,
              ),
            )
                :  Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}