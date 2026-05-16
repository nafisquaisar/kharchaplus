enum PurchaseType {
  tanker,
  can20L,
  water1L,
  other,
}

extension PurchaseTypeX on PurchaseType {
  String get label {
    switch (this) {
      case PurchaseType.tanker:
        return 'Tanker';
      case PurchaseType.can20L:
        return '20L Can';
      case PurchaseType.water1L:
        return '1L Water';
      case PurchaseType.other:
        return 'Other';
    }
  }

  String get subtitle {
    switch (this) {
      case PurchaseType.tanker:
        return 'Bulk refill order';
      case PurchaseType.can20L:
        return 'Standard can delivery';
      case PurchaseType.water1L:
        return 'Packaged bottle purchase';
      case PurchaseType.other:
        return 'Custom water purchase';
    }
  }

  String get iconPath {
    switch (this) {
      case PurchaseType.tanker:
        return 'assets/icon/premiumicon/kharchaplus_tanker.png';
      case PurchaseType.can20L:
        return 'assets/icon/premiumicon/kharchaplus_20l.png';
      case PurchaseType.water1L:
        return 'assets/icon/premiumicon/kharcha_plus_1l.png';
      case PurchaseType.other:
        return 'assets/icon/premiumicon/kharcha_plus_1l.png';
    }
  }

  static PurchaseType fromName(String? value) {
    if (value == null || value.isEmpty) {
      return PurchaseType.other;
    }

    final byName = PurchaseType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => PurchaseType.other,
    );

    if (byName != PurchaseType.other) {
      return byName;
    }

    final normalized = value.trim().toLowerCase();
    return PurchaseType.values.firstWhere(
      (type) => type.label.toLowerCase() == normalized,
      orElse: () => PurchaseType.other,
    );
  }
}


