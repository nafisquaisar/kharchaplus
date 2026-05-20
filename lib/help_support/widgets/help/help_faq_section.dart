import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class HelpFaqSection extends StatelessWidget {
  const HelpFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "How do I add a new expense?",
        "answer":
        "Go to the home screen and tap the Expense button at the bottom. Then click the circular plus button, enter your details, and save the expense.",
      },
      {
        "question": "How do we add water intake?",
        "answer":
        "Go to the home screen and tap the Tracking button at the bottom. Then click on Water where you can view and add all water intake details.",
      },
      {
        "question": "Which things does the card show on the home screen?",
        "answer":
        "It shows expenses for a particular cycle. You can change the cycle using the dropdown option.",
      },
      {
        "question": "How do we delete all the data?",
        "answer":
        "Please contact us through chat or email support. We will help delete your data.",
      },
      {
        "question": "How can I export my data?",
        "answer":
        "This feature will be available soon.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FAQ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.colorText,
          ),
        ),

        const SizedBox(height: 18),

        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            children: List.generate(
              faqs.length,
                  (index) => Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 2,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(
                        18,
                        0,
                        18,
                        18,
                      ),
                      iconColor: AppColors.black,
                      collapsedIconColor: AppColors.textSecondary,
                      title: Text(
                        faqs[index]["question"]!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faqs[index]["answer"]!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (index != faqs.length - 1) _divider(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }
}