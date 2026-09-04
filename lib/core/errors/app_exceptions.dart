abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException(message: $message, code: $code, details: $details)';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});
}

class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code, super.details});
}

class AuthenticationException extends AppException {
  AuthenticationException(super.message, {super.code, super.details});
}

class StorageException extends AppException {
  StorageException(super.message, {super.code, super.details});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.details});
}

class SyncException extends AppException {
  SyncException(super.message, {super.code, super.details});
}

class PermissionException extends AppException {
  PermissionException(super.message, {super.code, super.details});
}
