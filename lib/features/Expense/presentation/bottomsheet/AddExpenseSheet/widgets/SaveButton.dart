import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class SaveButton extends StatelessWidget {

  final VoidCallback onPressed;

  final bool isLoading;

  final String text;

  const SaveButton({
    super.key,

    required this.onPressed,

    this.isLoading = false,

    this.text = "Save Expense",
  });

  @override
  Widget build(BuildContext context) {

    final isUpdate =
        text == "Update Expense";

    return Container(

      height: 56,

      decoration: BoxDecoration(

        gradient:
        AppColors.buttonGradient,

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        boxShadow: [

          BoxShadow(

            color: AppColors
                .primary
                .withOpacity(0.25),

            blurRadius: 14,

            offset:
            const Offset(
              0,
              6,
            ),
          ),
        ],
      ),

      child: Material(

        color: Colors.transparent,

        child: InkWell(

          borderRadius:
          BorderRadius.circular(
            16,
          ),

          onTap:
          isLoading
              ? null
              : onPressed,

          child: Padding(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
            ),

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .center,

              children: [

                if (isLoading) ...[

                  const SizedBox(

                    height: 18,
                    width: 18,

                    child:
                    CircularProgressIndicator(

                      strokeWidth: 2.2,

                      color:
                      Colors.white,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                ] else ...[

                  Container(

                    height: 30,
                    width: 30,

                    decoration:
                    BoxDecoration(

                      color: Colors.white
                          .withOpacity(
                        0.18,
                      ),

                      borderRadius:
                      BorderRadius
                          .circular(
                        10,
                      ),
                    ),

                    child: Icon(

                      isUpdate
                          ? Icons
                          .edit_rounded
                          : Icons
                          .check_rounded,

                      color:
                      Colors.white,

                      size: 18,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),
                ],

                Text(

                  isLoading
                      ? isUpdate
                      ? "Updating..."
                      : "Saving..."
                      : text,

                  style:
                  const TextStyle(

                    color: Colors.white,

                    fontSize: 15,

                    fontWeight:
                    FontWeight.w700,

                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}