class PostCreationException implements Exception {
  final String message;
  PostCreationException(this.message);

  @override
  String toString() => 'PostCreationException: $message';
}

class PostFetchException implements Exception {
  final String message;
  PostFetchException(this.message);

  @override
  String toString() => 'PostFetchException: $message';
}

class PostUpdateException implements Exception {
  final String message;
  PostUpdateException(this.message);

  @override
  String toString() => 'PostUpdateException: $message';
}

class PostDeletionException implements Exception {
  final String message;
  PostDeletionException(this.message);

  @override
  String toString() => 'PostDeletionException: $message';
}

class PostSearchException implements Exception {
  final String message;
  PostSearchException(this.message);

  @override
  String toString() => 'PostSearchException: $message';
}

class PostLikeException implements Exception {
  final String message;
  PostLikeException(this.message);

  @override
  String toString() => 'PostLikeException: $message';
}
