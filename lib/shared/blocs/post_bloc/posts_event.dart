part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class ToggleLikeEvent extends PostsEvent {
  final String postId;
  final bool isLiked;

  ToggleLikeEvent(this.postId, this.isLiked);
}

class FetchLikedUsersEvent extends PostsEvent {
  final String postId;

  FetchLikedUsersEvent(this.postId);
}

