import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/ExpenseCardModel.dart';

class ExpenseCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =====================================================
  /// COLLECTION REF
  /// =====================================================

  CollectionReference<ExpenseCardModel> cardRef(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expense_cards")
        .withConverter<ExpenseCardModel>(
          fromFirestore: (snapshot, _) {
            return ExpenseCardModel.fromJson(snapshot.data()!);
          },

          toFirestore: (card, _) {
            return card.toJson();
          },
        );
  }

  /// =====================================================
  /// GET CARDS
  /// =====================================================

  Stream<List<ExpenseCardModel>> getCards(String userId) {
    print("🔥 getCards called");

    print("🔥 userId: $userId");

    return cardRef(userId)
        .where("isDeleted", isEqualTo: false)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          print("🔥 snapshot docs: ${snapshot.docs.length}");

          for (final doc in snapshot.docs) {
            print("🔥 doc data: ${doc.data().toJson()}");
          }

          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  /// =====================================================
  /// CREATE CARD
  /// =====================================================

  Future<void> addCard(ExpenseCardModel card) async {
    try {
      await cardRef(card.userId).doc(card.id).set(card);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  /// =====================================================
  /// UPDATE CARD
  /// =====================================================

  Future<void> updateCard(ExpenseCardModel card) async {
    try {
      await cardRef(card.userId).doc(card.id).update(card.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  /// =====================================================
  /// SOFT DELETE
  /// =====================================================

  Future<void> deleteCard({
    required String userId,

    required String cardId,
  }) async {
    try {
      await cardRef(userId).doc(cardId).update({
        /// ✅ NOW SAFE
        "isDeleted": true,

        "updatedAt": DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
