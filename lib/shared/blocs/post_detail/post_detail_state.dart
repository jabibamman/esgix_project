part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final PostModel post;
  final List<PostModel> comments;
  final bool creatingComment;
  final String? errorMessage;

  PostDetailLoaded({
    required this.post,
    required this.comments,
    this.creatingComment = false,
    this.errorMessage,
  });

  PostDetailLoaded copyWith({
    PostModel? post,
    List<PostModel>? comments,
    bool? creatingComment,
    String? errorMessage,
  }) {
    return PostDetailLoaded(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      creatingComment: creatingComment ?? this.creatingComment,
      errorMessage: errorMessage,
    );
  }
}

class PostDetailError extends PostDetailState {
  final String error;
  PostDetailError(this.error);
}