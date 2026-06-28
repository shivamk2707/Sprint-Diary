import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sprint_diary/features/auth/repositories/auth_repository.dart';

@GenerateMocks([SupabaseClient, GoTrueClient])
import 'auth_repository_test.mocks.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuthClient;
  late AuthRepository authRepository;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAuthClient = MockGoTrueClient();
    when(mockSupabaseClient.auth).thenReturn(mockAuthClient);
    authRepository = AuthRepository(mockSupabaseClient);
  });

  group('AuthRepository', () {
    test('signInWithEmailPassword calls correct method on Supabase', () async {
      final mockResponse = AuthResponse(session: null, user: null);
      when(mockAuthClient.signInWithPassword(
        email: 'test@test.com',
        password: 'password',
      )).thenAnswer((_) async => mockResponse);

      await authRepository.signInWithEmailPassword('test@test.com', 'password');

      verify(mockAuthClient.signInWithPassword(
        email: 'test@test.com',
        password: 'password',
      )).called(1);
    });
  });
}
