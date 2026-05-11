import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class ElectricityStatsSection extends StatelessWidget {
  final List<ElectricityStatItem> items;

  const ElectricityStatsSection({
	super.key,
	required this.items,
  });

  @override
  Widget build(BuildContext context) {
	return Row(
	  children: items
		  .map((item) => Expanded(child: _StatCell(item: item)))
		  .toList(),
	);
  }
}

class ElectricityStatItem {
  final String label;
  final String value;

  ElectricityStatItem({
	required this.label,
	required this.value,
  });
}

class _StatCell extends StatelessWidget {
  final ElectricityStatItem item;

  const _StatCell({
	required this.item,
  });

  @override
  Widget build(BuildContext context) {
	return Column(
	  children: [
		Text(
		  item.label,
		  style: TextStyle(
			color: AppColors.textSecondary,
			fontSize: 11,
		  ),
		),
		const SizedBox(height: 6),
		Text(
		  item.value,
		  style: TextStyle(
			color: AppColors.accent,
			fontWeight: FontWeight.w600,
		  ),
		),
	  ],
	);
  }
}

