part of 'post_actions_bloc.dart';

abstract class PostActionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostActionsInitial extends PostActionsState {}

class PostDeleting extends PostActionsState {}

class PostDeleted extends PostActionsState {
  final String postId;

  PostDeleted({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class PostEditing extends PostActionsState {}

class PostEdited extends PostActionsState {
  final PostModel post;

  PostEdited({required this.post});

  @override
  List<Object?> get props => [post];
}

class PostActionsError extends PostActionsState {
  final String message;

  PostActionsError(this.message);

  @override
  List<Object?> get props => [message];
}
