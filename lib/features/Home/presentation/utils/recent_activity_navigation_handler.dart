import 'package:expense_tracker/features/Expense/presentation/screens/expense_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/RecentActivityEntity.dart';
import '../../../Track/FoodTracking/presentation/screens/food_tracking_screen.dart';
import '../../../Track/ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
import '../../../Track/WaterTracking/presentation/screens/purchase_history_screen.dart';
import '../../../Track/WaterTracking/presentation/screens/water_intake_history_screen.dart';
import '../../../Expense/presentation/screens/expense_detail_screen.dart';

class RecentActivityNavigationHandler {
  const RecentActivityNavigationHandler();

  Future<void> navigate(
    BuildContext context,
    RecentActivityEntity activity,
  ) async {
    debugPrint(
      '[RecentActivityNav] clicked type=${activity.type} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId}',
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
    Widget Function()? route;

    if (activity.type == 'food') {
      route = () => const FoodTrackingScreen();
    }
    else if (activity.type == 'electricity') {
      route = () => const ElectricityTrackingScreen();
    }
    else if (activity.type == 'water_management') {
      route = () => const WaterPurchaseHistoryScreen();
    }
    else if (activity.type == 'water_intake') {
      route = () => const WaterIntakeHistoryScreen();
    }

    else if (activity.type == 'expense_cycle') {
      route = () => const ExpenseScreen();
    }
    else if (activity.type == 'expense_item') {

      final cardId = activity.parentCardId;

      if (cardId == null || cardId.isEmpty) {

        debugPrint(
          '[RecentActivityNav] expense_item legacy record -> opening ExpenseScreen',
        );

        return () => const ExpenseScreen();
      }

      debugPrint(
        '[RecentActivityNav] expense_item -> cardId=$cardId',
      );

      return () => ExpenseDetailScreen(
        cardId: cardId,
      );
    }

    return route;
  }

  void _showFallback(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No screen registered for "$type" activity'),
      ),
    );
  }
}
