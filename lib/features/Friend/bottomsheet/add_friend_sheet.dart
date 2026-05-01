import 'package:flutter/material.dart';
import '../model/friend_model.dart';

class AddFriendSheet extends StatefulWidget {
  final FriendModel? model;
  final Function(FriendModel) onSave;

  const AddFriendSheet({
    super.key,
    this.model,
    required this.onSave,
  });

  @override
  State<AddFriendSheet> createState() => _AddFriendSheetState();
}

class _AddFriendSheetState extends State<AddFriendSheet> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  String type = "owe";
  String status = "pending";

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      final m = widget.model!;
      nameController.text = m.name;
      amountController.text = m.amount.toString();
      type = m.type;
      status = m.status;
    }
  }

  void submit() {
    final data = FriendModel(
      id: DateTime.now().toString(),
      name: nameController.text,
      amount: double.parse(amountController.text),
      type: type,
      status: status,
    );

    widget.onSave(data);
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
          const Text("Add Friend",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),

          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),

          DropdownButton<String>(
            value: type,
            items: const [
              DropdownMenuItem(value: "owe", child: Text("You Owe")),
              DropdownMenuItem(value: "get", child: Text("You'll Get")),
            ],
            onChanged: (v) => setState(() => type = v!),
          ),

          DropdownButton<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: "pending", child: Text("Pending")),
              DropdownMenuItem(value: "paid", child: Text("Paid")),
            ],
            onChanged: (v) => setState(() => status = v!),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: submit,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}