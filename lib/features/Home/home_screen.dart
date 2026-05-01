import 'package:flutter/material.dart';
import 'widgets/balance_card.dart';
import 'widgets/overview_header.dart';
import 'widgets/overview_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 10),

            BalanceCard(),

            SizedBox(height: 20),

            OverviewHeader(),

            Expanded(child: OverviewList()),
          ],
        ),
      ),
    );
  }
}