import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sprint_timing_model.dart';

class TimingRepository {
  final SupabaseClient _supabase;

  TimingRepository(this._supabase);

  Future<List<SprintTimingModel>> getTimings() async {
    final response = await _supabase
        .from('sprint_timings')
        .select()
        .order('date', ascending: false);
    return (response as List)
        .map((e) => SprintTimingModel.fromJson(e))
        .toList();
  }

  Future<SprintTimingModel?> getPreviousTiming(
      double distance, DateTime beforeDate) async {
    final response = await _supabase
        .from('sprint_timings')
        .select()
        .eq('distance', distance)
        .lt('date', beforeDate.toIso8601String().split('T')[0])
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return SprintTimingModel.fromJson(response);
  }

  Future<void> addTiming(SprintTimingModel timing) async {
    await _supabase.from('sprint_timings').insert(timing.toJson());
  }

  Future<void> updateTiming(SprintTimingModel timing) async {
    await _supabase
        .from('sprint_timings')
        .update(timing.toJson())
        .eq('id', timing.id!);
  }

  Future<void> deleteTiming(String id) async {
    await _supabase.from('sprint_timings').delete().eq('id', id);
  }
}
