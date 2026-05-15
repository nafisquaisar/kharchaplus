import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../bottomsheet/add_purchase_sheet.dart';

class QuickPurchaseType extends StatelessWidget {
  const QuickPurchaseType({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Tanker',
        'icon': 'assets/icon/premiumicon/kharchaplus_tanker.png',
        'size': 78.0,
      },
      {
        'title': '20L Can',
        'icon': 'assets/icon/premiumicon/kharchaplus_20l.png',
        'size': 60.0,
      },
      {
        'title': 'Bisleri',
        'icon': 'assets/icon/premiumicon/kharcha_plus_1l.png',
        'size': 65.0,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Add',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 95,
            child: Row(
              children: [
                ...List.generate(
                  items.length,
                      (index) {
                    final item = items[index];

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index !=
                              items.length - 1
                              ? 8
                              : 0,
                        ),

                        child: _buildItem(
                          title:
                          item['title']
                          as String,

                          iconPath:
                          item['icon']
                          as String,

                          imageSize:
                          item['size']
                          as double,

                          onTap: () {
                            _openAddPurchaseSheet(
                              context,
                              item['title'] as String,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                // ======================
                // OTHER BUTTON
                // ======================

                Expanded(
                  child: _buildOtherButton(
                    onTap: () {
                      _openAddPurchaseSheet(
                        context,
                        null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String iconPath,
    required double imageSize,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 0,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(10),

          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            SizedBox(
              height: 80,
              width: 80,

              child: OverflowBox(
                maxHeight: 90,
                maxWidth: 90,

                child: Image.asset(
                  iconPath,

                  height: 50,
                  width: 50,

                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 1),

            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherButton({
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(10),
        onTap: onTap,

        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(10),

            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: AppColors.primarybg,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.add_circle_outline,
                  size: 26,
                  color: AppColors.colorText,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Other',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddPurchaseSheet(
      BuildContext context,
      String? type,
      ) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddPurchaseSheet(
            initialType: type,
          ),
        );
      },
    );
  }
}

