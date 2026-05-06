import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ExpenseCardModel.dart';

class ExpenseCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ExpenseCardModel>> getCards(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expense_cards")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseCardModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> addCard(ExpenseCardModel card) async {
    await _firestore
        .collection("users")
        .doc(card.userId)
        .collection("expense_cards")
        .doc(card.id)
        .set(card.toJson());
  }

  Future<void> updateCard(ExpenseCardModel card) async {
    await _firestore
        .collection("users")
        .doc(card.userId)
        .collection("expense_cards")
        .doc(card.id)
        .update(card.toJson());
  }

  Future<void> deleteCard(String userId, String cardId) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("expense_cards")
        .doc(cardId)
        .delete();
  }
}