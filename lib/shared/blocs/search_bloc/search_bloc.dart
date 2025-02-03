import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/post_service.dart';
import 'search_event.dart';
import 'search_state.dart';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostService postService;


  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  SearchBloc(this.postService) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final results = await postService.searchPosts(query: event.query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}

