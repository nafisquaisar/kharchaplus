import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/water_goal_model.dart';
import '../../models/water_intake_model.dart';
import '../../models/water_purchase_model.dart';
import '../../models/water_reminder_model.dart';
import '../../../domain/enum/purchase_type.dart';
import '../../../domain/enum/payment_status.dart';

class RemoteWaterData {
  final List<WaterIntakeModel> intakes;
  final List<WaterPurchaseModel> purchases;
  final List<WaterGoalModel> goals;
  final List<WaterReminderModel> reminders;

  const RemoteWaterData({
    required this.intakes,
    required this.purchases,
    required this.goals,
    required this.reminders,
  });
}

class RemoteWaterPending {
  final List<WaterIntakeModel> intakes;
  final List<WaterPurchaseModel> purchases;
  final List<WaterGoalModel> goals;
  final List<WaterReminderModel> reminders;

  const RemoteWaterPending({
    required this.intakes,
    required this.purchases,
    required this.goals,
    required this.reminders,
  });
}

abstract class FirebaseWaterRemoteDataSource {
  Future<void> syncIntakes(List<WaterIntakeModel> models);

  Future<void> syncPurchases(List<WaterPurchaseModel> models);

  Future<void> syncGoals(List<WaterGoalModel> models);

  Future<void> syncReminders(List<WaterReminderModel> models);

  Future<RemoteWaterData> pullRemoteData({DateTime? updatedAfter});

  Future<void> pushPendingLocalData(RemoteWaterPending pending);

  Future<void> uploadWaterIntake(WaterIntakeModel model);

  Future<void> uploadPurchase(WaterPurchaseModel model);

  Future<void> uploadGoal(WaterGoalModel model);

  Future<void> uploadReminder(WaterReminderModel model);

  Future<void> deleteRemoteData({
    required String collection,
    required String id,
  });
}

