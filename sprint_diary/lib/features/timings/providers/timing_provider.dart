import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/sprint_timing_model.dart';
import '../repositories/timing_repository.dart';

final timingRepositoryProvider = Provider<TimingRepository>((ref) {
  return TimingRepository(ref.watch(supabaseProvider));
});

final timingsProvider = FutureProvider<List<SprintTimingModel>>((ref) async {
  return ref.watch(timingRepositoryProvider).getTimings();
});

class TimingController extends StateNotifier<AsyncValue<void>> {
  final TimingRepository _repo;
  final Ref _ref;

  TimingController(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<void> addTiming(SprintTimingModel timing) async {
    state = const AsyncValue.loading();
    try {
      // Calculate improvement
      final previous =
          await _repo.getPreviousTiming(timing.distance, timing.date);
      double? prevTime;
      double? improvement;
      if (previous != null) {
        prevTime = previous.timing;
        improvement = previous.timing - timing.timing; // positive means faster
      }

      final timingToSave = SprintTimingModel(
          id: timing.id,
          userId: timing.userId,
          date: timing.date,
          distance: timing.distance,
          timing: timing.timing,
          location: timing.location,
          weather: timing.weather,
          notes: timing.notes,
          previousTime: prevTime,
          improvement: improvement,
          isPersonalBest: timing
              .isPersonalBest // Note: in real app, might want to check all-time best
          );

      await _repo.addTiming(timingToSave);
      _ref.invalidate(timingsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTiming(SprintTimingModel timing) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateTiming(timing);
      _ref.invalidate(timingsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTiming(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteTiming(id);
      _ref.invalidate(timingsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final timingControllerProvider =
    StateNotifierProvider<TimingController, AsyncValue<void>>((ref) {
  return TimingController(ref.watch(timingRepositoryProvider), ref);
});
