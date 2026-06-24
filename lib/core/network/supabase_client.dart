import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton Supabase client initializer.
/// Call [init] once in main.dart before runApp.
class SupabaseClientService {
  SupabaseClientService._();

  static SupabaseClient? _client;

  static Future<void> init({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase not initialized. Call SupabaseClientService.init() first.');
    }
    return _client!;
  }

  static bool get isInitialized => _client != null;
}