class FirebaseWaterRemoteDataSourceImpl
    implements FirebaseWaterRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseWaterRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String _uid() {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not authenticated');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _collection(String name) {
    return firestore.collection('users').doc(_uid()).collection(name);
  }

  @override
  Future<void> syncIntakes(List<WaterIntakeModel> models) async {
    await _batchUpsert('water_intake', models.map(_intakeToMap).toList());
  }

  @override
  Future<void> syncPurchases(List<WaterPurchaseModel> models) async {
    await _batchUpsert('water_purchase', models.map(_purchaseToMap).toList());
  }

  @override
  Future<void> syncGoals(List<WaterGoalModel> models) async {
    await _batchUpsert('water_goal', models.map(_goalToMap).toList());
  }

  @override
  Future<void> syncReminders(List<WaterReminderModel> models) async {
    await _batchUpsert('water_reminder', models.map(_reminderToMap).toList());
  }

  @override
  Future<RemoteWaterData> pullRemoteData({DateTime? updatedAfter}) async {
    final intakes = await _pullCollection(
      'water_intake',
      updatedAfter: updatedAfter,
      mapper: _intakeFromMap,
    );
    final purchases = await _pullCollection(
      'water_purchase',
      updatedAfter: updatedAfter,
      mapper: _purchaseFromMap,
    );
    final goals = await _pullCollection(
      'water_goal',
      updatedAfter: updatedAfter,
      mapper: _goalFromMap,
    );
    final reminders = await _pullCollection(
      'water_reminder',
      updatedAfter: updatedAfter,
      mapper: _reminderFromMap,
    );

    return RemoteWaterData(
      intakes: intakes,
      purchases: purchases,
      goals: goals,
      reminders: reminders,
    );
  }

  @override
  Future<void> pushPendingLocalData(RemoteWaterPending pending) async {
    await syncIntakes(pending.intakes);
    await syncPurchases(pending.purchases);
    await syncGoals(pending.goals);
    await syncReminders(pending.reminders);
  }

  @override
  Future<void> uploadWaterIntake(WaterIntakeModel model) async {
    await _setDoc('water_intake', model.id, _intakeToMap(model));
  }

  @override
  Future<void> uploadPurchase(WaterPurchaseModel model) async {
    await _setDoc('water_purchase', model.id, _purchaseToMap(model));
  }

  @override
  Future<void> uploadGoal(WaterGoalModel model) async {
    await _setDoc('water_goal', model.id, _goalToMap(model));
  }

  @override
  Future<void> uploadReminder(WaterReminderModel model) async {
    await _setDoc('water_reminder', model.id, _reminderToMap(model));
  }

  @override
  Future<void> deleteRemoteData({
    required String collection,
    required String id,
  }) async {
    await _collection(collection).doc(id).delete();
  }

  Future<void> _setDoc(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _collection(collection).doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> _batchUpsert(
    String collection,
    List<Map<String, dynamic>> data,
  ) async {
    if (data.isEmpty) return;

    final batch = firestore.batch();
    final ref = _collection(collection);

    for (final item in data) {
      final id = item['id'] as String?;
      if (id == null) continue;

      final doc = ref.doc(id);
      if (item['isDeleted'] == true) {
        batch.delete(doc);
      } else {
        batch.set(doc, item, SetOptions(merge: true));
      }
    }

    await batch.commit();
  }

  Future<List<T>> _pullCollection<T>(
    String collection, {
    required T Function(Map<String, dynamic>) mapper,
    DateTime? updatedAfter,
  }) async {
    Query<Map<String, dynamic>> query = _collection(collection);

    if (updatedAfter != null) {
      query = query.where(
        'updatedAt',
        isGreaterThan: Timestamp.fromDate(updatedAfter),
      );
    }

    final snapshot = await query.get();
    debugPrint('[REMOTE] $collection pull: ${snapshot.docs.length}');

    return snapshot.docs.map((doc) => mapper(_withDocId(doc))).toList();
  }

  Map<String, dynamic> _withDocId(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return {
      ...data,
      'id': data['id'] ?? doc.id,
      'serverId': data['serverId'] ?? doc.id,
    };
  }

  Map<String, dynamic> _intakeToMap(WaterIntakeModel model) {
    return {
      'id': model.id,
      'amountMl': model.amountMl,
      'dateTime': Timestamp.fromDate(model.dateTime),
      'sourceType': model.sourceType,
      'isSynced': model.isSynced,
      'isDeleted': model.isDeleted,
      'isEdited': model.isEdited,
      'isActive': model.isActive,
      'isOfflineCreated': model.isOfflineCreated,
      'version': model.version,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
      'userId': model.userId,
      'serverId': model.serverId,
    };
  }

  WaterIntakeModel _intakeFromMap(Map<String, dynamic> data) {
    final model = WaterIntakeModel();
    model.id = data['id'] as String;
    model.amountMl = (data['amountMl'] as num?)?.toInt() ?? 0;
    model.dateTime = _toDateTime(data['dateTime']);
    model.sourceType = data['sourceType'] as String? ?? 'Manual';
    _applySyncFields(model, data);
    return model;
  }

  Map<String, dynamic> _purchaseToMap(WaterPurchaseModel model) {
    final paymentStatus = PaymentStatusX.fromValue(model.paymentStatus).value;

    return {
      'id': model.id,
      'type': model.type,
      'customTypeName': model.customTypeName,
      'quantity': model.quantity,
      'price': model.price,
      'vendor': model.vendor,
      'paymentStatus': paymentStatus,
      'date': Timestamp.fromDate(model.date),
      'isSynced': model.isSynced,
      'isDeleted': model.isDeleted,
      'isEdited': model.isEdited,
      'isActive': model.isActive,
      'isOfflineCreated': model.isOfflineCreated,
      'version': model.version,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
      'userId': model.userId,
      'serverId': model.serverId,
    };
  }

  WaterPurchaseModel _purchaseFromMap(Map<String, dynamic> data) {
    final model = WaterPurchaseModel();
    model.id = data['id'] as String;
    model.type = PurchaseTypeX.fromName(data['type'] as String?).name;
    model.customTypeName = data['customTypeName'] as String?;
    model.quantity = (data['quantity'] as num?)?.toInt() ?? 0;
    model.price = (data['price'] as num?)?.toDouble() ?? 0.0;
    model.vendor = data['vendor'] as String?;
    model.paymentStatus =
        PaymentStatusX.fromValue(data['paymentStatus'] as String?).value;
    model.date = _toDateTime(data['date']);
    _applySyncFields(model, data);
    return model;
  }

  Map<String, dynamic> _goalToMap(WaterGoalModel model) {
    return {
      'id': model.id,
      'dailyGoalMl': model.dailyGoalMl,
      'reminderEnabled': model.reminderEnabled,
      'isSynced': model.isSynced,
      'isDeleted': model.isDeleted,
      'isEdited': model.isEdited,
      'isActive': model.isActive,
      'isOfflineCreated': model.isOfflineCreated,
      'version': model.version,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
      'userId': model.userId,
      'serverId': model.serverId,
    };
  }

  WaterGoalModel _goalFromMap(Map<String, dynamic> data) {
    final model = WaterGoalModel();
    model.id = data['id'] as String;
    model.dailyGoalMl = (data['dailyGoalMl'] as num?)?.toInt() ?? 3000;
    model.reminderEnabled = data['reminderEnabled'] as bool? ?? true;
    _applySyncFields(model, data);
    return model;
  }

  Map<String, dynamic> _reminderToMap(WaterReminderModel model) {
    return {
      'id': model.id,
      'hour': model.hour,
      'minute': model.minute,
      'repeatDaily': model.repeatDaily,
      'enabled': model.enabled,
      'notificationId': model.notificationId,
      'isSynced': model.isSynced,
      'isDeleted': model.isDeleted,
      'isEdited': model.isEdited,
      'isActive': model.isActive,
      'isOfflineCreated': model.isOfflineCreated,
      'version': model.version,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
      'userId': model.userId,
      'serverId': model.serverId,
    };
  }

  WaterReminderModel _reminderFromMap(Map<String, dynamic> data) {
    final model = WaterReminderModel();
    model.id = data['id'] as String;
    model.hour = (data['hour'] as num?)?.toInt() ?? 0;
    model.minute = (data['minute'] as num?)?.toInt() ?? 0;
    model.repeatDaily = data['repeatDaily'] as bool? ?? false;
    model.enabled = data['enabled'] as bool? ?? true;
    model.notificationId = (data['notificationId'] as num?)?.toInt() ?? 0;
    _applySyncFields(model, data);
    return model;
  }

  void _applySyncFields(dynamic model, Map<String, dynamic> data) {
    model.isSynced = data['isSynced'] as bool? ?? true;
    model.isDeleted = data['isDeleted'] as bool? ?? false;
    model.isEdited = data['isEdited'] as bool? ?? false;
    model.isActive = data['isActive'] as bool? ?? true;
    model.isOfflineCreated = data['isOfflineCreated'] as bool? ?? false;
    model.version = (data['version'] as num?)?.toInt() ?? 1;
    model.createdAt = _toDateTime(data['createdAt']);
    model.updatedAt = _toDateTime(data['updatedAt']);
    model.userId = data['userId'] as String? ?? _uid();
    model.serverId = data['serverId'] as String?;
  }

  DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }
}
