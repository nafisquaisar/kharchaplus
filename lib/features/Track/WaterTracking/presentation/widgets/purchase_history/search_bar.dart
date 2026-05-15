import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../providers/purchase_history/purchase_history_filter_provider.dart';

class PurchaseHistorySearchBar extends ConsumerStatefulWidget {
  const PurchaseHistorySearchBar({
    super.key,
  });

  @override
  ConsumerState<PurchaseHistorySearchBar> createState() =>
      _PurchaseHistorySearchBarState();
}

class _PurchaseHistorySearchBarState
    extends ConsumerState<PurchaseHistorySearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(purchaseHistorySearchProvider),
    );
    _controller.addListener(_onChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    _controller.dispose();
    super.dispose();
  }

  void _onChange() {
    ref.read(purchaseHistorySearchProvider.notifier).state =
        _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(purchaseHistorySearchProvider);

    if (_controller.text != search) {
      _controller.text = search;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: search.length),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Search by type or vendor',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        cursorColor: AppColors.accent,
      ),
    );
  }
}


