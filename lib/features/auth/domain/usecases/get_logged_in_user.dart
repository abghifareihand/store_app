import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetLoggedInUser {
  final AuthRepository repository;
  GetLoggedInUser(this.repository);

  Future<User?> call() async {
    return await repository.getLoggedInUser();
  }
}