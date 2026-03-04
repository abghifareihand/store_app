part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  LoginSubmitted(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class LoadCurrentUser extends AuthEvent {}

class LogoutRequested extends AuthEvent {}