import 'package:bloc/bloc.dart';
import 'package:esgix_project/shared/blocs/profile_bloc/profile_event.dart';
import 'package:esgix_project/shared/blocs/profile_bloc/profile_state.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;
  final int offset = 10;
  UserModel? currentUser;

  ProfileBloc({required this.userService}) : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<LoadMoreUserPosts>(_onLoadMoreUserPosts);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await userService.getUserById(event.userId);
      currentUser = user;
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onFetchUserPosts(
      FetchUserPosts event, Emitter<ProfileState> emit) async {
    emit(ProfilePostsLoading());
    try {
      final posts = await userService.getUserPosts(event.userId, page: 0, offset: event.offset);
      final hasReachedMax = posts.length < event.offset;

      emit(ProfilePostsLoaded(posts: posts, page: 0, hasReachedMax: hasReachedMax));

      if (currentUser != null) {
        emit(ProfileLoaded(currentUser!));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUserPosts(
      LoadMoreUserPosts event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is ProfilePostsLoaded && !currentState.hasReachedMax) {
      try {
        final nextPage = currentState.page + 1;
        final newPosts = await userService.getUserPosts(event.userId, page: nextPage, offset: event.offset);

        if (newPosts.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          final allPosts = List<PostModel>.from(currentState.posts)..addAll(newPosts);
          emit(ProfilePostsLoaded(posts: allPosts, page: nextPage, hasReachedMax: newPosts.length < event.offset));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}