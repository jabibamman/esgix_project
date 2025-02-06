part of 'post_actions_bloc.dart';

abstract class PostActionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeletePostEvent extends PostActionsEvent {
  final String postId;

  DeletePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class EditPostEvent extends PostActionsEvent {
  final String postId;
  final String newContent;

  EditPostEvent({required this.postId, required this.newContent});

  @override
  List<Object?> get props => [postId, newContent];
}
