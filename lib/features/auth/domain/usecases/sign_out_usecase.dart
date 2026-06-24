import 'package:sortirin/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Sign out.
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() async {
    return _repository.signOut();
  }
}
