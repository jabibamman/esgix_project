part of 'post_creation_bloc.dart';

abstract class PostCreationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleImageInput extends PostCreationEvent {}

class UpdateImageUrl extends PostCreationEvent {
  final String imageUrl;

  UpdateImageUrl(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class SubmitPost extends PostCreationEvent {
  final String content;
  final String? imageUrl;

  SubmitPost({required this.content, this.imageUrl});

  @override
  List<Object?> get props => [content, imageUrl];
}