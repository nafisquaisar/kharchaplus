import 'dart:async';
import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../domain/entities/electricity_entity.dart';
import '../provider/electricity_di.dart';
import '../states/electricity_state.dart';
import '../utils/electricity_ui_event_coordinator.dart';
import '../widgets/ElectricityAppBar.dart';
import '../bottomsheet/electricity_sheet.dart';
import '../widgets/electricity_empty.dart';
import '../widgets/electricity_error_state.dart';
import '../widgets/electricity_loading_state.dart';
import '../widgets/electricity_search_bar.dart';
import '../widgets/swipe/electricity_slidable_card.dart';

final electricitySearchQueryProvider = StateProvider<String>((ref) => '');
final electricityFilterTypeProvider = StateProvider<String>((ref) => 'none');

class ElectricityTrackingScreen extends ConsumerStatefulWidget {
  const ElectricityTrackingScreen({super.key});

  @override
  ConsumerState<ElectricityTrackingScreen> createState() =>
      _ElectricityTrackingScreenState();
}

class _ElectricityTrackingScreenState extends ConsumerState<ElectricityTrackingScreen> {
  final searchController = TextEditingController();
  final ElectricityUiEventCoordinator _uiCoordinator =
      ElectricityUiEventCoordinator();
  bool _isSheetOpen = false;
  bool _isPopping = false;
  NavigatorState? _sheetNavigator;
  ProviderSubscription<ElectricityState>? _listenerSub;
  Timer? _deleteTimer;

  final Set<String> _pendingDeleteIds = {};


  @override
  void initState() {
    super.initState();

    _listenerSub = ref.listenManual<ElectricityState>(
      electricityProvider,
      (previous, next) {
        if (next.actionId == next.consumedActionId) {
          return;
        }
        ref.read(electricityProvider.notifier).consumeAction(next.actionId);

        if (next.actionSuccess) {
          _uiCoordinator.enqueue(
            'success-${next.lastAction}',
            () async {
              if (next.lastAction == ElectricityAction.addSuccess ||
                  next.lastAction == ElectricityAction.updateSuccess ||
                  next.lastAction == ElectricityAction.deleteSuccess) {
                await safeCloseBottomSheet();
              }

              // if (next.actionMessage != null) {
              //   await _runAfterFrame(() {
              //     AppFlushbar.showSuccess(context, next.actionMessage!);
              //   });
              // }
            },
          );
        } else if (next.actionError != null) {
          _uiCoordinator.enqueue(
            'error-${next.lastAction}',
            () async {
              debugPrint('[LISTENER EXECUTED]');
              await _runAfterFrame(() {
                AppFlushbar.showError(context, next.actionError!);
              });
            },
          );
        }
      },
    );
    debugPrint('[LISTENER ATTACHED]');

    debugPrint('[SCREEN INIT] ElectricityTrackingScreen');
    Future.microtask(() async {
      final notifier = ref.read(electricityProvider.notifier);
      debugPrint('[LOAD DATA]');
      await notifier.loadElectricity();
      await notifier.syncPending();
      notifier.startRealtimeListener();
      debugPrint('[REALTIME START]');
    });
  }

