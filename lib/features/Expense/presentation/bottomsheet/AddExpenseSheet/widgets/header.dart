import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class Header extends StatelessWidget {

  final String title;

  final String subtitle;

  const Header({
    super.key,

    this.title = "Add Expense",

    this.subtitle =
    "Track your spending smartly",
  });

  @override
  Widget build(BuildContext context) {

    final isUpdate =
        title == "Update Expense";

    return Column(

      children: [

        /// 🔘 Handle
        Center(

          child: Container(

            width: 42,
            height: 5,

            margin:
            const EdgeInsets.only(
              bottom: 18,
            ),

            decoration: BoxDecoration(

              color:
              Colors.grey.shade300,

              borderRadius:
              BorderRadius.circular(
                30,
              ),
            ),
          ),
        ),

        /// 🔥 Header Card
        Container(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(
              10,
            ),

            boxShadow: [

              BoxShadow(

                color: AppColors
                    .accent
                    .withOpacity(0.12),

                blurRadius: 10,

                offset:
                const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: Row(

            children: [

              /// Left Icon
              Container(

                height: 42,
                width: 42,

                decoration:
                BoxDecoration(

                  color: isUpdate
                      ? Colors.blue
                      .withOpacity(
                    0.12,
                  )
                      : const Color(
                    0xFFE7FAF8,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                child: Icon(

                  isUpdate
                      ? Icons.edit_rounded
                      : Icons
                      .add_card_rounded,

                  color: isUpdate
                      ? Colors.blue
                      : const Color(
                    0xFF00B8A9,
                  ),

                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              /// Title + Subtitle
              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(

                      title,

                      style:
                      const TextStyle(

                        fontSize: 16,

                        fontWeight:
                        FontWeight
                            .w700,

                        color:
                        Colors.black,
                      ),
                    ),

                    const SizedBox(
                      height: 1,
                    ),

                    Text(

                      subtitle,

                      style:
                      const TextStyle(

                        fontSize: 12,

                        color:
                        Colors.grey,

                        fontWeight:
                        FontWeight
                            .w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// Close Button
              Container(

                height: 30,
                width: 30,

                decoration:
                BoxDecoration(

                  color: Colors.red
                      .withOpacity(
                    0.08,
                  ),

                  shape:
                  BoxShape.circle,
                ),

                child: IconButton(

                  padding:
                  EdgeInsets.zero,

                  onPressed: () {

                    Navigator.pop(
                      context,
                    );
                  },

                  icon: const Icon(

                    Icons.close_rounded,

                    color: Colors.red,

                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}