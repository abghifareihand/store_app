import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> login(String username, String password);
  Future<User?> getLoggedInUser();
  Future<void> logout();
}