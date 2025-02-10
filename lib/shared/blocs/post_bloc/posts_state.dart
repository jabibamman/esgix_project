part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  get error => message;
}

class LikeToggled extends PostsState {
  final String postId;
  final bool isLiked;
  final int likeCount;

  LikeToggled({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
  });
}

class LikedUsersFetched extends PostsState {
  final String postId;
  final List<UserWhoLikedDto> likedUsers;

  LikedUsersFetched({required this.postId, required this.likedUsers});
}

class PostEdited extends PostsState {
  final String content;
  PostEdited({required this.content});
}

class PostDeleted extends PostsState {
  final String postId;
  PostDeleted({required this.postId});
}
