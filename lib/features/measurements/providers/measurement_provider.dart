import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/measurement_model.dart';
import '../repositories/measurement_repository.dart';

final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepository(ref.watch(supabaseProvider));
});

final measurementsProvider =
    FutureProvider<List<MeasurementModel>>((ref) async {
  return ref.watch(measurementRepositoryProvider).getMeasurements();
});
