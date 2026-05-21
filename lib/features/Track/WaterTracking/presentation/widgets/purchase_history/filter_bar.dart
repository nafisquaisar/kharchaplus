import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../domain/enum/purchase_type.dart';
import '../../providers/purchase_history/purchase_history_filter_provider.dart';

class PurchaseHistoryFilterBar extends ConsumerWidget {
  final List<int> years;

  const PurchaseHistoryFilterBar({
    super.key,
    required this.years,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(purchaseHistoryFilterProvider);
    final notifier = ref.read(purchaseHistoryFilterProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDropdown<int?>(
                context: context,
                label: 'Month',
                value: filter.month,
                items: List.generate(12, (index) {
                  final value = index + 1;
                  return DropdownMenuItem(
                    value: value,
                    child: Text(_monthName(value)),
                  );
                }),
                onChanged: (value) => notifier.setMonth(value),
              ),
              _buildDropdown<int?>(
                context: context,
                label: 'Year',
                value: filter.year,
                items: years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text('$year'),
                  );
                }).toList(),
                onChanged: (value) => notifier.setYear(value),
              ),
              _buildDropdown<PurchaseType?>(
                context: context,
                label: 'Type',
                value: filter.type,
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
                onChanged: (value) => notifier.setType(value),
              ),
              _buildDropdown<PurchaseSort>(
                context: context,
                label: 'Sort',
                value: filter.sort,
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
                  if (value != null) {
                    notifier.setSort(value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.primarybg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      ),
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

