import 'package:riverpod/riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/note_model.dart';
import '../repositories/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(supabaseProvider));
});

final notesProvider = FutureProvider<List<NoteModel>>((ref) async {
  return ref.watch(noteRepositoryProvider).getNotes();
});

class NoteController extends StateNotifier<AsyncValue<void>> {
  final NoteRepository _repo;
  final Ref _ref;

  NoteController(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<void> addNote(NoteModel note) async {
    state = const AsyncValue.loading();
    try {
      await _repo.addNote(note);
      _ref.invalidate(notesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNote(NoteModel note) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateNote(note);
      _ref.invalidate(notesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNote(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteNote(id);
      _ref.invalidate(notesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final noteControllerProvider =
    StateNotifierProvider<NoteController, AsyncValue<void>>((ref) {
  return NoteController(ref.watch(noteRepositoryProvider), ref);
});
