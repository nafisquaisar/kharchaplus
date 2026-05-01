import 'package:flutter/material.dart';
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

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _mealCheck({
    required String label,
    required Color color,
    required bool enabled,
    required bool value,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          activeColor: color,
          checkColor: Colors.white,
          side: BorderSide(color: color),
          onChanged: enabled ? (_) => onTap() : null,
        ),
        Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = getKey(date);
    final day = mealState(data, key);

    final isSunday = date.weekday == 7;
    final lunchEnabled = !(isSunday && sundayRule == 'Off');
    final dinnerEnabled = !(isSunday && sundayRule != '2 Meals');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _legend(Colors.green, 'Lunch')),
              Expanded(child: _legend(Colors.orange, 'Dinner')),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: _mealCheck(
                  label: 'Lunch',
                  color: Colors.green,
                  enabled: lunchEnabled,
                  value: (day['lunch'] ?? false) && lunchEnabled,
                  onTap: () => onToggle(key, 'lunch'),
                ),
              ),
              Expanded(
                child: _mealCheck(
                  label: 'Dinner',
                  color: Colors.orange,
                  enabled: dinnerEnabled,
                  value: (day['dinner'] ?? false) && dinnerEnabled,
                  onTap: () => onToggle(key, 'dinner'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}