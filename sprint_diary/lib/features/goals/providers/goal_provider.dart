import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/goal_model.dart';
import '../repositories/goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(supabaseProvider));
});

final goalsProvider = FutureProvider<List<GoalModel>>((ref) async {
  return ref.watch(goalRepositoryProvider).getGoals();
});

class GoalController extends StateNotifier<AsyncValue<void>> {
  final GoalRepository _repo;
  final Ref _ref;

  GoalController(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<void> addGoal(GoalModel goal) async {
    state = const AsyncValue.loading();
    try {
      await _repo.addGoal(goal);
      _ref.invalidate(goalsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateGoal(goal);
      _ref.invalidate(goalsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGoal(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteGoal(id);
      _ref.invalidate(goalsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final goalControllerProvider =
    StateNotifierProvider<GoalController, AsyncValue<void>>((ref) {
  return GoalController(ref.watch(goalRepositoryProvider), ref);
});
