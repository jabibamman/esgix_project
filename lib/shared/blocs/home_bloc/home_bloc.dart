import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostService postService;

  int currentPage = 0;
  final List<PostModel> allPosts = [];
  bool isLoadingMore = false;

  HomeBloc(this.postService) : super(HomeInitial()) {
    on<FetchPosts>((event, emit) async {

      isLoadingMore = true;
      //emit(HomeLoading()); // TODO fix for loading more
      try {
        final newPosts = await postService.getPosts(page: currentPage, offset: 5);
        if (newPosts.isNotEmpty) {
          currentPage++;
          allPosts.addAll(newPosts);
          emit(HomeLoaded(List.of(allPosts)));
        } else {
          emit(HomeLoaded(allPosts));
        }
      } catch (e) {
        emit(HomeError(e.toString()));
      } finally {
        isLoadingMore = false;
      }
    });

    on<RefreshPosts>((event, emit) async {
      currentPage = 0;
      allPosts.clear();
      try {
        final posts = await postService.getPosts(page: currentPage, offset: 10);
        currentPage++;
        allPosts.addAll(posts);
        emit(HomeLoaded(allPosts));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

  }
}
