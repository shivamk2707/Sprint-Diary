import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/personal_best_model.dart';
import '../repositories/personal_best_repository.dart';

final pbRepositoryProvider = Provider<PersonalBestRepository>((ref) {
  return PersonalBestRepository(ref.watch(supabaseProvider));
});

final personalBestsProvider =
    FutureProvider<List<PersonalBestModel>>((ref) async {
  return ref.watch(pbRepositoryProvider).getPersonalBests();
});
