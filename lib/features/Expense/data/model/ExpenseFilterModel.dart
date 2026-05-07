import 'ExpenseModel.dart';

enum ExpenseSortType {
  latest,
  oldest,
  highest,
  lowest,
}
const _empty = Object();
class ExpenseFilterModel {

  final ExpenseType? type;

  final String? categoryId;

  final PaymentMode? paymentMode;

  final DateTime? startDate;
  final DateTime? endDate;

  final ExpenseSortType sortType;

  const ExpenseFilterModel({

    this.type,

    this.categoryId,

    this.paymentMode,

    this.startDate,
    this.endDate,

    this.sortType =
        ExpenseSortType.latest,
  });


  ExpenseFilterModel copyWith({

    Object? type = _empty,

    Object? categoryId = _empty,

    Object? paymentMode = _empty,

    Object? startDate = _empty,

    Object? endDate = _empty,

    ExpenseSortType? sortType,
  }) {

    return ExpenseFilterModel(

      type: type == _empty
          ? this.type
          : type as ExpenseType?,

      categoryId:
      categoryId == _empty
          ? this.categoryId
          : categoryId as String?,

      paymentMode:
      paymentMode == _empty
          ? this.paymentMode
          : paymentMode as PaymentMode?,

      startDate:
      startDate == _empty
          ? this.startDate
          : startDate as DateTime?,

      endDate:
      endDate == _empty
          ? this.endDate
          : endDate as DateTime?,

      sortType:
      sortType ?? this.sortType,
    );
  }
}