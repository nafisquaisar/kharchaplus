import '../../../../../core/services/auth_service.dart';
import '../../domain/entities/water_reminder_entity.dart';
import '../../domain/repository/reminder_repository.dart';
import '../datasource/local/isar/water_reminder_local_ds.dart';
import '../mapper/water_reminder_mapper.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final WaterReminderLocalDataSource localDataSource;
  final AuthService authService;

  ReminderRepositoryImpl({
    required this.localDataSource,
    required this.authService,
  });

  @override
  Future<void> addReminder(WaterReminderEntity reminder) async {
    final model = WaterReminderMapper.entityToModel(reminder);
    await localDataSource.addReminder(model);
  }

  @override
  Future<void> updateReminder(WaterReminderEntity reminder) async {
    final model = WaterReminderMapper.entityToModel(reminder);
    await localDataSource.updateReminder(model);
  }

  @override
  Future<void> toggleReminder(String id, bool enabled) async {
    await localDataSource.toggleReminder(id, enabled);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await localDataSource.deleteReminder(id);
  }

  @override
  Future<List<WaterReminderEntity>> getReminders() async {
    final userId = await authService.getCurrentUserId();
    final models = await localDataSource.getReminders(userId);
    return models.map(WaterReminderMapper.modelToEntity).toList();
  }
}
