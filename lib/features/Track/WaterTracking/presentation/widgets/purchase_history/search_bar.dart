import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _controller = TextEditingController(
      text: ref.read(
        purchaseHistorySearchProvider,
      ),
    );

    _controller.addListener(_onChange);
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onChange,
    );

    _controller.dispose();

    _focusNode.dispose();

    super.dispose();
  }

  void _onChange() {
    ref
        .read(
          purchaseHistorySearchProvider.notifier,
        )
        .state = _controller.text;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(
      purchaseHistorySearchProvider,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_controller.text != search) {
      _controller.text = search;

      _controller.selection = TextSelection.fromPosition(
        TextPosition(
          offset: search.length,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focusNode.hasFocus
                ? AppColors.primary
                : colorScheme.outlineVariant,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.accent,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Search by type or vendor',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 46,
              minHeight: 46,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();

                      _controller.clear();

                      FocusScope.of(
                        context,
                      ).unfocus();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
          ),
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
