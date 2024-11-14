import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String? avatar;

  const RegisterRequested(this.email, this.password, this.username, [this.avatar]);

  @override
  List<Object?> get props => [email, password, username, avatar];
}


class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthenticationStatus extends AuthEvent {
  const CheckAuthenticationStatus();
}
