import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/AppColors.dart';
import 'help_tile.dart';

class HelpContactSection extends StatelessWidget {
  const HelpContactSection({super.key});

  /// WHATSAPP CHAT
  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse(
      "https://wa.me/919801999829?text=Hello%20Kharcha%20Plus%20Support",
    );

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("WhatsApp launch error: $e");
    }
  }

  /// EMAIL
  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'kharchaplus@gmail.com',
      queryParameters: {
        'subject': 'Kharcha Plus Support',
      },
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      debugPrint("Email launch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Need Help?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.colorText,
          ),
        ),

        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            children: [
              HelpTile(
                icon: Icons.chat_bubble_outline_rounded,
                title: "Contact Us",
                subtitle: "Chat with our support team",
                onTap: _openWhatsApp,
              ),

              _divider(),

              HelpTile(
                icon: Icons.mail_outline_rounded,
                title: "Send Email",
                subtitle: "kharchaplus@gmail.com",
                onTap: _sendEmail,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 18,
      endIndent: 18,
    );
  }
}