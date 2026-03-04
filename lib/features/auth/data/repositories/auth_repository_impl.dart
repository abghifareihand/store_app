import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<bool> login(String username, String password) async {
    // Sesuai requirement: password wajib 12345
    if (password == '12345' && username.isNotEmpty) {
      await localDataSource.saveUsername(username);
      return true;
    }
    return false;
  }

  @override
  Future<User?> getLoggedInUser() async {
    final username = await localDataSource.getUsername();
    if (username != null) return User(username: username);
    return null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearSession();
  }
}
