import 'package:equatable/equatable.dart';

import '../../models/post_model.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends HomeEvent {
  final int page;
  final int offset;

  FetchPosts({this.page = 1, this.offset = 10});

  @override
  List<Object?> get props => [page, offset];
}

class RefreshPosts extends HomeEvent {}

class UpdatePostInList extends HomeEvent {
  final PostModel updatedPost;
  UpdatePostInList(this.updatedPost);
}
