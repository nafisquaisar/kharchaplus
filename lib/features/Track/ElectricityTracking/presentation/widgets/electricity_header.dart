import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';


class ElectricityHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const ElectricityHeader({
	super.key,
	required this.title,
	this.subtitle,
	this.trailing,
  });

  @override
  Widget build(BuildContext context) {
	return Row(
	  crossAxisAlignment: CrossAxisAlignment.center,
	  children: [
		Expanded(
		  child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			  Text(
				title,
				style: TextStyle(
				  color: AppColors.primary,
				  fontWeight: FontWeight.w700,
				  fontSize: 18,
				),
			  ),
			  if (subtitle != null) ...[
				const SizedBox(height: 4),
				Text(
				  subtitle!,
				  style: TextStyle(
					color: AppColors.textSecondary,
					fontSize: 12,
				  ),
				),
			  ],
			],
		  ),
		),
		if (trailing != null) trailing!,
	  ],
	);
  }
}

