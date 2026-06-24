import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';
import 'package:sortirin/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Update user profile.
class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<ProfileEntity> call({
    required String userId,
    String? phone,
    String? city,
    String? district,
  }) async {
    return _repository.updateProfile(
      userId: userId,
      phone: phone,
      city: city,
      district: district,
    );
  }
}
