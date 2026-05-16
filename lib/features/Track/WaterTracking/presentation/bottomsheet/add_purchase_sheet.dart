import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../domain/entities/water_purchase_entity.dart';
import '../../domain/enum/payment_status.dart';
import '../../domain/enum/purchase_type.dart';
import '../providers/purchase/purchase_provider.dart';

class PurchaseFormSheet extends ConsumerStatefulWidget {
  final WaterPurchaseEntity? purchase;
  final PurchaseType? initialType;

  const PurchaseFormSheet({
    super.key,
    this.purchase,
    this.initialType,
  });

  bool get isEdit => purchase != null;

  @override
  ConsumerState<PurchaseFormSheet> createState() => _PurchaseFormSheetState();

}

class _PurchaseFormSheetState extends ConsumerState<PurchaseFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController quantityController;
  late final TextEditingController priceController;
  late final TextEditingController vendorController;
  late final TextEditingController customTypeController;

  late PurchaseType selectedType;
  late PaymentStatus selectedPaymentStatus;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    final purchase = widget.purchase;

    quantityController = TextEditingController(
      text: purchase?.quantity.toString() ?? '',
    );

    priceController = TextEditingController(
      text: purchase != null ? purchase.price.toStringAsFixed(0) : '',
    );

    vendorController = TextEditingController(
      text: purchase?.vendor ?? '',
    );

    customTypeController = TextEditingController(
      text: purchase?.customTypeName ?? '',
    );

    selectedType =
        purchase?.type ?? widget.initialType ?? PurchaseType.can20L;

    selectedPaymentStatus = purchase?.paymentStatus ?? PaymentStatus.unpaid;
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    vendorController.dispose();
    customTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: SafeArea(
          top: false,
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.95,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.isEdit
                                    ? 'Update Purchase'
                                    : 'Add Purchase',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.cancel,
                                    size: 22,
                                    color:
                                        Colors.red.withOpacity(0.6)),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isEdit
                                ? 'Update purchase details and payment status'
                                : 'Track purchase, price and payment status',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _SectionLabel(
                            title: 'Purchase Type',
                            icon: Icons.local_shipping_rounded,
                          ),
                          const SizedBox(height: 8),
                          _TypeSelectorCard(
                            option: selectedType,
                            enabled: !isSaving,
                            onTap: _openTypeSelector,
                          ),
                          if (selectedType == PurchaseType.other) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: customTypeController,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hintText: 'Enter bottle name',
                                icon: Icons.edit_rounded,
                              ),
                              validator: (value) {
                                if (selectedType != PurchaseType.other) {
                                  return null;
                                }

                                final text = value?.trim() ?? '';

                                if (text.isEmpty) {
                                  return 'Bottle name is required';
                                }

                                if (text.length < 2) {
                                  return 'Bottle name must be at least 2 characters';
                                }

                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          _SectionLabel(
                            title: 'Payment Status',
                            icon: Icons.account_balance_wallet_rounded,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: PaymentStatus.values
                                .map(
                                  (status) => _PaymentStatusCard(
                                    status: status,
                                    selected: selectedPaymentStatus == status,
                                    onTap: isSaving
                                        ? null
                                        : () {
                                            HapticFeedback.selectionClick();

                                            setState(() {
                                              selectedPaymentStatus = status;
                                            });
                                          },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hintText: 'Quantity',
                              icon: Icons.numbers_rounded,
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (text.isEmpty) {
                                return 'Quantity is required';
                              }

                              final quantity = int.tryParse(text);

                              if (quantity == null) {
                                return 'Enter a valid quantity';
                              }

                              if (quantity <= 0) {
                                return 'Quantity must be greater than 0';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hintText: 'Price',
                              icon: Icons.currency_rupee_rounded,
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (text.isEmpty) {
                                return 'Price is required';
                              }

                              final price = double.tryParse(text);

                              if (price == null) {
                                return 'Enter a valid price';
                              }

                              if (price <= 0) {
                                return 'Price must be greater than 0';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: vendorController,
                            textInputAction: TextInputAction.done,
                            decoration: _inputDecoration(
                              hintText: 'Vendor (optional)',
                              icon: Icons.storefront_rounded,
                            ),
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                disabledBackgroundColor:
                                    AppColors.accent.withOpacity(
                                  0.55,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    18,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isSaving
                                  ? null
                                  : widget.isEdit
                                      ? _updatePurchase
                                      : _savePurchase,
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                  milliseconds: 180,
                                ),
                                child: isSaving
                                    ? const SizedBox(
                                        key: ValueKey(
                                          'loading',
                                        ),
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        widget.isEdit
                                            ? 'Update Purchase'
                                            : 'Save Purchase',
                                        key: const ValueKey(
                                          'save',
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePurchase() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (!formValid) {
      AppFlushbar.showError(
        context,
        'Please correct highlighted fields',
      );
      return;
    }

    final quantity = int.parse(
      quantityController.text.trim(),
    );

    final price = double.parse(
      priceController.text.trim(),
    );

    setState(() {
      isSaving = true;
    });

    final saved = await ref.read(purchaseNotifierProvider.notifier).addPurchase(
          type: selectedType,
          customTypeName: selectedType == PurchaseType.other
              ? customTypeController.text.trim()
              : null,
          quantity: quantity,
          price: price,
          vendor: vendorController.text.trim().isEmpty
              ? null
              : vendorController.text.trim(),
          paymentStatus: selectedPaymentStatus,
        );

    if (!mounted) {
      return;
    }

    if (!saved) {
      final error = ref.read(purchaseNotifierProvider).error;

      AppFlushbar.showError(
        context,
        error ?? 'Failed to save purchase',
      );

      setState(() {
        isSaving = false;
      });

      return;
    }

    HapticFeedback.mediumImpact();

    Navigator.pop(context, 'added');
  }

  Future<void> _updatePurchase() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (!formValid) {
      AppFlushbar.showError(
        context,
        'Please correct highlighted fields',
      );
      return;
    }

    final quantity = int.parse(
      quantityController.text.trim(),
    );

    final price = double.parse(
      priceController.text.trim(),
    );

    setState(() {
      isSaving = true;
    });

    final oldPurchase = widget.purchase!;

    final updatedPurchase = WaterPurchaseEntity(
      id: oldPurchase.id,
      type: selectedType,
      customTypeName: selectedType == PurchaseType.other
          ? customTypeController.text.trim()
          : null,
      quantity: quantity,
      price: price,
      vendor: vendorController.text.trim().isEmpty
          ? null
          : vendorController.text.trim(),
      paymentStatus: selectedPaymentStatus,
      date: oldPurchase.date,
      isSynced: false,
      isDeleted: false,
      isEdited: true,
      isActive: oldPurchase.isActive,
      isOfflineCreated: oldPurchase.isOfflineCreated,
      version: oldPurchase.version + 1,
      createdAt: oldPurchase.createdAt,
      updatedAt: DateTime.now(),
      userId: oldPurchase.userId,
      serverId: oldPurchase.serverId,
    );

    final updated = await ref
        .read(purchaseNotifierProvider.notifier)
        .updatePurchase(updatedPurchase);

    if (!mounted) {
      return;
    }

    if (!updated) {
      final error = ref.read(purchaseNotifierProvider).error;

      AppFlushbar.showError(
        context,
        error ?? 'Failed to update purchase',
      );

      setState(() {
        isSaving = false;
      });

      return;
    }

    HapticFeedback.mediumImpact();

    Navigator.pop(context, 'updated');
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.primarybg,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.accent.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red.shade300,
          width: 1.1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1.2,
        ),
      ),
    );
  }

  Future<void> _openTypeSelector() async {

    FocusScope.of(context).unfocus();

    HapticFeedback.selectionClick();

    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    final picked = await showModalBottomSheet<PurchaseType>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(
                      999,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose Purchase Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 22,
                        color: Colors.red.withOpacity(0.6,),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                ...PurchaseType.values.map(
                  (option) => InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        option,
                      );
                    },
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarybg,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          color: selectedType == option
                              ? AppColors.accent.withOpacity(
                                  0.35,
                                )
                              : Colors.transparent,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(
                              0.2,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            height: 40,
                            width: 40,
                            option.iconPath,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  option.subtitle,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedType == option)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.accent,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || picked == null) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    FocusScope.of(context).requestFocus(
      FocusNode(),
    );

    HapticFeedback.lightImpact();

    setState(() {
      selectedType = picked;
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionLabel({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TypeSelectorCard extends StatelessWidget {
  final PurchaseType option;
  final bool enabled;
  final VoidCallback onTap;

  const _TypeSelectorCard({
    required this.option,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primarybg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.18),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
                height: 40,
                width: 40,
                option.iconPath,
                fit: BoxFit.contain,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              color: AppColors.accent.withOpacity(
                enabled ? 1 : 0.5,
              ),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusCard extends StatelessWidget {
  final PaymentStatus status;
  final bool selected;
  final VoidCallback? onTap;

  const _PaymentStatusCard({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.16) : AppColors.primarybg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected ? color : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              status.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? color : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(
    PaymentStatus status,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;

      case PaymentStatus.unpaid:
        return Colors.orange;

      case PaymentStatus.partial:
        return AppColors.accent;
    }
  }

  IconData _statusIcon(
    PaymentStatus status,
  ) {
    switch (status) {
      case PaymentStatus.paid:
        return Icons.verified_rounded;

      case PaymentStatus.unpaid:
        return Icons.hourglass_top_rounded;

      case PaymentStatus.partial:
        return Icons.paid_rounded;
    }
  }
}

