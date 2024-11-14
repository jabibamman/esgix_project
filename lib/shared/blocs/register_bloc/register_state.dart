import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterStep1 extends RegisterState {
  final bool passwordsMatch;

  RegisterStep1({this.passwordsMatch = true});

  @override
  List<Object?> get props => [passwordsMatch];
}

class RegisterStep2 extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

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