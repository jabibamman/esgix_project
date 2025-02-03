import '../../models/post_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<PostModel> results;
  final String query;
  final int page;
  final bool hasReachedMax;

  SearchLoaded({
    required this.results,
    required this.query,
    required this.page,
    required this.hasReachedMax,
  });

  SearchLoaded copyWith({
    List<PostModel>? results,
    String? query,
    int? page,
    bool? hasReachedMax,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
