import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

import 'meal_date_key.dart';

class MealSelector extends StatelessWidget {
  final DateTime date;

  final Map<String, Map<String, bool>> data;

  final void Function(String, String) onToggle;

  final String sundayRule;

  const MealSelector({
    super.key,

    required this.date,

    required this.data,

    required this.onToggle,

    required this.sundayRule,
  });

  @override
  Widget build(BuildContext context) {
    final key = getKey(date);

    final day = mealState(data, key);

    final isSunday = date.weekday == 7;

    final lunchEnabled = !(isSunday && sundayRule == 'Off');

    final dinnerEnabled = true;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // =========================
          // DATE
          // =========================
          Row(
            children: [
              Container(
                width: 8,

                height: 8,

                decoration: BoxDecoration(
                  color: AppColors.primary,

                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  key,

                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 13,

                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              if (isSunday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child:  Text(
                    "Sunday",

                    style: TextStyle(
                      fontSize: 10,

                      color: AppColors.primary,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // MEAL BUTTONS
          // =========================
          Row(

            children: [

              Expanded(

                child: _compactMealButton(

                  title: "Lunch",

                  shortTitle: "L",

                  icon: Icons.lunch_dining,

                  color: Colors.green,

                  enabled: lunchEnabled,

                  selected:
                  (day['lunch'] ?? false) &&
                      lunchEnabled,

                  onTap: () {

                    onToggle(
                      key,
                      'lunch',
                    );
                  },
                    context: context

                ),
              ),

              const SizedBox(width: 8),

              Expanded(

                child: _compactMealButton(

                  title: "Dinner",

                  shortTitle: "D",

                  icon: Icons.dinner_dining,

                  color: Colors.orange,

                  enabled: dinnerEnabled,

                  selected:
                  (day['dinner'] ?? false) &&
                      dinnerEnabled,

                  onTap: () {

                    onToggle(
                      key,
                      'dinner',
                    );
                  },
                    context: context


                ),
              ),

              if (isSunday) ...[

                const SizedBox(width: 8),

                Expanded(

                  child: _compactMealButton(

                    title: "S Thali",

                    shortTitle: "S",

                    icon:
                    Icons.local_fire_department,

                    color: Colors.purple,

                    enabled: true,

                    selected:
                    day['special'] ?? false,

                    onTap: () {

                      onToggle(
                        key,
                        'special',
                      );
                    },
                    context: context
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }


  Widget _compactMealButton({

    required String title,

    required String shortTitle,

    required IconData icon,

    required Color color,

    required bool enabled,

    required bool selected,

    required VoidCallback onTap,

    required BuildContext context

  }) {


    return InkWell(

      onTap:
      enabled ? onTap : null,

      borderRadius:
      BorderRadius.circular(14),

      child: AnimatedContainer(

        duration:
        const Duration(
          milliseconds: 180,
        ),

        height: 52,

        decoration: BoxDecoration(

          gradient: selected

              ? LinearGradient(

            colors: [
              color.withOpacity(0.18),
              color.withOpacity(0.08),
            ],
          )

              : null,

          color:
          selected
              ? null
              : Theme.of(context).colorScheme.surfaceContainerHighest,

          borderRadius:
          BorderRadius.circular(14),

          border: Border.all(

            color: selected
                ? color
                : Theme.of(context).colorScheme.outlineVariant,

            width: 1.2,
          ),
        ),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Icon(

                  icon,

                  size: 14,

                  color: enabled
                      ? color
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),

                const SizedBox(width: 4),

                Flexible(

                  child: Text(

                    title,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(

                      fontSize: 10.5,

                      fontWeight:
                      FontWeight.w700,

                      color:

                      enabled
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 180,
              ),

              width: 16,

              height: 16,

              decoration: BoxDecoration(

                color:
                selected
                    ? color
                    : Colors.transparent,

                shape: BoxShape.circle,

                border: Border.all(
                  color: color,
                  width: 1.4,
                ),
              ),

              child: selected

                  ? const Icon(

                Icons.check,

                size: 10,

                color: Colors.white,
              )

                  : null,
            ),
          ],
        ),
      ),
    );
  }

}
