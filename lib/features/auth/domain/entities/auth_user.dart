import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    required bool emailVerified,
    required String authProvider,
  }) = _AuthUser;
}
