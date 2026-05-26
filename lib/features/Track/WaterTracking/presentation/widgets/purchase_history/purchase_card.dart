import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../domain/entities/water_purchase_entity.dart';
import '../../../domain/enum/payment_status.dart';
import '../../../domain/enum/purchase_type.dart';

class PurchaseHistoryCard extends StatelessWidget {
  final WaterPurchaseEntity purchase;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PurchaseHistoryCard({
    super.key,
    required this.purchase,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat(
      'dd MMM yyyy',
    ).format(
      purchase.date,
    );

    final statusColor = _statusColor(
      purchase.paymentStatus,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(
        purchase.id,
      ),
      direction: DismissDirection.horizontal,
      background: _swipeBackground(
        color: AppColors.accent,
        icon: Icons.edit_rounded,
        title: 'Edit',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _swipeBackground(
        color: Colors.red,
        icon: Icons.delete_rounded,
        title: 'Delete',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        }

        onDelete();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(
                0.08,
              ),
              blurRadius: 18,
              offset: const Offset(
                0,
                8,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            10,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                /// IMAGE
                SizedBox(
                  width: 72,

                  child: Center(

                    child: Container(

                      decoration: BoxDecoration(

                        color:
                        colorScheme.surfaceContainerHighest,

                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: ClipRRect(

                        borderRadius:
                        BorderRadius.circular(14),

                        child: Image.asset(

                          purchase.type.iconPath,

                          height:
                          _imageHeight(
                            purchase.type,
                          ),

                          width: 60,

                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),



                const SizedBox(
                  width: 12,
                ),

                /// CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TOP ROW
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              purchase.displayTypeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accent,
                              ),
                            ),
                          ),

                          /// STATUS
                          Container(
                            height: 22,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(
                                0.10,
                              ),
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  purchase.paymentStatus.label,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      /// DETAILS + PRICE
                      Expanded(
                        child: Row(
                          children: [
                            /// LEFT INFO
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _smallInfoRow(
                                    context,
                                    icon: Icons.inventory_2_outlined,
                                    iconColor: AppColors.primary,
                                    bgColor: AppColors.primarybg,
                                    text: '${purchase.quantity} Qty',
                                  ),
                                  _smallInfoRow(
                                    context,
                                    icon: Icons.person_outline_rounded,
                                    iconColor: Colors.green,
                                    bgColor: const Color(
                                      0xffEDF9F0,
                                    ),
                                    text: purchase.vendor ?? 'No Vendor',
                                  ),
                                  _smallInfoRow(
                                    context,
                                    icon: Icons.calendar_month_rounded,
                                    iconColor: Colors.deepPurple,
                                    bgColor: const Color(
                                      0xffF3EEFF,
                                    ),
                                    text: dateLabel,
                                  ),
                                ],
                              ),
                            ),

                            /// DIVIDER
                            Container(
                              width: 1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              color: colorScheme.outlineVariant,
                            ),

                            /// PRICE
                            Center(
                              child: ShaderMask(
                                shaderCallback: (
                                  bounds,
                                ) {
                                  return AppColors.kharchaGradient.createShader(
                                    bounds,
                                  );
                                },
                                child: Text(
                                  '₹${purchase.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required String title,
    required Alignment alignment,
  }) {
    final isLeft = alignment == Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(
          0.12,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isLeft)
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (!isLeft)
            const SizedBox(
              width: 8,
            ),
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          if (isLeft)
            const SizedBox(
              width: 8,
            ),
          if (isLeft)
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  Widget _smallInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 11,
            color: iconColor,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(
    PaymentStatus status,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;

      case PaymentStatus.unpaid:
        return Colors.orange;

      case PaymentStatus.partial:
        return AppColors.accent;
    }
  }

  double _imageHeight(PurchaseType type) {
    switch (type) {
      case PurchaseType.water1L:
      case PurchaseType.can20L:
        return 80;
      case PurchaseType.tanker:
        return 68;
      case PurchaseType.other:
        return 72;
    }
  }
}
