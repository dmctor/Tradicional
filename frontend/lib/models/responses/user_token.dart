import '../entities/admin.dart';

class UserToken {
  Admin admin;
  String token;

  UserToken({required this.admin, required this.token});

  @override
  String toString() {
    return 'UserToken{user: $admin, token: $token}';
  }
}
