part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailEvent {}

class LoadPostDetail extends PostDetailEvent {
  final String postId;
  final PostModel? post;
  LoadPostDetail({required this.postId, this.post});
}

class CreateComment extends PostDetailEvent {
  final String content;
  final String? parentId;
  CreateComment({required this.content, this.parentId});
}