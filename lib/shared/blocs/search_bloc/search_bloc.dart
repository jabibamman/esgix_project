import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostService postService;

  SearchBloc(this.postService) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final results = await postService.searchPosts(query: event.query);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}
