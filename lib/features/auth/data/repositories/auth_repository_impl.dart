import 'package:sortirin/core/errors/exceptions.dart';
import 'package:sortirin/core/errors/failures.dart';
import 'package:sortirin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';
import 'package:sortirin/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Supabase remote data source.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<({ProfileEntity profile, bool isNewUser})> signInWithGoogle() async {
    try {
      final result = await _remoteDataSource.signInWithGoogle();
      return (
        profile: result.profile.toEntity(),
        isNewUser: result.isNewUser,
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String userId,
    String? phone,
    String? city,
    String? district,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfile(
        userId: userId,
        phone: phone,
        city: city,
        district: district,
      );
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final model = await _remoteDataSource.getProfile(userId);
      return model?.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _remoteDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      return await _remoteDataSource.getCurrentUserId();
    } catch (e) {
      return null;
    }
  }
}
