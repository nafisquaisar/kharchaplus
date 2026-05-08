import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/KharchaThemeColors.dart';
import '../../Expense/data/model/ExpenseCardModel.dart';
import '../../Expense/presentation/viewmodel/expense_viewmodel.dart';

class BalanceCard extends StatefulWidget {
  final ExpenseCardModel? selectedCard;

  final ExpenseViewModel expenseVm;

  const BalanceCard({
    super.key,
    required this.selectedCard,
    required this.expenseVm,
  });

  @override
  State<BalanceCard> createState() =>
      _BalanceCardState();
}

class _BalanceCardState
    extends State<BalanceCard> {

  /// ✅ DEFAULT HIDDEN
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    final cardDate =
        widget.selectedCard?.startDate;

    final day = cardDate != null
        ? DateFormat('dd').format(cardDate)
        : "--";

    final month = cardDate != null
        ? DateFormat('MMM').format(cardDate)
        : "--";

    final year = cardDate != null
        ? DateFormat('yyyy').format(cardDate)
        : "--";


    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8,
      ),

      padding: EdgeInsets.all(
        width * 0.035,
      ),

      decoration: BoxDecoration(
        color: AppColors.map,

        borderRadius:
        BorderRadius.circular(16),

        image: const DecorationImage(
          image: AssetImage(
            "assets/images/map.jpg",
          ),

          fit: BoxFit.cover,

          opacity: 0.3,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TOP TITLE
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Text(
                "Current Balance",

                style: TextStyle(
                  color:
                  AppColors.textSecondary,

                  fontSize:
                  width * 0.03,
                ),
              ),

              /// 👁️ VISIBILITY TOGGLE
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },

                child: Icon(
                  isHidden
                      ? Icons.visibility_off
                      : Icons.visibility,

                  size: width * 0.07,

                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(
            height: width * 0.01,
          ),

          /// 💰 BALANCE
          Text(
            isHidden
                ? "₹ ******"
                : "₹ ${widget.expenseVm.balance.toStringAsFixed(0)}",

            style: TextStyle(
              fontSize: width * 0.07,

              fontWeight:
              FontWeight.bold,

              color:
              AppColors.colorText,
            ),
          ),

          SizedBox(
            height: width * 0.01,
          ),

          /// CHIP + INCOME EXPENSE
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Image.asset(
                "assets/images/chip.png",

                height: width * 0.15,
              ),

              /// INCOME
              _incomeExpense(
                icon:
                Icons.arrow_upward,

                title: "Income",

                amount: isHidden
                    ? "₹ ******"
                    : "₹${widget.expenseVm.totalIncome.toStringAsFixed(0)}",

                color: Colors.green,

                width: width,
              ),

              /// EXPENSE
              _incomeExpense(
                icon:
                Icons.arrow_downward,

                title: "Expense",

                amount: isHidden
                    ? "₹ ******"
                    : "₹${widget.expenseVm.totalExpense.toStringAsFixed(0)}",

                color:
                AppColors.deleteBackground,

                width: width,
              ),
            ],
          ),

          SizedBox(
            height: width * 0.025,
          ),

          /// BOTTOM SECTION
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              /// DATE SECTION
              Row(
                children: [

                  _infoBlock(
                    "Day",
                    day,
                    width,
                  ),

                  SizedBox(
                    width:
                    width * 0.06,
                  ),

                  _infoBlock(
                    "Month",
                    month,
                    width,
                  ),

                  SizedBox(
                    width:
                    width * 0.06,
                  ),

                  _infoBlock(
                    "Year",
                    year,
                    width,
                  ),
                ],
              ),

              /// TXN COUNT
              Text(
                "${widget.expenseVm.expenses.length} Txn",

                style: TextStyle(
                  color:
                  AppColors.black,

                  fontSize:
                  width * 0.03,

                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(
      String title,
      String value,
      double width,
      ) {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: TextStyle(
            color:
            AppColors.textSecondary,

            fontSize:
            width * 0.028,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize:
            width * 0.038,

            fontWeight:
            FontWeight.bold,

            color:
            AppColors.colorText,
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

        Icon(
          icon,

          color: color,

          size: width * 0.045,
        ),

        SizedBox(
          width: width * 0.01,
        ),

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: TextStyle(
                color: color,

                fontSize:
                width * 0.028,
              ),
            ),

            Text(
              amount,

              style: TextStyle(
                fontWeight:
                FontWeight.bold,

                fontSize:
                width * 0.035,
              ),
            ),
          ],
        ),
      ],
    );
  }
}