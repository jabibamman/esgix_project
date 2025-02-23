import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterNextStep extends RegisterEvent {}

class SubmitRegistration extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final String avatar;
  final String description;

  const SubmitRegistration({
    required this.email,
    required this.password,
    required this.username,
    required this.avatar,
    required this.description,
  });

  @override
  List<Object?> get props => [email, password, username, avatar, description];
}

class AvatarUrlChanged extends RegisterEvent {
  final String avatarUrl;
  const AvatarUrlChanged(this.avatarUrl);
}

class PasswordChanged extends RegisterEvent {
  final String password;
  final String confirmPassword;

  const PasswordChanged(this.password, this.confirmPassword);
}

class UsernameChanged extends RegisterEvent {
  final String username;
  const UsernameChanged(this.username);
}

class RegisterPreviousStep extends RegisterEvent {}

class EmailChanged extends RegisterEvent  {
  final String email;
  const EmailChanged(this.email, String text);
}