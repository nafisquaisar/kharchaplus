import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFoodService {

  final FirebaseFirestore firestore;

  final FirebaseAuth auth;

  FirebaseFoodService({
    required this.firestore,
    required this.auth,
  });

  String get uid => auth.currentUser!.uid;

  // =========================
  // COLLECTION REFERENCES
  // =========================

  CollectionReference get foodCyclesRef =>
      firestore
          .collection("users")
          .doc(uid)
          .collection("food_cycles");

  CollectionReference get mealEntriesRef =>
      firestore
          .collection("users")
          .doc(uid)
          .collection("meal_entries");
}