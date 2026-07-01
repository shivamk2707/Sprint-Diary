import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/training_log_model.dart';
import '../repositories/training_repository.dart';

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepository(ref.watch(supabaseProvider));
});

final trainingLogsProvider =
    FutureProvider<List<TrainingLogModel>>((ref) async {
  return ref.watch(trainingRepositoryProvider).getTrainingLogs();
});

class TrainingController extends StateNotifier<AsyncValue<void>> {
  final TrainingRepository _repo;
  final Ref _ref;

  TrainingController(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> addLog(TrainingLogModel log) async {
    state = const AsyncValue.loading();
    try {
      await _repo.addTrainingLog(log);
      _ref.invalidate(trainingLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateLog(TrainingLogModel log) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateTrainingLog(log);
      _ref.invalidate(trainingLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteLog(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteTrainingLog(id);
      _ref.invalidate(trainingLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, AsyncValue<void>>((ref) {
  return TrainingController(ref.watch(trainingRepositoryProvider), ref);
});
