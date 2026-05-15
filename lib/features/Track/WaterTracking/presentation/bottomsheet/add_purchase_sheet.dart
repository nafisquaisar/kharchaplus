import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../../core/constants/AppColors.dart';
import '../providers/purchase/purchase_provider.dart';

class AddPurchaseSheet
    extends ConsumerStatefulWidget {

  const AddPurchaseSheet({
    super.key,
    this.initialType,
  });

  final String? initialType;

  @override
  ConsumerState<AddPurchaseSheet>
  createState() =>
      _AddPurchaseSheetState();
}

class _AddPurchaseSheetState
    extends ConsumerState<
        AddPurchaseSheet> {

  final quantityController =
  TextEditingController();

  final priceController =
  TextEditingController();

  String type = '20L Can';

  @override
  void initState() {
    super.initState();

    if (widget.initialType != null) {
      type = widget.initialType!;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.all(24),

      decoration: const BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      child: SingleChildScrollView(

        child: Column(

          mainAxisSize:
          MainAxisSize.min,

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Center(

              child: Container(

                height: 5,
                width: 60,

                decoration:
                BoxDecoration(

                  color: Colors.grey[300],

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(

              'Add Purchase',

              style: TextStyle(

                fontSize: 22,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(

              value: type,

              decoration: InputDecoration(

                filled: true,

                fillColor:
                AppColors.primarybg,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: 'Tanker',
                  child: Text(
                    'Tanker',
                  ),
                ),

                DropdownMenuItem(
                  value: '20L Can',
                  child: Text(
                    '20L Can',
                  ),
                ),

                DropdownMenuItem(
                  value: 'Bisleri',
                  child: Text(
                    'Bisleri',
                  ),
                ),
              ],

              onChanged: (value) {

                if (value != null) {

                  setState(() {

                    type = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            TextField(

              controller:
              quantityController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                hintText: 'Quantity',

                filled: true,

                fillColor:
                AppColors.primarybg,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(

              controller:
              priceController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                hintText: 'Price',

                filled: true,

                fillColor:
                AppColors.primarybg,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(

              width: double.infinity,

              height: 56,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.accent,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed: () async {

                  final quantity =
                  int.tryParse(
                    quantityController
                        .text,
                  );

                  final price =
                  double.tryParse(
                    priceController
                        .text,
                  );

                  if (quantity == null ||
                      price == null) {
                    return;
                  }

                  await ref
                      .read(
                    purchaseNotifierProvider
                        .notifier,
                  )
                      .addPurchase(

                    type: type,

                    quantity:
                    quantity,

                    price: price,
                  );

                  if (context.mounted) {

                    Navigator.pop(
                      context,
                    );
                  }
                },

                child: const Text(

                  'Add Purchase',

                  style: TextStyle(

                    color: Colors.white,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}