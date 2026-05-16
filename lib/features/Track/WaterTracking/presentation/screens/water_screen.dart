import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/Common/CommonAppBar.dart';
import '../../../../../core/constants/AppColors.dart';
import '../providers/session/water_session_provider.dart';
import '../widgets/management/floating_add_button.dart';
import 'tabs/drinking_tab.dart';
import 'tabs/water_management_tab.dart';

class WaterScreen extends ConsumerStatefulWidget {
  const WaterScreen({
    super.key,
  });

  @override
  ConsumerState<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends ConsumerState<WaterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    ref.read(waterSessionControllerProvider);

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommonAppBar(
          title: "Water",
          isHome: false,
          isDashboard: false,

          onMenuTap: () {
            Navigator.pop(context);
          },

          onNotificationTap: () {},

          showMore: true,

          onMoreTap: () {
            // More options
          },
        ),
      ),

      floatingActionButton: FloatingAddButton(
        currentIndex: currentIndex,

      ),
      body: Column(
        children: [
          // ======================
          // TOP TAB
          // ======================

          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius: BorderRadius.circular(10),

              isScrollable: false,

              labelPadding: EdgeInsets.zero,

              indicator: BoxDecoration(
                gradient: AppColors.kharchaGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              labelColor: Colors.white,
              unselectedLabelColor: AppColors.colorText,

              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),

              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),

              tabs: [
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.local_drink_outlined,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text('Drinking'),
                      ],
                    ),
                  ),
                ),

                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.water_drop_outlined,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text('Water Management'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TAB VIEW
          // ======================

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                DrinkingTab(),
                WaterManagementTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
