class LoginException implements Exception {
  final String message;
  LoginException(this.message);

  @override
  String toString() => 'LoginException: $message';
}

class RegistrationException implements Exception {
  final String message;
  RegistrationException(this.message);

  @override
  String toString() => 'RegistrationException: $message';
}

class ProfileFetchException implements Exception {
  final String message;
  ProfileFetchException(this.message);

  @override
  String toString() => 'ProfileFetchException: $message';
}

class LogoutException implements Exception {
  final String message;
  LogoutException(this.message);

  @override
  String toString() => 'LogoutException: $message';
}