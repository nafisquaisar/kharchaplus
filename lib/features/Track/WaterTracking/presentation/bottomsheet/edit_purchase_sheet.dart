import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/water_purchase_entity.dart';
import '../providers/purchase/purchase_provider.dart';

class EditPurchaseSheet extends ConsumerStatefulWidget {
  final WaterPurchaseEntity purchase;

  const EditPurchaseSheet({
    super.key,
    required this.purchase,
  });

  @override
  ConsumerState<EditPurchaseSheet> createState() => _EditPurchaseSheetState();
}

class _EditPurchaseSheetState extends ConsumerState<EditPurchaseSheet> {
  late final TextEditingController quantityController;
  late final TextEditingController priceController;
  late final TextEditingController vendorController;
  late String type;

  @override
  void initState() {
    super.initState();
    type = widget.purchase.type;
    quantityController = TextEditingController(
      text: widget.purchase.quantity.toString(),
    );
    priceController = TextEditingController(
      text: widget.purchase.price.toStringAsFixed(0),
    );
    vendorController = TextEditingController(
      text: widget.purchase.vendor ?? '',
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    vendorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Edit Purchase',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: type,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Tanker',
                  child: Text('Tanker'),
                ),
                DropdownMenuItem(
                  value: '20L Can',
                  child: Text('20L Can'),
                ),
                DropdownMenuItem(
                  value: 'Bisleri',
                  child: Text('Bisleri'),
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
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Quantity',
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Price',
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: vendorController,
              decoration: InputDecoration(
                hintText: 'Vendor (optional)',
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () async {
                  final quantity = int.tryParse(quantityController.text);
                  final price = double.tryParse(priceController.text);

                  if (quantity == null || price == null) {
                    return;
                  }

                  final updated = WaterPurchaseEntity(
                    id: widget.purchase.id,
                    type: type,
                    quantity: quantity,
                    price: price,
                    vendor: vendorController.text.trim().isEmpty
                        ? null
                        : vendorController.text.trim(),
                    date: widget.purchase.date,
                    isSynced: false,
                    isDeleted: false,
                    isEdited: true,
                    isActive: widget.purchase.isActive,
                    isOfflineCreated: widget.purchase.isOfflineCreated,
                    version: widget.purchase.version + 1,
                    createdAt: widget.purchase.createdAt,
                    updatedAt: DateTime.now(),
                    userId: widget.purchase.userId,
                    serverId: widget.purchase.serverId,
                  );

                  final didUpdate = await ref
                      .read(purchaseNotifierProvider.notifier)
                      .updatePurchase(updated);

                  if (!didUpdate) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Failed to update purchase. Please try again.'),
                        ),
                      );
                    }
                    return;
                  }

                  if (context.mounted) {
                    Navigator.pop(context, 'updated');
                  }
                },
                child: const Text(
                  'Update Purchase',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
}
