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

class EditPostEvent extends PostsEvent {
  final String postId;
  final String newContent;

  EditPostEvent({required this.postId, required this.newContent});
}

class DeletePostEvent extends PostsEvent {
  final String postId;

  DeletePostEvent({required this.postId});
}
