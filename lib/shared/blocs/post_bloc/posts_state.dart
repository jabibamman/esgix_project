part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class LikeToggled extends PostsState {
  final String postId;
  final bool isLiked;
  final int likeCount;

  LikeToggled({required this.postId, required this.isLiked, required this.likeCount});
}

class LikedUsersFetched extends PostsState {
  final String postId;
  final List<UserWhoLikedDto> likedUsers;

  LikedUsersFetched({required this.postId, required this.likedUsers});
}

class PostsError extends PostsState {
  final String error;

  PostsError(this.error);
}
