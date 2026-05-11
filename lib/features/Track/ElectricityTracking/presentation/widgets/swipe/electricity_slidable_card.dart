import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:expense_tracker/features/Track/ElectricityTracking/domain/entities/electricity_entity.dart';
import 'package:expense_tracker/features/Track/ElectricityTracking/presentation/widgets/electricity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElectricitySlidableCard extends StatelessWidget {

  final ElectricityEntity entity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const ElectricitySlidableCard({
    super.key,
    required this.entity,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Dismissible(
        key: ValueKey(entity.id),
        background: swipeBackground(
          color: AppColors.accent,
          icon: Icons.edit_rounded,
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: swipeBackground(
          color: AppColors.deleteBackground,
          icon: Icons.delete_rounded,
          alignment: Alignment.centerRight,
        ),

        confirmDismiss: (direction) async {

          /// EDIT
          if (direction == DismissDirection.startToEnd) {

            HapticFeedback.lightImpact();

            onEdit();

            return false;
          }

          /// DELETE
          HapticFeedback.mediumImpact();

          final confirmed = await showDialog<bool>(

            context: context,

            builder: (_) {

              return AlertDialog(

                title: const Text(
                  "Delete Bill",
                ),

                content: const Text(
                  "Are you sure you want to delete this bill?",
                ),

                actions: [

                  TextButton(

                    onPressed: () {
                      Navigator.pop(context, false);
                    },

                    child: const Text(
                      "Cancel",
                    ),
                  ),

                  TextButton(

                    onPressed: () {
                      Navigator.pop(context, true);
                    },

                    child: const Text(
                      "Delete",
                    ),
                  ),
                ],
              );
            },
          );

          return confirmed ?? false;
        },


        onDismissed: (_) {

          onDelete();
        },

        child: ElectricityCard(
          entity: entity,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }

  /// =====================================================
  /// SWIPE BACKGROUND
  /// =====================================================

  Widget swipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      alignment: alignment,

      decoration: BoxDecoration(

        color: color.withOpacity(0.15),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}