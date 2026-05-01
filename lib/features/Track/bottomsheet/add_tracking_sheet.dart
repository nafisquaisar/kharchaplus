import 'package:flutter/material.dart';

class AddTrackingSheet extends StatefulWidget {
  final Function(String name) onAdd;

  const AddTrackingSheet({super.key, required this.onAdd});

  @override
  State<AddTrackingSheet> createState() => _AddTrackingSheetState();
}

class _AddTrackingSheetState extends State<AddTrackingSheet> {
  final controller = TextEditingController();

  void submit() {
    if (controller.text.isEmpty) return;

    widget.onAdd(controller.text.trim());
    Navigator.pop(context);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Tracking",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter tracking name (Milk, Gym...)",
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              child: const Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}