import 'package:flutter/material.dart';
import '../model/friend_model.dart';

class FriendCard extends StatelessWidget {
  final FriendModel model;
  final VoidCallback onLongPress;

  const FriendCard({
    super.key,
    required this.model,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = model.status == "paid";

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 20),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                model.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹ ${model.amount.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPaid ? "Paid" : "Pending",
                    style: TextStyle(
                      fontSize: 11,
                      color: isPaid ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}