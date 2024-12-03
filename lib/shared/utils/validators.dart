import 'constants.dart';

bool validateEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return kInvalidPasswordError;
  }
  if (value.length < 6) {
    return kPasswordLengthError;
  }
  return null;
}