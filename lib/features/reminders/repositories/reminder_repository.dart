import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  final SupabaseClient _supabase;

  ReminderRepository(this._supabase);

  Future<List<ReminderModel>> getReminders() async {
    final response = await _supabase.from('reminders').select().order('date');
    return (response as List).map((e) => ReminderModel.fromJson(e)).toList();
  }

  Future<void> addReminder(ReminderModel reminder) async {
    await _supabase.from('reminders').insert(reminder.toJson());
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await _supabase
        .from('reminders')
        .update(reminder.toJson())
        .eq('id', reminder.id!);
  }

  Future<void> deleteReminder(String id) async {
    await _supabase.from('reminders').delete().eq('id', id);
  }
}
