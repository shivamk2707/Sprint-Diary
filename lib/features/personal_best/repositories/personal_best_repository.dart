import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/personal_best_model.dart';

class PersonalBestRepository {
  final SupabaseClient _supabase;

  PersonalBestRepository(this._supabase);

  Future<List<PersonalBestModel>> getPersonalBests() async {
    final response = await _supabase
        .from('personal_bests')
        .select()
        .order('distance', ascending: true);
    return (response as List)
        .map((e) => PersonalBestModel.fromJson(e))
        .toList();
  }

  // Simplified CRUD since it's similar to others
}
