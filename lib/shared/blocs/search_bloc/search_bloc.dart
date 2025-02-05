import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import '../../utils/debounce.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostService postService;
  final int offset = 10;

  SearchBloc(this.postService) : super(SearchInitial()) {
    on<SearchLoadMore>(_onSearchLoadMore);

    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final results = await postService.searchPosts(
        query: event.query,
        page: 0,
        offset: offset,
      );
      final hasReachedMax = results.length < offset;
      emit(SearchLoaded(
        results: results,
        query: event.query,
        page: 0,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchLoadMore(
      SearchLoadMore event, Emitter<SearchState> emit) async {
    final currentState = state;
    if (currentState is SearchLoaded && !currentState.hasReachedMax) {
      try {
        final nextPage = currentState.page + 1;
        final results = await postService.searchPosts(
          query: currentState.query,
          page: nextPage,
          offset: offset,
        );

        if (results.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          final allResults = List<PostModel>.from(currentState.results)
            ..addAll(results);
          final hasReachedMax = results.length < offset;
          emit(SearchLoaded(
            results: allResults,
            query: currentState.query,
            page: nextPage,
            hasReachedMax: hasReachedMax,
          ));
        }
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }
}
