import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/electricity_model.dart';

class ElectricityCard extends StatelessWidget {
  final ElectricityModel model;
  final VoidCallback onLongPress;

  const ElectricityCard({
    super.key,
    required this.model,
    required this.onLongPress,
  });

  String formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TITLE + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    model.displayTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 📅 DATE RANGE
            Text(
              "${formatDate(model.startDate)}  →  ${formatDate(model.endDate)}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            /// 💰 TOTAL BILL
            const Text(
              "Total Bill",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 4),

            Text(
              "₹ ${model.total.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            /// 🔥 DETAILS GRID (RESPONSIVE)
            Row(
              children: [
                Expanded(child: _item("Prev", "${model.prevUnit}")),
                Expanded(child: _item("Current", "${model.currentUnit}")),
                Expanded(child: _item("Used", "${model.consumed}")),
                Expanded(child: _item("Rate", "₹${model.rate}")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}