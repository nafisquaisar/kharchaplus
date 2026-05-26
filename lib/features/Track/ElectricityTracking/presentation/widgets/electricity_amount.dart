import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class ElectricityAmountSection extends StatelessWidget {
	final String label;
	final double amount;
	final String currencySymbol;

	const ElectricityAmountSection({
		super.key,
		required this.label,
		required this.amount,
		this.currencySymbol = '₹',
	});

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		return Container(
			padding: const EdgeInsets.symmetric(
				horizontal: 10,
				vertical: 5,
			),

			decoration: BoxDecoration(
				color: colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(8),
			),

			child: Row(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [

					Expanded(
						child: Row(
							children: [
								Center(
								  child: Text(
								  	label,
								  	style: TextStyle(
								  		color: colorScheme.onSurfaceVariant,
								  		fontSize: 11,
								  		fontWeight: FontWeight.w500,
								  	),
								  ),
								),

								const SizedBox(width: 12),

								Text(
									'$currencySymbol${amount.toStringAsFixed(0)}',
									style: TextStyle(
										color: AppColors.accent,
										fontSize: 18,
										fontWeight: FontWeight.w700,
									),
								),
							],
						),
					),

					Container(
						width: 25,
						height: 25,

						decoration: BoxDecoration(
							gradient: AppColors.kharchaGradient,
							borderRadius: BorderRadius.circular(5),
						),

						child: Icon(
							Icons.flash_on_rounded,
							color: colorScheme.onPrimary,
							size: 18,
						),
					),
				],
			),
		);
	}
}