import 'package:flutter/material.dart';
import 'model/electricity_model.dart';
import 'widgets/electricity_card.dart';
import 'bottomsheet/electricity_sheet.dart';
import 'package:intl/intl.dart';

class ElectricityTrackingScreen extends StatefulWidget {
  const ElectricityTrackingScreen({super.key});

  @override
  State<ElectricityTrackingScreen> createState() =>
      _ElectricityTrackingScreenState();
}

class _ElectricityTrackingScreenState
    extends State<ElectricityTrackingScreen> {

  List<ElectricityModel> list = [];
  List<ElectricityModel> filteredList = [];

  final searchController = TextEditingController();
  String filterType = "none";

  @override
  void initState() {
    super.initState();

    /// 🔥 DEMO DATA
    list = [
      ElectricityModel(
        id: "1",
        title: "January Bill",
        startDate: DateTime(2024, 1, 5),
        endDate: DateTime(2024, 2, 4),
        prevUnit: 1200,
        currentUnit: 1350,
        rate: 8,
      ),
      ElectricityModel(
        id: "2",
        title: "February Bill",
        startDate: DateTime(2024, 2, 5),
        endDate: DateTime(2024, 3, 4),
        prevUnit: 1350,
        currentUnit: 1500,
        rate: 7.5,
      ),
    ];

    /// 🔥 IMPORTANT (copy list)
    filteredList = [...list];
  }

  void openSheet({ElectricityModel? model}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ElectricitySheet(
        model: model,
        onSave: (data) {
          setState(() {
            if (model == null) {
              list.add(data);
            } else {
              final index =
              list.indexWhere((e) => e.id == model.id);
              list[index] = data;
            }
            applyFilter();
          });
        },
      ),
    );
  }

  /// 🔍 SEARCH + FILTER LOGIC
  void applyFilter() {
    List<ElectricityModel> temp = [...list];

    final query = searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      temp = temp.where((e) {
        final title = e.displayTitle.toLowerCase();
        final date = DateFormat("d MMM yyyy")
            .format(e.startDate)
            .toLowerCase();

        return title.contains(query) || date.contains(query);
      }).toList();
    }

    /// 🎯 SORTING
    if (filterType == "high") {
      temp.sort((a, b) => b.total.compareTo(a.total));
    } else if (filterType == "low") {
      temp.sort((a, b) => a.total.compareTo(b.total));
    }

    setState(() {
      filteredList = temp;
    });
  }

  /// 🎯 FILTER MENU
  void openFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Highest Bill"),
            onTap: () {
              filterType = "high";
              applyFilter();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Lowest Bill"),
            onTap: () {
              filterType = "low";
              applyFilter();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Reset"),
            onTap: () {
              filterType = "none";
              applyFilter();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Electricity Tracking"),
        actions: [
          IconButton(
            onPressed: openFilterMenu,
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),

      body: Column(
        children: [

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) => applyFilter(),
              decoration: InputDecoration(
                hintText: "Search by title or date...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// 📦 LIST
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text("No data found"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final e = filteredList[index];

                return ElectricityCard(
                  model: e,
                  onLongPress: () => openSheet(model: e),
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