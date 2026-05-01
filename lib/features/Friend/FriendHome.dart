import 'package:flutter/material.dart';
import 'model/friend_model.dart';
import 'widgets/friend_card.dart';
import 'widgets/friend_summary.dart';
import 'widgets/toggle_tab.dart';
import 'bottomsheet/add_friend_sheet.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  List<FriendModel> list = [
    FriendModel(id: "1", name: "Rahul Sharma", amount: 1000, type: "owe", status: "pending"),
    FriendModel(id: "2", name: "Amit Verma", amount: 500, type: "owe", status: "pending"),
    FriendModel(id: "3", name: "Vikas Singh", amount: 500, type: "get", status: "paid"),
  ];

  String selectedTab = "owe";

  void openSheet({FriendModel? model}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddFriendSheet(
        model: model,
        onSave: (data) {
          setState(() {
            if (model == null) {
              list.add(data);
            } else {
              final i = list.indexWhere((e) => e.id == model.id);
              list[i] = data;
            }
          });
        },
      ),
    );
  }

  List<FriendModel> get filtered =>
      list.where((e) => e.type == selectedTab).toList();

  double get totalOwe =>
      list.where((e) => e.type == "owe").fold(0, (s, e) => s + e.amount);

  double get totalGet =>
      list.where((e) => e.type == "get").fold(0, (s, e) => s + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Friend")),

      body: Column(
        children: [
          FriendSummary(totalOwe: totalOwe, totalGet: totalGet),

          ToggleTab(
            selected: selectedTab,
            onChange: (v) => setState(() => selectedTab = v),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final f = filtered[i];
                return FriendCard(
                  model: f,
                  onLongPress: () => openSheet(model: f),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }
}