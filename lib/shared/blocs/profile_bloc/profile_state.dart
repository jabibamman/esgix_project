import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfilePostsLoading extends ProfileState {}

class ProfilePostsLoaded extends ProfileState {
  final List<PostModel> posts;
  final int page;
  final bool hasReachedMax;

  ProfilePostsLoaded({required this.posts, required this.page, required this.hasReachedMax});

  @override
  List<Object?> get props => [posts, page, hasReachedMax];

  ProfilePostsLoaded copyWith({List<PostModel>? posts, int? page, bool? hasReachedMax}) {
    return ProfilePostsLoaded(
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ProfilePostsError extends ProfileState {
  final String message;

  ProfilePostsError(this.message);

  @override
  List<Object?> get props => [message];
}