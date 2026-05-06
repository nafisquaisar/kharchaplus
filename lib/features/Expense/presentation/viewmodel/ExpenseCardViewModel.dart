import 'package:flutter/material.dart';
import '../../data/model/ExpenseCardModel.dart';
import '../../data/repository/ExpenseCardRepository.dart';

class ExpenseCardViewModel extends ChangeNotifier {
  final ExpenseCardRepository _repo;

  ExpenseCardViewModel(this._repo);

  List<ExpenseCardModel> cards = [];

  void listenCards(String userId) {
    _repo.getCards(userId).listen((data) {
      cards = data;
      notifyListeners();
    });
  }

  Future<void> addCard(ExpenseCardModel card) async {
    await _repo.addCard(card);
  }

  Future<void> updateCard(ExpenseCardModel card) async {
    await _repo.updateCard(card);
  }

  Future<void> deleteCard(String userId, String cardId) async {
    await _repo.deleteCard(userId, cardId);
  }
}