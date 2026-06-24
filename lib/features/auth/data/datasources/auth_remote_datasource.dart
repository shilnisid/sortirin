import 'package:sortirin/core/errors/exceptions.dart';
import 'package:sortirin/features/auth/data/models/profile_model.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:gotrue/gotrue.dart' show OAuthProvider;
import 'package:url_launcher/url_launcher.dart';

/// Remote data source for authentication via Supabase.
class AuthRemoteDataSource {
  /// Sign in with Google OAuth via Supabase.
  ///
  /// Returns the User object and whether the user is new.
  Future<({ProfileModel profile, bool isNewUser})> signInWithGoogle() async {
    try {
      final supabase = SupabaseClientService.client;
      // Use getOAuthSignInUrl directly to avoid extension method analyzer issues.
      final oauthResponse = await supabase.auth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
      );

      // Launch the OAuth URL in the browser
      final uri = Uri.parse(oauthResponse.url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // After redirect, auth state changes are picked up via deep link.
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw const AuthException('Gagal mendapatkan sesi setelah login Google');
      }

      final user = session.user;
      final userId = user.id;
      final email = user.email;
      final name = user.userMetadata?['full_name'] as String?;
      final photoUrl = user.userMetadata?['avatar_url'] as String?;

      // Check if profile exists in profiles table
      final existingProfile = await getProfile(userId);
      final isNewUser = existingProfile == null;

      final profile = ProfileModel(
        id: userId,
        email: email,
        name: name,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );

      if (isNewUser) {
        // Create initial profile record
        await supabase.from('profiles').upsert(profile.toJson());
      }

      return (profile: profile, isNewUser: isNewUser);
    } catch (e) {
      throw AuthException(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Sign out from Supabase.
  Future<void> signOut() async {
    try {
      await SupabaseClientService.client.auth.signOut();
    } catch (e) {
      throw AuthException(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Get profile from Supabase profiles table.
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await SupabaseClientService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Update profile fields.
  Future<ProfileModel> updateProfile({
    required String userId,
    String? phone,
    String? city,
    String? district,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (phone != null) updates['phone'] = phone;
      if (city != null) updates['city'] = city;
      if (district != null) updates['district'] = district;

      // If phone is set, mark profile as complete
      if (phone != null) {
        updates['is_profile_complete'] = true;
      }

      await SupabaseClientService.client
          .from('profiles')
          .upsert(updates)
          .eq('id', userId);

      final updated = await getProfile(userId);
      return updated ?? (throw const ServerException('Gagal mengambil profil setelah update'));
    } catch (e) {
      throw ServerException(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Check if user has an active Supabase session.
  Future<bool> isLoggedIn() async {
    final session = SupabaseClientService.client.auth.currentSession;
    return session != null;
  }

  /// Get current user ID.
  Future<String?> getCurrentUserId() async {
    final user = SupabaseClientService.client.auth.currentUser;
    return user?.id;
  }
}
