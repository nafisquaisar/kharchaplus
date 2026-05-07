/// 📄 AmountCard.dart

import 'package:flutter/material.dart';

import '../../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../data/model/ExpenseModel.dart';
import 'AmountCard/AmountField.dart';
import 'AmountCard/ExpenseTypeSelector.dart';
import 'AmountCard/PaymentModeDropdown.dart';


class AmountCard extends StatelessWidget {
  final TextEditingController amountController;

  final ExpenseType expenseType;
  final PaymentMode paymentMode;

  final Function(ExpenseType) onTypeChanged;
  final Function(PaymentMode) onPaymentChanged;

  const AmountCard({
    super.key,
    required this.amountController,
    required this.expenseType,
    required this.paymentMode,
    required this.onTypeChanged,
    required this.onPaymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          /// 💰 Amount
          AmountField(
            controller: amountController,
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              /// 🔥 Income / Expense
              Expanded(
                child: ExpenseTypeSelector(
                  selected: expenseType,
                  onChanged: onTypeChanged,
                ),
              ),

              const SizedBox(width: 10),

              /// 💳 Payment
              Expanded(
                child: PaymentModeDropdown(
                  selected: paymentMode,
                  onChanged: onPaymentChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}