import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';


class FoodFilterBottomSheet
    extends StatefulWidget {

  final String selectedStatus;

  final Function(String)
  onApply;

  const FoodFilterBottomSheet({
    super.key,
    required this.selectedStatus,
    required this.onApply,
  });

  @override
  State<FoodFilterBottomSheet>
  createState() =>
      _FoodFilterBottomSheetState();
}

class _FoodFilterBottomSheetState
    extends State<FoodFilterBottomSheet> {

  late String selectedStatus;

  @override
  void initState() {

    super.initState();

    selectedStatus =
        widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      child: Column(

        mainAxisSize:
        MainAxisSize.min,

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Center(

            child: Container(

              width: 45,
              height: 5,

              decoration: BoxDecoration(

                color: Colors.grey.shade300,

                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(

            "Filter Food Cycles",

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          Wrap(

            spacing: 10,

            runSpacing: 10,

            children: [

              filterChip("All"),

              filterChip("active"),

              filterChip("completed"),

              filterChip("paused"),
            ],
          ),

          const SizedBox(height: 28),

          SizedBox(

            width: double.infinity,

            child: ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                AppColors.primary,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              onPressed: () {

                widget.onApply(
                  selectedStatus,
                );

                Navigator.pop(
                  context,
                );
              },

              child: const Text(

                "Apply Filter",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String value) {

    final isSelected =
        selectedStatus == value;

    return InkWell(

      onTap: () {

        setState(() {

          selectedStatus = value;
        });
      },

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color:

          isSelected

              ? AppColors.primary

              : Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(
            14,
          ),
        ),

        child: Text(

          value.toUpperCase(),

          style: TextStyle(

            color:

            isSelected

                ? Colors.white

                : Colors.black87,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}