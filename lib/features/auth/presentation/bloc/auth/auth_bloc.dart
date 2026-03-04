import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/get_logged_in_user.dart';
import '../../../domain/usecases/logout_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final GetLoggedInUser getLoggedInUser;
  final LogoutUser logoutUser;

  AuthBloc({required this.loginUser, required this.getLoggedInUser, required this.logoutUser}) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      final success = await loginUser(event.username, event.password);
      if (success) {
        emit(AuthAuthenticated(event.username));
      } else {
        emit(AuthError("Password salah! (Hint: 12345)"));
      }
    });

    on<LoadCurrentUser>((event, emit) async {
      final user = await getLoggedInUser();
      if (user != null) {
        emit(AuthAuthenticated(user.username));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      await logoutUser();
      emit(AuthUnauthenticated());
    });
  }
}
