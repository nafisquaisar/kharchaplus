import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../domain/entities/water_purchase_entity.dart';

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
    final dateLabel = DateFormat('d MMM yyyy').format(purchase.date);

    return Dismissible(
      key: ValueKey(purchase.id),
      direction: DismissDirection.horizontal,
      background: _swipeBackground(
        color: AppColors.accent,
        icon: Icons.edit,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _swipeBackground(
        color: AppColors.deleteBackground,
        icon: Icons.delete,
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _PurchaseIcon(type: purchase.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.type,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${purchase.quantity} items',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if ((purchase.vendor ?? '').isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      purchase.vendor!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${purchase.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _PurchaseIcon extends StatelessWidget {
  final String type;

  const _PurchaseIcon({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = _iconForType(type);

    return Container(
      height: 46,
      width: 46,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.primarybg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(iconPath, fit: BoxFit.contain),
    );
  }

  String _iconForType(String type) {
    if (type == 'Tanker') {
      return 'assets/icon/premiumicon/kharchaplus_tanker.png';
    }
    if (type == '20L Can') {
      return 'assets/icon/premiumicon/kharchaplus_20l.png';
    }
    return 'assets/icon/premiumicon/kharcha_plus_1l.png';
  }
}

