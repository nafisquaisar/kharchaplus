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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
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
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
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
                  context: context,
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
                  context: context,
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
                  context: context,
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
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
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

  Widget _buildQuickButton({required String iconPath,required String label,
    required VoidCallback onTap,
    required BuildContext context,

  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme.outlineVariant,
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
                colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
             SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
