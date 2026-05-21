import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/AppColors.dart';

class HelpBottomContact extends StatelessWidget {
  const HelpBottomContact({super.key});

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '9801999829',
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
           Text(
            "Still need more help?",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: _makePhoneCall,
            borderRadius: BorderRadius.circular(30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(width: 10),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}