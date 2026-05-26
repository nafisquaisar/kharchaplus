import 'package:flutter/material.dart';

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
	final colorScheme = Theme.of(context).colorScheme;
	return Column(
	  children: [
		Text(
		  item.label,
		  style: TextStyle(
			color: colorScheme.onSurfaceVariant,
			fontSize: 11,
		  ),
		),
		const SizedBox(height: 6),
		Text(
		  item.value,
		  style: TextStyle(
			color: colorScheme.onSurface,
			fontWeight: FontWeight.w600,
		  ),
		),
	  ],
	);
  }
}
