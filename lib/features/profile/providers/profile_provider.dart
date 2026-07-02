import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseProvider));
});

final profileProvider = FutureProvider<ProfileModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(profileRepositoryProvider).getProfile(user.id);
});

final settingsProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  return ref.watch(profileRepositoryProvider).getDarkModeSetting(user.id);
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repo;
  final Ref _ref;

  ProfileController(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<void> updateProfile(ProfileModel profile) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateProfile(profile);
      _ref.invalidate(profileProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleDarkMode(bool isDark) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    try {
      await _repo.updateSettings(user.id, isDark);
      _ref.invalidate(settingsProvider);
    } catch (e) {
      // Handle silently or show toast
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider), ref);
});
