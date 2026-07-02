import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/goal_model.dart';

class GoalRepository {
  final SupabaseClient _supabase;

  GoalRepository(this._supabase);

  Future<List<GoalModel>> getGoals() async {
    final response = await _supabase
        .from('goals')
        .select()
        .order('completed', ascending: true) // Uncompleted first
        .order('target_date', ascending: true);
    return (response as List).map((e) => GoalModel.fromJson(e)).toList();
  }

  Future<void> addGoal(GoalModel goal) async {
    await _supabase.from('goals').insert(goal.toJson());
  }

  Future<void> updateGoal(GoalModel goal) async {
    await _supabase.from('goals').update(goal.toJson()).eq('id', goal.id!);
  }

  Future<void> deleteGoal(String id) async {
    await _supabase.from('goals').delete().eq('id', id);
  }
}
