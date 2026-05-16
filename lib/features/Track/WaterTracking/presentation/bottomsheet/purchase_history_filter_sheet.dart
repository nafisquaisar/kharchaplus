import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/enum/purchase_type.dart';
import '../providers/purchase_history/purchase_history_filter_provider.dart';

class PurchaseHistoryFilterSheet extends ConsumerStatefulWidget {
  final List<int> years;

  const PurchaseHistoryFilterSheet({
    super.key,
    required this.years,
  });

  @override
  ConsumerState<PurchaseHistoryFilterSheet> createState() =>
      _PurchaseHistoryFilterSheetState();
}

class _PurchaseHistoryFilterSheetState
    extends ConsumerState<PurchaseHistoryFilterSheet> {
  late int? _month;
  late int? _year;
  late PurchaseType? _type;
  late PurchaseSort _sort;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(purchaseHistoryFilterProvider);
    _month = filter.month;
    _year = filter.year;
    _type = filter.type;
    _sort = filter.sort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDropdown<int?>(
            label: 'Month',
            value: _month,
            items: List.generate(12, (index) {
              final value = index + 1;
              return DropdownMenuItem(
                value: value,
                child: Text(_monthName(value)),
              );
            }),
            onChanged: (value) {
              setState(() {
                _month = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown<int?>(
            label: 'Year',
            value: _year,
            items: widget.years.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text('$year'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _year = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown<PurchaseType?>(
            label: 'Type',
            value: _type,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All'),
              ),
              ...PurchaseType.values.map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _type = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown<PurchaseSort>(
            label: 'Sort',
            value: _sort,
            items: const [
              DropdownMenuItem(
                value: PurchaseSort.latest,
                child: Text('Latest'),
              ),
              DropdownMenuItem(
                value: PurchaseSort.oldest,
                child: Text('Oldest'),
              ),
              DropdownMenuItem(
                value: PurchaseSort.highestPrice,
                child: Text('Highest Price'),
              ),
              DropdownMenuItem(
                value: PurchaseSort.lowestPrice,
                child: Text('Lowest Price'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _sort = value;
              });
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  ref.read(purchaseHistoryFilterProvider.notifier).reset();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final notifier =
                      ref.read(purchaseHistoryFilterProvider.notifier);
                  notifier.setMonth(_month);
                  notifier.setYear(_year);
                  notifier.setType(_type);
                  notifier.setSort(_sort);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.primarybg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        if (value is int?)
          const DropdownMenuItem(
            value: null,
            child: Text('All'),
          ),
        ...items,
      ],
      onChanged: onChanged,
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}

