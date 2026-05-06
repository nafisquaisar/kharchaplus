import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/KharchaThemeColors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8, // ↓ reduced
      ),
      padding: EdgeInsets.all(width * 0.035), // ↓ reduced

      decoration: BoxDecoration(
        color: AppColors.map,
        borderRadius: BorderRadius.circular(16), // slightly tighter
        image: const DecorationImage(
          image: AssetImage("assets/images/map.jpg"),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/chip.png",
                height: width * 0.1, // ↓ reduced
              ),
              Icon(Icons.visibility_off,
                  size: width * 0.05,
                  color: AppColors.textSecondary),
            ],
          ),

          SizedBox(height: width * 0.02),

          /// 🔹 Title
          Text(
            "Current Month Balance",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: width * 0.03, // ↓ reduced
            ),
          ),

          SizedBox(height: width * 0.01),

          /// 🔹 Balance
          Text(
            "₹ 0",
            style: TextStyle(
              fontSize: width * 0.07, // ↓ reduced
              fontWeight: FontWeight.bold,
              color: AppColors.colorText,
            ),
          ),

          SizedBox(height: width * 0.025),

          /// 🔹 Month + Year + Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _infoBlock("Month", "May", width),
                  SizedBox(width: width * 0.06),
                  _infoBlock("Year", "2026", width),
                ],
              ),
              Text(
                "0 Txn",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: width * 0.028,
                ),
              )
            ],
          ),

          SizedBox(height: width * 0.03),

          /// 🔹 Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _incomeExpense(
                icon: Icons.arrow_upward,
                title: "Income",
                amount: "₹0",
                color: Colors.green,
                width: width,
              ),
              _incomeExpense(
                icon: Icons.arrow_downward,
                title: "Expense",
                amount: "₹0",
                color: AppColors.deleteBackground,
                width: width,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(String title, String value, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: width * 0.028,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: width * 0.038,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _incomeExpense({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
    required double width,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: width * 0.045),
        SizedBox(width: width * 0.01),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: width * 0.028,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
