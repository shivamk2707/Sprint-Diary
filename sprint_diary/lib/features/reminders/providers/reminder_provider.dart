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
