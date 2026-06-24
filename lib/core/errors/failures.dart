import 'package:sortirin/core/errors/exceptions.dart';

/// Application failures (UI-facing error wrappers).
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromException(ServerException e) =>
      ServerFailure(e.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  factory CacheFailure.fromException(CacheException e) =>
      CacheFailure(e.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  factory NetworkFailure.fromException(NetworkException e) =>
      NetworkFailure(e.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);

  factory AuthFailure.fromException(AuthException e) =>
      AuthFailure(e.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);

  factory ValidationFailure.fromException(ValidationException e) =>
      ValidationFailure(e.message);
}

class CameraFailure extends Failure {
  const CameraFailure(super.message);

  factory CameraFailure.fromException(CameraException e) =>
      CameraFailure(e.message);
}

class UploadFailure extends Failure {
  const UploadFailure(super.message);

  factory UploadFailure.fromException(UploadException e) =>
      UploadFailure(e.message);
}
