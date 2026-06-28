import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  Future<ProfileModel> getProfile(String userId) async {
    final response =
        await _supabase.from('profiles').select().eq('id', userId).single();
    return ProfileModel.fromJson(response);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _supabase.from('profiles').upsert(profile.toJson());
  }

  Future<void> updateSettings(String userId, bool isDarkMode) async {
    await _supabase
        .from('settings')
        .upsert({'id': userId, 'dark_mode': isDarkMode});
  }

  Future<bool> getDarkModeSetting(String userId) async {
    try {
      final response = await _supabase
          .from('settings')
          .select('dark_mode')
          .eq('id', userId)
          .maybeSingle();
      return response != null ? response['dark_mode'] as bool : false;
    } catch (_) {
      return false;
    }
  }
}
