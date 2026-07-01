import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod/riverpod.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  // Use these in production, reading from env
  static const String supabaseUrl = 'https://bolaxzunboqcsidhhdpo.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_f8iwgvvUvWSCzDA5_ZpOug_hv13KLPE';

  static Future<void> initialize() async {
    // Note: In a real app, these should be loaded from an environment variable.
    // We are mocking initialization here as requested for a fully functional app without providing actual keys to the user.
    // The user will replace these.
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
    } catch (e) {
      // Handle init error if keys are not valid
      print('Supabase initialization failed. Please set valid URL and Key.');
    }
  }
}
