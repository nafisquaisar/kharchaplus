import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../Expense/data/model/ExpenseCardModel.dart';
import '../../../Expense/presentation/viewmodel/ExpenseCardViewModel.dart';

class HomeHeader extends StatefulWidget {

  final ExpenseCardModel? selectedCard;

  final Function(ExpenseCardModel?) onCardSelected;

  const HomeHeader({
    super.key,
    required this.selectedCard,
    required this.onCardSelected,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    final cardVm =
    context.watch<ExpenseCardViewModel>();

    /// ONLY LATEST 8
    final latestCards =
    cardVm.cards.take(8).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.045,
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          /// TITLE
          Text(
            "Overview",

            style: TextStyle(
              fontSize: width * 0.052,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),

          /// DROPDOWN
          Container(
            height: 38,

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),

            decoration: BoxDecoration(
              color: AppColors.card,

              borderRadius:
              BorderRadius.circular(12),

              border: Border.all(
                color: AppColors.border,
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.accent
                      .withOpacity(.05),

                  blurRadius: 10,

                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: DropdownButtonHideUnderline(
              child:
              DropdownButton<ExpenseCardModel>(

                value: latestCards.any(
                      (e) => e.id == widget.selectedCard?.id,
                )
                    ? latestCards.firstWhere(
                      (e) => e.id == widget.selectedCard?.id,
                )
                    : null,

                borderRadius:
                BorderRadius.circular(14),

                dropdownColor:
                AppColors.card,

                icon: Icon(
                  Icons
                      .keyboard_arrow_down_rounded,

                  color: AppColors.accent,
                ),

                hint: Text(
                  "Select Card",

                  style: TextStyle(
                    color:
                    AppColors.textSecondary,

                    fontSize: width * 0.032,
                  ),
                ),

                items: latestCards.map((card) {

                  return DropdownMenuItem(
                    value: card,

                    child: SizedBox(
                      width: width * 0.30,

                      child: Text(
                        card.title,

                        overflow:
                        TextOverflow.ellipsis,

                        style: TextStyle(
                          color: AppColors.accent,

                          fontWeight:
                          FontWeight.w600,

                          fontSize:
                          width * 0.033,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                onChanged: widget.onCardSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}