import 'package:flutter/material.dart';

import '../../domain/entities/RecentActivityEntity.dart';
import '../../../Track/FoodTracking/presentation/screens/food_tracking_screen.dart';
import '../../../Track/ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
import '../../../Track/WaterTracking/presentation/screens/purchase_history_screen.dart';
import '../../../Track/WaterTracking/presentation/screens/water_intake_history_screen.dart';
import '../../../Expense/presentation/screens/expense_screen.dart';
import '../../../Expense/presentation/screens/expense_detail_screen.dart';

class RecentActivityNavigationHandler {
  const RecentActivityNavigationHandler();

  Future<void> navigate(
    BuildContext context,
    RecentActivityEntity activity,
  ) async {
    debugPrint(
      '[RecentActivityNav] clicked type=${activity.type} referenceId=${activity.referenceId}',
    );

    final route = _resolveRoute(activity);
    if (route == null) {
      debugPrint('[RecentActivityNav] unknown type=${activity.type}');
      _showFallback(context, activity.type);
      return;
    }

    debugPrint('[RecentActivityNav] navigating to $route');
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => route()),
      );
      debugPrint('[RecentActivityNav] navigation complete type=${activity.type}');
    } catch (e) {
      debugPrint('[RecentActivityNav] navigation failed type=${activity.type} error=$e');
      _showFallback(context, activity.type);
    }
  }

  Widget Function()? _resolveRoute(RecentActivityEntity activity) {
    switch (activity.type) {
      case 'food':
        return () => const FoodTrackingScreen();
      case 'electricity':
        return () => const ElectricityTrackingScreen();
      case 'water_management':
        return () => const WaterPurchaseHistoryScreen();
      case 'water_intake':
        return () => const WaterIntakeHistoryScreen();
      case 'expense_cycle':
        if (activity.referenceId.isEmpty) {
          return null;
        }
        return () => ExpenseDetailScreen(cardId: activity.referenceId);
      case 'expense_item':
        return () => const ExpenseScreen();
      default:
        return null;
    }
  }

  void _showFallback(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No screen registered for "$type" activity'),
      ),
    );
  }
}
