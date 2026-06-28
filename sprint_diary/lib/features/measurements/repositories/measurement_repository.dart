import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/measurement_model.dart';

class MeasurementRepository {
  final SupabaseClient _supabase;

  MeasurementRepository(this._supabase);

  Future<List<MeasurementModel>> getMeasurements() async {
    final response = await _supabase
        .from('body_measurements')
        .select()
        .order('date', ascending: false);
    return (response as List).map((e) => MeasurementModel.fromJson(e)).toList();
  }
}
