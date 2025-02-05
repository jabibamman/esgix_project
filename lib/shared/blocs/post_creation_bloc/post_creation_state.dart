part of 'post_creation_bloc.dart';

abstract class PostCreationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostCreationInitial extends PostCreationState {}

class PostCreationForm extends PostCreationState {
  final String? imageUrl;
  final bool isImageUrlInputVisible;

  PostCreationForm({this.imageUrl, this.isImageUrlInputVisible = false});

  PostCreationForm copyWith({String? imageUrl, bool? isImageUrlInputVisible}) {
    return PostCreationForm(
      imageUrl: imageUrl ?? this.imageUrl,
      isImageUrlInputVisible: isImageUrlInputVisible ?? this.isImageUrlInputVisible,
    );
  }

  @override
  List<Object?> get props => [imageUrl, isImageUrlInputVisible];
}

class PostCreationLoading extends PostCreationState {}

class PostCreationSuccess extends PostCreationState {}

class PostCreationError extends PostCreationState {
  final String message;

  PostCreationError(this.message);

  @override
  List<Object?> get props => [message];
}