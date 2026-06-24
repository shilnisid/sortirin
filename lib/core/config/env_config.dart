import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralised environment config.
/// Loaded from `.env` at app startup.
class EnvConfig {
  EnvConfig._();

  static String get supabaseUrl => _getOrThrow('SUPABASE_URL');
  static String get supabasePublishableKey =>
      _getOrThrow('SUPABASE_PUBLISHABLE_KEY');

  static String _getOrThrow(String key) {
    final val = dotenv.env[key];
    if (val == null || val.isEmpty) {
      throw StateError('Missing env variable: $key. Check your .env file.');
    }
    return val;
  }
}
