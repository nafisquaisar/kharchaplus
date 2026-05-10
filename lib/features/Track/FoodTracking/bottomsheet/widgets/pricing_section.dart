import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'section_card.dart';
import 'section_title.dart';

class PricingSection
    extends StatelessWidget {

  final TextEditingController
  monthlyAmountController;

  final TextEditingController
  monthlyFeeController;

  const PricingSection({
    super.key,
    required this.monthlyAmountController,
    required this.monthlyFeeController,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const SectionTitle(
          title: "Pricing",
        ),

        SectionCard(

          child: Column(

            children: [

              // MONTHLY MESS AMOUNT

              CustomTextField(

                controller:
                monthlyAmountController,

                hint:
                "Monthly mess amount",

                icon:
                Icons.currency_rupee,

                keyboardType:
                TextInputType.number,

                suffixText: "INR",
              ),

              // const SizedBox(
              //   height: 12,
              // ),
              //
              // // EXTRA MONTHLY FEE
              //
              // CustomTextField(
              //
              //   controller:
              //   monthlyFeeController,
              //
              //   hint:
              //   "Extra monthly fee",
              //
              //   icon:
              //   Icons.payments_outlined,
              //
              //   keyboardType:
              //   TextInputType.number,
              //
              //   suffixText: "INR",
              // ),
            ],
          ),
        ),
      ],
    );
  }
}