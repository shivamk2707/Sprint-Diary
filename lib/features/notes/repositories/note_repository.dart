import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_model.dart';

class NoteRepository {
  final SupabaseClient _supabase;

  NoteRepository(this._supabase);

  Future<List<NoteModel>> getNotes() async {
    final response =
        await _supabase.from('notes').select().order('date', ascending: false);
    return (response as List).map((e) => NoteModel.fromJson(e)).toList();
  }

  Future<void> addNote(NoteModel note) async {
    await _supabase.from('notes').insert(note.toJson());
  }

  Future<void> updateNote(NoteModel note) async {
    await _supabase.from('notes').update(note.toJson()).eq('id', note.id!);
  }

  Future<void> deleteNote(String id) async {
    await _supabase.from('notes').delete().eq('id', id);
  }
}