  @override
  void dispose() {
    _listenerSub?.close();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _runAfterFrame(VoidCallback action) async {
    if (!mounted) {
      return;
    }

    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      debugPrint('[OVERLAY BLOCKED]');
      final completer = Completer<void>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          completer.complete();
          return;
        }
        action();
        completer.complete();
      });
      await completer.future;
    } else {
      action();
    }

    debugPrint('[OVERLAY COMPLETE]');
  }

  void openSheet({ElectricityEntity? entity}) {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';

    _isSheetOpen = true;
    _isPopping = false;
    _sheetNavigator = Navigator.of(context, rootNavigator: true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => ElectricitySheet(
        entity: entity,
        userId: userId,
        onValidationError: (message) {
          _uiCoordinator.enqueue(
            'validation',
            () async {
              debugPrint('[LISTENER EXECUTED]');
              await _runAfterFrame(() {
                AppFlushbar.showError(context, message);
              });
            },
          );
        },
        onSave: (data) async {
          debugPrint('[SAVE BUTTON CLICKED]');
          debugPrint('[PROVIDER SAVE START]');
          final notifier = ref.read(electricityProvider.notifier);
          if (entity == null) {
            return notifier.addElectricity(data);
          }
          return notifier.updateElectricity(data);
        },

      ),
    ).whenComplete(() {
      _isSheetOpen = false;
      _isPopping = false;
      _sheetNavigator = null;
      debugPrint('[SHEET CLOSED]');
    });
  }

  Future<bool> safeCloseBottomSheet() async {
    debugPrint('[SAFE MODAL CLOSE]');

    if (!mounted) {
      return false;
    }
    if (!_isSheetOpen) {
      return false;
    }
    if (_isPopping) {
      debugPrint('[DUPLICATE POP BLOCKED]');
      return false;
    }

    _isPopping = true;
    final navigator = _sheetNavigator ?? Navigator.of(context, rootNavigator: true);
    if (!navigator.canPop()) {
      _isPopping = false;
      debugPrint('[NAVIGATION LOCK]');
      return false;
    }

    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      debugPrint('[NAVIGATION LOCK]');
      final completer = Completer<bool>();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          _isPopping = false;
          completer.complete(false);
          return;
        }
        final didPop = await navigator.maybePop();
        _isPopping = false;
        debugPrint(didPop ? '[SHEET CLOSED]' : '[DUPLICATE POP BLOCKED]');
        if (didPop) {
          debugPrint('[NAVIGATION COMPLETE]');
        }
        completer.complete(didPop);
      });
      return completer.future;
    }

    final didPop = await navigator.maybePop();
    _isPopping = false;
    debugPrint(didPop ? '[SHEET CLOSED]' : '[DUPLICATE POP BLOCKED]');
    if (didPop) {
      debugPrint('[NAVIGATION COMPLETE]');
    }
    return didPop;
  }

  /// 🔍 SEARCH + FILTER LOGIC
  List<ElectricityEntity> _applyFilter(
    List<ElectricityEntity> source,
    String filterType,
  ) {
    var temp = [...source];

    if (filterType == "high") {
      temp.sort((a, b) => b.total.compareTo(a.total));
    } else if (filterType == "low") {
      temp.sort((a, b) => a.total.compareTo(b.total));
    }

    return temp;
  }

  /// 🎯 FILTER MENU
  void openFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Highest Bill"),
            onTap: () {
              ref.read(electricityFilterTypeProvider.notifier).state = "high";
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Lowest Bill"),
            onTap: () {
              ref.read(electricityFilterTypeProvider.notifier).state = "low";
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Reset"),
            onTap: () {
              ref.read(electricityFilterTypeProvider.notifier).state = "none";
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[REBUILD DETECTED]');

    final state = ref.watch(electricityProvider);
    final searchQuery = ref.watch(electricitySearchQueryProvider).trim();
    final filterType = ref.watch(electricityFilterTypeProvider);

    final baseList = searchQuery.isNotEmpty ? state.searchResults : state.list;
    final filteredList = _applyFilter(baseList, filterType);
    final visibleList = filteredList.where((e) {
      return !_pendingDeleteIds.contains(e.id);
    }).toList();

    final isBusy = state.isLoading || state.isSearching;

    return Scaffold(
      appBar: ElectricityAppBar(
        isSyncing: state.isSyncing,
        onFilterTap: openFilterMenu,
      ),


      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElectricitySearchBar(
              controller: searchController,
              onChanged: (value) {
                ref.read(electricitySearchQueryProvider.notifier).state = value;
                ref.read(electricityProvider.notifier).searchElectricity(value);
              },
              onClear: () {
                searchController.clear();
                ref.read(electricitySearchQueryProvider.notifier).state = '';
                ref.read(electricityProvider.notifier).searchElectricity('');
              },
            ),
          ),

          SizedBox(height: 10,),

          /// 📦 LIST
          Expanded(
            child: isBusy
                ? const ElectricityLoadingState()
                : state.error != null
                ? ElectricityErrorState(
              message: state.error!,
              onRetry: () {
                ref
                    .read(electricityProvider.notifier)
                    .loadElectricity();
              },
            )
                : filteredList.isEmpty
                ? ElectricityEmptyState(
              title: 'No bills found',
              message:
              'Try adjusting your search or add a new bill.',
              onAction: openSheet,
            )
                : ListView.builder(

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              itemCount: visibleList.length,

              itemBuilder: (context, index) {
                final e = visibleList[index];
                return ElectricitySlidableCard(
                  entity: e,
                  onEdit: () {
                    openSheet(entity: e);
                  },
                  onDelete: () {

                    /// HIDE UI
                    setState(() {
                      _pendingDeleteIds.add(e.id);
                    });

                    /// SHOW UNDO
                    AppFlushbar.showUndo(

                      context,

                      message: "Electricity bill deleted",

                      onUndo: () {

                        _deleteTimer?.cancel();

                        setState(() {
                          _pendingDeleteIds.remove(e.id);
                        });
                      },
                    );

                    /// DELETE AFTER 5 SEC
                    _deleteTimer?.cancel();

                    _deleteTimer = Timer(

                      const Duration(seconds: 5),

                          () async {

                        ref
                            .read(
                          electricityProvider.notifier,
                        )
                            .deleteElectricity(
                          e.id,
                        );
                      },
                    );
                  },

                );
              },
            ),
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openSheet(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add ,color: Colors.white, size: 28,),
      ),
    );
  }
}
