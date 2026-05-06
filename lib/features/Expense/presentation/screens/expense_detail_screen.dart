  import 'package:flutter/material.dart';
  import '../../../../core/Common/CommonAppBar.dart';
  import '../../data/model/ExpenseModel.dart';
import '../bottomsheet/AddExpenseSheet/add_expense_sheet.dart';
  import '../widgets/ExpenseDetail/filter_row.dart';
  import '../widgets/ExpenseDetail/transaction_header.dart';
  import '../widgets/ExpenseDetail/transaction_list.dart';
  import '../widgets/ExpenseDetail/summary_card.dart';

  class ExpenseDetailScreen extends StatefulWidget {
    const ExpenseDetailScreen({super.key});

    @override
    State<ExpenseDetailScreen> createState() =>
        _ExpenseDetailScreenState();
  }

  class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {


    List<ExpenseModel> expenses = [
      ExpenseModel(
        id: "1",
        userId: "u1",
        amount: 650,
        currency: "INR",
        categoryId: "c1",
        categoryName: "Food",
        cardId: "1",
        type: ExpenseType.expense,
        paymentMode: PaymentMode.upi,
        date: DateTime(2024, 5, 22),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ExpenseModel(
        id: "2",
        userId: "u1",
        amount: 5000,
        currency: "INR",
        categoryId: "c2",
        categoryName: "Rent",
        cardId: "1",
        type: ExpenseType.expense,
        paymentMode: PaymentMode.cash,
        date: DateTime(2024, 5, 21),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    void openSheet() async {
      final result = await showModalBottomSheet<ExpenseModel>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _AddExpenseWrapper(),
      );

      if (result != null) {
        setState(() {
          expenses.add(result);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FF),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CommonAppBar(
            title: "Home Expenses",
            isHome: false,
            hasNotification: false,
            onMenuTap: () {
            Navigator.pop(context); // back button behavior
            },
            onNotificationTap: () {},
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [

            /// 🔥 SUMMARY (UNCHANGED)
            SummaryCard(
              startDate: "17 May",
              endDate: "30 May",
              totalExpense: 6000,
              totalIncome: 9000,
              balance: 6000,
              trendText: "5% more than last month",
            ),

            const SizedBox(height: 20),

            /// 🔥 FILTER
            FilterRow(
              selected: "All",
              onChanged: (value) {
                setState(() {
                  // selectedFilter = value;
                });
              },
              onFilterTap: () {

              },
              onAddTap: openSheet,
            ),
            const SizedBox(height: 14),

            // /// 🔥 HEADER
            // TransactionHeader(onAdd: openSheet),
            //
            // const SizedBox(height: 8),

            /// 🔥 LIST
            TransactionList(expenses: expenses),
          ],
        ),
      );
    }
  }


  class _AddExpenseWrapper extends StatelessWidget {
    const _AddExpenseWrapper();

    @override
    Widget build(BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: AddExpenseSheet(
              cardId: "1",
              onAdd: (expense) {
                Navigator.pop(context, expense);
              },
            ),
          );
        },
      );
    }
  }