import 'package:flutter/material.dart';

import '../constants/AppColors.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final String? userName;
  final bool isHome;
  final bool isDashboard;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final bool hasNotification;
  final bool showMore;
  final VoidCallback? onMoreTap;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.isHome,
    this.userName,
    required this.onMenuTap,
    required this.onNotificationTap,
    this.hasNotification = true,
    this.showMore = false,
    this.onMoreTap,
    this.isDashboard=false,
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



    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient, // 🔥 gradient applied
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            children: [
              // ☰ MENU
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.015),
                  child: Icon(
                    isDashboard ? Icons.menu : Icons.arrow_back,
                    size: width * 0.07,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: width * 0.03),

              // 🔥 TITLE / GREETING
              Expanded(
                child: isHome
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getGreeting()} 👋",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.032,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName ?? "Sir",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
              ),

              // 🔔 NOTIFICATION
              /// 🔥 RIGHT ACTION
              if (isDashboard)
                _buildNotification(width)
              else if (showMore)
                _buildMoreButton(width)
              else
                SizedBox(width: width * 0.07),
                        ],
          ),
        ),
      ),
    );
  }


  Widget _buildNotification(double width) {
    return InkWell(
      onTap: onNotificationTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: width * 0.07,
              color: Colors.white,
            ),
            if (hasNotification)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: width * 0.025,
                  height: width * 0.025,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildMoreButton(double width) {
    return InkWell(
      onTap: onMoreTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Icon(
          Icons.more_vert,
          size: width * 0.07,
          color: Colors.white,
        ),
      ),
    );
  }

}