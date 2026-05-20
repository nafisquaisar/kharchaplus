import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../../../../core/utils/AppFlushbar.dart';
import '../../../../../core/Common/CommonAppBar.dart';
import '../../domain/entities/water_purchase_entity.dart';
import '../bottomsheet/purchase_history_filter_sheet.dart';
import '../bottomsheet/add_purchase_sheet.dart';
import '../providers/purchase/purchase_provider.dart';
import '../providers/purchase_history/purchase_history_provider.dart';
import '../widgets/purchase_history/analytics_header.dart';
import '../widgets/purchase_history/empty_state.dart';
import '../widgets/purchase_history/loading_list.dart';
import '../widgets/purchase_history/purchase_card.dart';
import '../widgets/purchase_history/search_bar.dart';

class WaterPurchaseHistoryScreen extends ConsumerStatefulWidget {
  const WaterPurchaseHistoryScreen({
    super.key,
  });

  @override
  ConsumerState<WaterPurchaseHistoryScreen> createState() =>
      _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends ConsumerState<WaterPurchaseHistoryScreen> {
  final Map<String, Timer> _deleteTimers = {};
  final Map<String, WaterPurchaseEntity> _pendingDelete = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(purchaseNotifierProvider.notifier).loadPurchases();
    });
  }

  @override
  void dispose() {
    for (final timer in _deleteTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(purchaseHistoryProvider);
    final rawState = ref.watch(purchaseNotifierProvider);
    final years = _extractYears(rawState.purchases);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight,
        ),
        child: CommonAppBar(
          title: "All Purchases",
          isHome: false,
          isDashboard: false,
          showMore: true,
          moreIcon: Icons.tune,
          onMenuTap: () {
            Navigator.pop(context);
          },
          onNotificationTap: () {},
          onMoreTap: () {
            _openFilterSheet(years);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: _openAddSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: Colors.white,
          onRefresh: () {
            return ref.read(purchaseNotifierProvider.notifier).loadPurchases();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom + 20,
            ),
            children: [
              PurchaseHistoryAnalyticsHeader(
                analytics: viewState.analytics,
              ),
              const SizedBox(height: 14),
              const PurchaseHistorySearchBar(),
              const SizedBox(height: 14),
              if (viewState.isLoading)
                const PurchaseHistoryLoadingList()
              else if (viewState.error != null)
                _ErrorState(
                  message: viewState.error!,
                  onRetry: () => ref
                      .read(purchaseNotifierProvider.notifier)
                      .loadPurchases(),
                )
              else if (viewState.purchases.isEmpty)
                const PurchaseHistoryEmptyState()
              else
                ...viewState.purchases
                    .map(
                  (purchase) => PurchaseHistoryCard(
                    purchase: purchase,
                    onEdit: () => _openEditSheet(purchase),
                    onDelete: () => _deleteWithUndo(purchase),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEditSheet(WaterPurchaseEntity purchase) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PurchaseFormSheet(purchase: purchase),
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == 'updated') {
      AppFlushbar.showSuccess(context, 'Purchase updated');
    }
  }

  void _deleteWithUndo(WaterPurchaseEntity purchase) {
    ref.read(purchaseNotifierProvider.notifier).removePurchaseOptimistic(
          purchase,
        );

    _pendingDelete[purchase.id] = purchase;

    AppFlushbar.showUndo(
      context,
      message: 'Purchase deleted',
      onUndo: () {
        final pending = _pendingDelete.remove(purchase.id);
        _deleteTimers.remove(purchase.id)?.cancel();
        if (pending != null) {
          ref
              .read(purchaseNotifierProvider.notifier)
              .restorePurchaseOptimistic(pending);
        }
      },
    );

    _deleteTimers[purchase.id]?.cancel();
    _deleteTimers[purchase.id] = Timer(const Duration(seconds: 5), () async {
      final pending = _pendingDelete.remove(purchase.id);
      if (pending == null) {
        return;
      }

      await ref.read(purchaseNotifierProvider.notifier).deletePurchase(
            pending.id,
          );

      if (!mounted) {
        return;
      }

      final error = ref.read(purchaseNotifierProvider).error;
      if (error != null) {
        AppFlushbar.showError(context, 'Failed to delete purchase');
      }
    });
  }

  List<int> _extractYears(List<WaterPurchaseEntity> purchases) {
    final years = purchases.map((e) => e.date.year).toSet().toList();
    years.sort();

    if (years.isEmpty) {
      years.add(DateTime.now().year);
    }

    return years.reversed.toList();
  }

  Future<void> _openFilterSheet(List<int> years) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PurchaseHistoryFilterSheet(years: years);
      },
    );
  }

  Future<void> _openAddSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const PurchaseFormSheet(),
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == 'added') {
      AppFlushbar.showSuccess(context, 'Purchase saved');
    }
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 46,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
