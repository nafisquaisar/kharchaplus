enum PaymentStatus {
  paid,
  unpaid,
  partial,
}

extension PaymentStatusX on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.unpaid:
        return 'unpaid';
      case PaymentStatus.partial:
        return 'partial';
    }
  }

  String get label {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.unpaid:
        return 'Unpaid';
      case PaymentStatus.partial:
        return 'Partial Paid';
    }
  }

  bool get isPending => this != PaymentStatus.paid;

  static PaymentStatus fromValue(String? value) {
    final normalized = value?.trim().toLowerCase() ?? '';
    switch (normalized) {
      case 'paid':
        return PaymentStatus.paid;
      case 'partial':
      case 'partial_paid':
      case 'partial paid':
        return PaymentStatus.partial;
      case 'unpaid':
      default:
        return PaymentStatus.unpaid;
    }
  }
}
