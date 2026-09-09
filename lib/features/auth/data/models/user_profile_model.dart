import 'package:memento/features/auth/domain/entities/user_profile.dart';

class UserProfileModel {
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile.fromJson(json);
  }

  static Map<String, dynamic> toJson(UserProfile profile) {
    return {
      'uid': profile.uid,
      'displayName': profile.displayName,
      'email': profile.email,
      'photoUrl': profile.photoUrl,
      'authProvider': profile.authProvider,
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
  }
}
