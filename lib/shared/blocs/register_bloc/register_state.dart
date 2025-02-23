import 'package:equatable/equatable.dart';
import 'package:esgix_project/shared/models/user_model.dart';

abstract class RegisterState extends Equatable {
  final String? email;
  final String? username;
  final String? password;
  final String? confirmPassword;
  final String? avatar;
  final String? description;
  final bool? emailValid;
  final String? passwordValid;

  const RegisterState({
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.avatar,
    this.description,
    this.emailValid,
    this.passwordValid,
  });

  @override
  List<Object?> get props => [email, username, password, confirmPassword, avatar, description];
}

class RegisterInitial extends RegisterState {}

class RegisterStep1 extends RegisterState {
  final bool passwordsMatch;

  const RegisterStep1({
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    this.passwordsMatch = true, 
    bool? emailValid,
    String? passwordValid,
  }) : super(
    email: email,
    username: username,
    password: password,
    confirmPassword: confirmPassword,
    emailValid: emailValid,
    passwordValid: passwordValid,
  );

  @override
  List<Object?> get props => super.props..add(passwordsMatch);
}

class RegisterStep2 extends RegisterState {
  const RegisterStep2({
    String? email,
    String? username,
    String? password,
    String? avatar,
    String? description,
  }) : super(
    email: email,
    username: username,
    password: password,
    avatar: avatar,
    description: description,
  );
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserModel user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RegisterFormState extends RegisterState {
  final String? avatarPreviewUrl;
  final String? avatarError;

  RegisterFormState({this.avatarPreviewUrl, this.avatarError});
}

class PasswordMatchState extends RegisterState {}
class PasswordMismatchState extends RegisterState {}