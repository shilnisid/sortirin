import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';
import 'package:sortirin/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Sign in with Google.
class SignInGoogleUseCase {
  final AuthRepository _repository;

  SignInGoogleUseCase(this._repository);

  Future<({ProfileEntity profile, bool isNewUser})> call() async {
    return _repository.signInWithGoogle();
  }
}
