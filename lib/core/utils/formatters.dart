
import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat _inrFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  const AppFormatters._();

  static String inr(double amount) {
    return _inrFormat.format(amount);
  }

  static String date(DateTime date) {
    return _dateFormat.format(date);
  }
}
