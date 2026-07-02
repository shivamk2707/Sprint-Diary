import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/reminder_model.dart';
import '../repositories/reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(supabaseProvider));
});

final remindersProvider = FutureProvider<List<ReminderModel>>((ref) async {
  return ref.watch(reminderRepositoryProvider).getReminders();
});

class ReminderController extends StateNotifier<AsyncValue<void>> {
  final ReminderRepository _repo;
  final Ref _ref;

  ReminderController(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> addReminder(ReminderModel reminder) async {
    state = const AsyncValue.loading();
    try {
      await _repo.addReminder(reminder);
      _ref.invalidate(remindersProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateReminder(reminder);
      _ref.invalidate(remindersProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteReminder(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteReminder(id);
      _ref.invalidate(remindersProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final reminderControllerProvider =
    StateNotifierProvider<ReminderController, AsyncValue<void>>((ref) {
  return ReminderController(ref.watch(reminderRepositoryProvider), ref);
});
