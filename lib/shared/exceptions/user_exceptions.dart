class ProfileFetchException implements Exception {
  final String message;
  ProfileFetchException(this.message);

  @override
  String toString() => 'ProfileFetchException: $message';
}

class ProfileUpdateException implements Exception {
  final String message;
  ProfileUpdateException(this.message);

  @override
  String toString() => 'ProfileUpdateException: $message';
}

class UserFetchException implements Exception {
  final String message;
  UserFetchException(this.message);

  @override
  String toString() => 'UserFetchException: $message';
}

class UserPostsFetchException implements Exception {
  final String message;
  UserPostsFetchException(this.message);

  @override
  String toString() => 'UserPostsFetchException: $message';
}

class UserLikedPostsFetchException implements Exception {
  final String message;
  UserLikedPostsFetchException(this.message);

  @override
  String toString() => 'UserLikedPostsFetchException: $message';
}

class UsersWhoLikedPostFetchException implements Exception {
  final String message;
  UsersWhoLikedPostFetchException(this.message);

  @override
  String toString() => 'UsersWhoLikedPostFetchException: $message';
}
