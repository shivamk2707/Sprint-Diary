import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/training_log_model.dart';

class TrainingRepository {
  final SupabaseClient _supabase;

  TrainingRepository(this._supabase);

  Future<List<TrainingLogModel>> getTrainingLogs() async {
    final response = await _supabase
        .from('training_logs')
        .select()
        .order('date', ascending: false);

    return (response as List).map((e) => TrainingLogModel.fromJson(e)).toList();
  }

  Future<void> addTrainingLog(TrainingLogModel log) async {
    await _supabase.from('training_logs').insert(log.toJson());
  }

  Future<void> updateTrainingLog(TrainingLogModel log) async {
    await _supabase
        .from('training_logs')
        .update(log.toJson())
        .eq('id', log.id!);
  }

  Future<void> deleteTrainingLog(String id) async {
    await _supabase.from('training_logs').delete().eq('id', id);
  }
}
