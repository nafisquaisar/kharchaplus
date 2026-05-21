import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../providers/intake/intake_provider.dart';

class QuickAddCard extends ConsumerWidget {
  const QuickAddCard({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Quick Add',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildQuickButton(
                  iconPath: 'assets/icon/waterbottle250ml.svg',
                  label: '250ml',
                  onTap: () {
                    ref
                        .read(
                          intakeNotifierProvider.notifier,
                        )
                        .addIntake(
                          250,
                          sourceType: 'Quick Add',
                        );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickButton(
                  iconPath: 'assets/icon/waterbottle1.svg',
                  label: '500ml',
                  onTap: () {
                    ref
                        .read(
                          intakeNotifierProvider.notifier,
                        )
                        .addIntake(
                          500,
                          sourceType: 'Quick Add',
                        );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickButton(
                  iconPath: 'assets/icon/waterbottle2.svg',
                  label: '1L',
                  onTap: () {
                    ref
                        .read(
                          intakeNotifierProvider.notifier,
                        )
                        .addIntake(
                          1000,
                          sourceType: 'Quick Add',
                        );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    // custom add
                  },
                  child: Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: AppColors.primarybg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: AppColors.colorText,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 18,
              width: 18,
              colorFilter:  ColorFilter.mode(
                AppColors.colorText,
                BlendMode.srcIn,
              ),
            ),
             SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style:  TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
