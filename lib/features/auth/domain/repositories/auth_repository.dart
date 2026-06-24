import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';

/// Abstract repository for authentication — implementation in data layer.
abstract class AuthRepository {
  /// Sign in with Google OAuth via Supabase.
  Future<({ProfileEntity profile, bool isNewUser})> signInWithGoogle();

  /// Sign out current session.
  Future<void> signOut();

  /// Update user profile fields (phone, city, district).
  Future<ProfileEntity> updateProfile({
    required String userId,
    String? phone,
    String? city,
    String? district,
  });

  /// Get current user profile from DB.
  Future<ProfileEntity?> getProfile(String userId);

  /// Check if user has an active session.
  Future<bool> isLoggedIn();

  /// Get the current user's ID (from auth session).
  Future<String?> getCurrentUserId();
}
