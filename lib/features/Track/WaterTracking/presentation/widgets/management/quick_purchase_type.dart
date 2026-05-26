import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../../../../core/utils/AppFlushbar.dart';
import '../../bottomsheet/add_purchase_sheet.dart';
import '../../../domain/enum/purchase_type.dart';

class QuickPurchaseType extends StatelessWidget {
  const QuickPurchaseType({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final items = [
      PurchaseType.tanker,
      PurchaseType.can20L,
      PurchaseType.water1L,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
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
          const SizedBox(height: 12),
          SizedBox(
            height: 95,
            child: Row(
              children: [
                ...List.generate(
                  items.length,
                  (index) {
                    final item = items[index];

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index != items.length - 1 ? 8 : 0,
                        ),
                        child: _buildItem(
                          context: context,                          title: item.label,
                          iconPath: item.iconPath,
                          imageSize: _imageSize(item),
                          onTap: () {
                            _openAddPurchaseSheet(
                              context,
                              item,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // ======================
                // OTHER BUTTON
                // ======================

                Expanded(
                  child: _buildOtherButton(
                    context,
                    onTap: () {
                      _openAddPurchaseSheet(
                        context,
                        PurchaseType.other,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String title,
    required String iconPath,
    required double imageSize,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 0,
        ),
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
            SizedBox(
              height: 80,
              width: 80,
              child: OverflowBox(
                maxHeight: 90,
                maxWidth: 90,
                child: Image.asset(
                  iconPath,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  height: 1.2,
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

  Widget _buildOtherButton(BuildContext context, {required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
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
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child:  Icon(
                  Icons.add_circle_outline,
                  size: 26,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
               Text(
                'Other',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddPurchaseSheet(
    BuildContext context,
    PurchaseType? type,
  ) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      enableDrag: true,
      useSafeArea: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.65,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: PurchaseFormSheet(
                  initialType: type,
                ),
              ),
            );
          },
        );
      },
    );

    if (!context.mounted) {
      return;
    }

    if (result == 'added') {
      AppFlushbar.showSuccess(context, 'Purchase saved');
    }
  }

  double _imageSize(PurchaseType type) {
    switch (type) {
      case PurchaseType.tanker:
        return 78.0;
      case PurchaseType.can20L:
        return 60.0;
      case PurchaseType.water1L:
        return 65.0;
      case PurchaseType.other:
        return 60.0;
    }
  }

}
