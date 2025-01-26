part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class ToggleLikeEvent extends PostsEvent {
  final String postId;

  ToggleLikeEvent(this.postId);
}