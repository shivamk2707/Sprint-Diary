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
