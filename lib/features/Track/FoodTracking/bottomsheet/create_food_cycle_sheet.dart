import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/FoodCycle.dart';

class CreateFoodCycleSheet extends StatefulWidget {
  final Function(FoodCycle) onCreate; // ✅ FIXED

  const CreateFoodCycleSheet({super.key, required this.onCreate});

  @override
  State<CreateFoodCycleSheet> createState() =>
      _CreateFoodCycleSheetState();
}

class _CreateFoodCycleSheetState
    extends State<CreateFoodCycleSheet> {
  final priceController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String sundayOption = "2 Meals";

  String formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void submit() {
    if (priceController.text.isEmpty) {
      showError("Price is required");
      return;
    }

    if (startDate == null) {
      showError("Start date required");
      return;
    }

    if (endDate != null && endDate!.isBefore(startDate!)) {
      showError("End date must be after start date");
      return;
    }

    final cycle = FoodCycle(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      price: double.parse(priceController.text),
      startDate: startDate!,
      endDate: endDate,
      sundayRule: sundayOption,
    );

    widget.onCreate(cycle);

    Navigator.pop(context);
  }


  InputDecoration input(String hint) => InputDecoration(
    hintText: hint,
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
            const Text(
              "Create Food Cycle",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 💰 Price
            const Text("Price per meal"),
            const SizedBox(height: 6),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: input("Enter price"),
            ),

            const SizedBox(height: 16),

            // 📅 Start Date
            const Text("Start Date"),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => pickDate(true),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(startDate == null
                        ? "Select Date"
                        : formatDate(startDate!)),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📅 End Date
            const Text("End Date (Optional)"),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => pickDate(false),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(endDate == null
                        ? "Select Date"
                        : formatDate(endDate!)),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🍱 Sunday Rule
            const Text("Sunday Rule"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sundayOption,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "2 Meals", child: Text("2 Meals")),
                    DropdownMenuItem(value: "1 Meal", child: Text("1 Meal")),
                    DropdownMenuItem(value: "Off", child: Text("Off")),
                  ],
                  onChanged: (v) => setState(() => sundayOption = v!),
                ),
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
                  child: const Text("Create Cycle"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}