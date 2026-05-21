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

class _PurchaseHistoryFilterSheetState extends ConsumerState<PurchaseHistoryFilterSheet> {
  late int? _month;
  late int? _year;
  late PurchaseType? _type;
  late PurchaseSort _sort;

  @override
  void initState() {
    super.initState();

    final filter = ref.read(
      purchaseHistoryFilterProvider,
    );

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
        MediaQuery.of(context).padding.bottom + 18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP HANDLE
            Center(
              child: Container(
                height: 5,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// HEADER
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.kharchaGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter Purchases',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Refine your purchase history',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// MONTH
            _PremiumDropdown<int?>(
              title: 'Month',
              icon: Icons.calendar_month_rounded,
              value: _month,
              hint: 'Select month',
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Months'),
                ),
                ...List.generate(
                  12,
                  (index) {
                    final value = index + 1;

                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        _monthName(value),
                      ),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _month = value;
                });
              },
            ),

            const SizedBox(height: 16),

            /// YEAR
            _PremiumDropdown<int?>(
              title: 'Year',
              icon: Icons.date_range_rounded,
              value: _year,
              hint: 'Select year',
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Years'),
                ),
                ...widget.years.map(
                  (year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year'),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _year = value;
                });
              },
            ),

            const SizedBox(height: 16),

            /// TYPE
            _PremiumDropdown<PurchaseType?>(
              title: 'Bottle Type',
              icon: Icons.water_drop_rounded,
              value: _type,
              hint: 'Select bottle type',
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Types'),
                ),
                ...PurchaseType.values.map(
                  (type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
            ),

            const SizedBox(height: 16),

            /// SORT
            _PremiumDropdown<PurchaseSort>(
              title: 'Sort By',
              icon: Icons.sort_rounded,
              value: _sort,
              hint: 'Sort purchases',
              items: const [
                DropdownMenuItem(
                  value: PurchaseSort.latest,
                  child: Text('Latest First'),
                ),
                DropdownMenuItem(
                  value: PurchaseSort.oldest,
                  child: Text('Oldest First'),
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

            const SizedBox(height: 28),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(
                            purchaseHistoryFilterProvider.notifier,
                          )
                          .reset();

                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      side: BorderSide(
                        color: AppColors.accent.withOpacity(0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final notifier = ref.read(
                        purchaseHistoryFilterProvider.notifier,
                      );

                      notifier.setMonth(_month);
                      notifier.setYear(_year);
                      notifier.setType(_type);
                      notifier.setSort(_sort);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
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

class _PremiumDropdown<T> extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _PremiumDropdown({
    required this.title,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 8,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: AppColors.textSecondary,
              ),

               SizedBox(width: 6),

              Text(
                title,
                style:  TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: DropdownButtonFormField<T>(
              initialValue: value,
              isExpanded: false, // 👈 change this
              menuMaxHeight: 280,


              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accent.withOpacity(0.8),
              ),

              borderRadius: BorderRadius.circular(22),
              dropdownColor: AppColors.primarybg,
              elevation: 8,

              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primarybg,

                hintText: hint,

                hintStyle:  TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),

                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(22),

                  borderSide: BorderSide(
                    color: AppColors.accent.withOpacity(0.08),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),

                  borderSide: BorderSide(
                    color: AppColors.accent.withOpacity(0.25),
                    width: 1.4,
                  ),
                ),
              ),

              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),

              selectedItemBuilder: (context) {
                return items.map((item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (item.child as Text).data ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  );
                }).toList();
              },

              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item.value,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 14,
                    ),


                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: Text(
                      (item.child as Text).data ?? '',
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

