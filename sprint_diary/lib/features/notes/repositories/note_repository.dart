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
}
