import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class GradientButton
    extends StatelessWidget {

  final String text;

  final VoidCallback? onTap;

  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return Opacity(

      opacity:
      onTap == null ? 0.7 : 1,

      child: Container(

        width: double.infinity,

        height: 54,

        decoration: BoxDecoration(

          gradient:
          AppColors.buttonGradient,

          borderRadius:
          BorderRadius.circular(16),

          boxShadow: [

            BoxShadow(

              color:
              AppColors.primary
                  .withOpacity(0.25),

              blurRadius: 10,

              offset: const Offset(
                0,
                4,
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

            onTap: onTap,

            child: Center(

              child:

              isLoading

                  ? const SizedBox(

                height: 22,

                width: 22,

                child:
                CircularProgressIndicator(

                  strokeWidth: 2.4,

                  valueColor:
                  AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              )

                  : Text(

                text,

                style:
                const TextStyle(

                  fontSize: 16,

                  fontWeight:
                  FontWeight.w700,

                  color:
                  Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}