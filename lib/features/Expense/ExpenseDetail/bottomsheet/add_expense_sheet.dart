import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenseSheet extends StatefulWidget {
  final Function(String title, String amount, String date) onAdd;

  const AddExpenseSheet({super.key, required this.onAdd});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String selectedCategory = "Food";

  final List<Map<String, dynamic>> categories = [
    {"name": "Food", "icon": Icons.restaurant},
    {"name": "Rent", "icon": Icons.home},
    {"name": "Snacks", "icon": Icons.fastfood},
    {"name": "Transport", "icon": Icons.directions_car},
    {"name": "Misc", "icon": Icons.category},
  ];

  String formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void submit() {
    if (amountController.text.isEmpty) {
      showError("Amount is required");
      return;
    }

    widget.onAdd(
      selectedCategory,
      amountController.text,
      formatDate(selectedDate),
    );

    Navigator.pop(context);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  InputDecoration input() => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Title
            const Text(
              "Add Expense",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 💰 Amount
            const Text("Amount"),
            const SizedBox(height: 6),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: input().copyWith(prefixText: "₹ "),
            ),

            const SizedBox(height: 16),

            // 📂 Category
            const Text("Category"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map<DropdownMenuItem<String>>((cat) {
                    return DropdownMenuItem<String>(
                      value: cat["name"] as String,
                      child: Row(
                        children: [
                          Icon(cat["icon"] as IconData, size: 18),
                          const SizedBox(width: 8),
                          Text(cat["name"] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedCategory = val!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📅 Date
            const Text("Date"),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate(selectedDate)),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📝 Notes
            const Text("Note (Optional)"),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: input().copyWith(
                hintText: "Lunch with friends",
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: submit,
                  child: const Text("Save Expense"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}