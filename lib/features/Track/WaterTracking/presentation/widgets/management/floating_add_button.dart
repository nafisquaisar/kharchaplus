import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../bottomsheet/add_purchase_sheet.dart';
import '../../bottomsheet/add_water_sheet.dart';

class FloatingAddButton extends StatelessWidget {
  final int currentIndex;

  const FloatingAddButton({
	super.key,
	required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
	return FloatingActionButton(
	  backgroundColor: AppColors.accent,
	  elevation: 6,
	  onPressed: () {
		if (currentIndex == 0) {
		  _openAddWaterSheet(context);
		} else {
		  _openAddPurchaseSheet(context);
		}
	  },
	  child: const Icon(
		Icons.add,
		color: Colors.white,
	  ),
	);
  }

  void _openAddWaterSheet(BuildContext context) {
	showModalBottomSheet(
	  context: context,
	  isScrollControlled: true,
	  backgroundColor: Colors.transparent,
	  builder: (_) {
		return Padding(
		  padding: EdgeInsets.only(
			bottom: MediaQuery.of(context).viewInsets.bottom,
		  ),
		  child: const AddWaterSheet(),
		);
	  },
	);
  }

  void _openAddPurchaseSheet(BuildContext context) {
	showModalBottomSheet(
	  context: context,
	  isScrollControlled: true,
	  backgroundColor: Colors.transparent,
	  builder: (_) {
		return Padding(
		  padding: EdgeInsets.only(
			bottom: MediaQuery.of(context).viewInsets.bottom,
		  ),
		  child: const PurchaseFormSheet(),
		);
	  },
	);
  }
}

