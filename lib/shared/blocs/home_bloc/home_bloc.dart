import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/post_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostService postService;

  HomeBloc(this.postService) : super(HomeInitial()) {
    on<FetchPosts>((event, emit) async {
      emit(HomeLoading());
      try {
        final posts = await postService.getPosts(page: event.page, offset: event.offset);
        emit(HomeLoaded(posts));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<RefreshPosts>((event, emit) async {
      try {
        final posts = await postService.getPosts(page: 0, offset: 10);
        emit(HomeLoaded(posts));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
