import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final String? userName;
  final bool isHome;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final bool hasNotification;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.isHome,
    this.userName,
    required this.onMenuTap,
    required this.onNotificationTap,
    this.hasNotification = true,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    if (hour < 20) return "Good Evening";
    return "Good Night";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: kToolbarHeight, // 🔥 FIX: fixed safe height
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Row(
          children: [
            // ☰ MENU
            InkWell(
              onTap: onMenuTap,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.all(width * 0.015),
                child: Icon(Icons.menu, size: width * 0.07),
              ),
            ),

            SizedBox(width: width * 0.03),

            // 🔥 TITLE / GREETING
            Expanded(
              child: isHome
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // 🔥 IMPORTANT
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getGreeting()} 👋",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    userName ?? "Sir",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔔 NOTIFICATION
            InkWell(
              onTap: onNotificationTap,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications_none_rounded,
                        size: width * 0.07),
                    if (hasNotification)
                      Positioned(
                        right: -1,
                        top: -1,
                        child: Container(
                          width: width * 0.025,
                          height: width * 0.025,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}