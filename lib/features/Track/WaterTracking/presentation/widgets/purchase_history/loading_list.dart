import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class PurchaseHistoryLoadingList extends StatelessWidget {
  const PurchaseHistoryLoadingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(6, (index) => const _LoadingCard()),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.primarybg,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: 140),
                const SizedBox(height: 6),
                _bar(width: 90),
                const SizedBox(height: 6),
                _bar(width: 70),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _bar(width: 60),
        ],
      ),
    );
  }

  Widget _bar({required double width}) {
    return Container(
      height: 10,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

