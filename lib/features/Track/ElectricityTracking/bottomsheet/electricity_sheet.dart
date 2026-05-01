import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/electricity_model.dart';

class ElectricitySheet extends StatefulWidget {
  final ElectricityModel? model;
  final Function(ElectricityModel) onSave;

  const ElectricitySheet({
    super.key,
    this.model,
    required this.onSave,
  });

  @override
  State<ElectricitySheet> createState() => _ElectricitySheetState();
}

class _ElectricitySheetState extends State<ElectricitySheet> {
  final titleController = TextEditingController();
  final prevController = TextEditingController();
  final currentController = TextEditingController();
  final rateController = TextEditingController();

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  int consumed = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      final m = widget.model!;
      titleController.text = m.title ?? "";
      prevController.text = m.prevUnit.toString();
      currentController.text = m.currentUnit.toString();
      rateController.text = m.rate.toString();
      start = m.startDate;
      end = m.endDate;
    }

    calculate();
  }

  void calculate() {
    final prev = int.tryParse(prevController.text) ?? 0;
    final current = int.tryParse(currentController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      consumed = current - prev;
      total = consumed * rate;
    });
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? start : end,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          start = picked;
        } else {
          end = picked;
        }
      });
    }
  }

  void submit() {
    final model = ElectricityModel(
      id: DateTime.now().toString(),
      title: titleController.text, // 🔥 ADD THIS
      startDate: start,
      endDate: end,
      prevUnit: int.parse(prevController.text),
      currentUnit: int.parse(currentController.text),
      rate: double.parse(rateController.text),
    );

    widget.onSave(model);
    Navigator.pop(context);
  }

  InputDecoration input(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  String formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  Widget readOnlyBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              const Text("units", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

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
          children: [
            Text(
              widget.model == null
                  ? "Add Electricity"
                  : "Update Electricity",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// 🔥 TITLE
            TextField(
              controller: titleController,
              decoration: input("Title (Optional)"),
            ),

            const SizedBox(height: 12),

            /// 📅 START DATE
            GestureDetector(
              onTap: () => pickDate(true),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Start: ${formatDate(start)}"),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 📅 END DATE
            GestureDetector(
              onTap: () => pickDate(false),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("End: ${formatDate(end)}"),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔢 PREVIOUS
            TextField(
              controller: prevController,
              keyboardType: TextInputType.number,
              decoration: input("Previous Unit"),
              onChanged: (_) => calculate(),
            ),

            const SizedBox(height: 10),

            /// 🔢 CURRENT
            TextField(
              controller: currentController,
              keyboardType: TextInputType.number,
              decoration: input("Current Unit"),
              onChanged: (_) => calculate(),
            ),

            const SizedBox(height: 10),

            /// 📊 CONSUMED (AUTO)
            readOnlyBox("Consumed Unit", "$consumed"),

            const SizedBox(height: 10),

            /// 💰 RATE
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: input("Rate per Unit (₹)"),
              onChanged: (_) => calculate(),
            ),

            const SizedBox(height: 16),

            /// 💵 TOTAL
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Amount"),
                  Text(
                    "₹ ${total.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}