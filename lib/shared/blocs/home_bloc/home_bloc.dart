import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostService postService;

  int currentPage = 0;
  final List<PostModel> allPosts = [];
  bool hasReachedMax = false;
  bool isFetching = false;

  HomeBloc(this.postService) : super(HomeInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<UpdatePostInList>(_onUpdatePostInList);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<HomeState> emit) async {
    if (isFetching || hasReachedMax) return;
    isFetching = true;
    try {
      if (state is HomeInitial) {
        emit(HomeLoading());
      }
      final newPosts = await postService.getPosts(page: currentPage, offset: event.offset);
      if (newPosts.isEmpty) {
        hasReachedMax = true;
      } else {
        currentPage++;
        allPosts.addAll(newPosts);
      }
      emit(HomeLoaded(List<PostModel>.from(allPosts)));
    } catch (e) {
      emit(HomeError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onRefreshPosts(RefreshPosts event, Emitter<HomeState> emit) async {
    try {
      currentPage = 0;
      allPosts.clear();
      hasReachedMax = false;
      final posts = await postService.getPosts(page: currentPage, offset: 10);
      if (posts.isNotEmpty) {
        currentPage++;
        allPosts.addAll(posts);
      }
      emit(HomeLoaded(List<PostModel>.from(allPosts)));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onUpdatePostInList(UpdatePostInList event, Emitter<HomeState> emit) async {
    final index = allPosts.indexWhere((p) => p.id == event.updatedPost.id);
    if (index != -1) {
      allPosts[index] = event.updatedPost;
      emit(HomeLoaded(List<PostModel>.from(allPosts)));
    }
  }
}
