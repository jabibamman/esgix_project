import 'package:equatable/equatable.dart';

import '../../models/post_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PostModel> posts;

  HomeLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

