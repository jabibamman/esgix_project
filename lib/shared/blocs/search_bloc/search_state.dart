import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<PostModel> results;

  SearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
