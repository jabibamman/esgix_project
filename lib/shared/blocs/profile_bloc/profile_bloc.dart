// profile_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../services/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;
  final int offset = 10;

  ProfileBloc({required this.userService}) : super( ProfileCompositeState()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<LoadMoreUserPosts>(_onLoadMoreUserPosts);
    on<FetchUserLikedPosts>(_onFetchUserLikedPosts);
    on<LoadMoreUserLikedPosts>(_onLoadMoreUserLikedPosts);
  }


  Future<void> _onFetchUserProfile(FetchUserProfile event, Emitter<ProfileState> emit) async {
    try {
      final user = await userService.getUserById(event.userId);
      final currentState = state is ProfileCompositeState ? state as ProfileCompositeState :  ProfileCompositeState();
      emit(currentState.copyWith(user: user));
    } catch (e) {
      emit(ProfileCompositeState(error: e.toString()));
    }
  }

  Future<void> _onFetchUserPosts(FetchUserPosts event, Emitter<ProfileState> emit) async {
    final currentState = state is ProfileCompositeState ? state as ProfileCompositeState :  ProfileCompositeState();
    emit(currentState.copyWith(loadingTweets: true));
    try {
      final posts = await userService.getUserPosts(event.userId, page: 0, offset: event.offset);
      final hasReachedMax = posts.length < event.offset;
      emit(currentState.copyWith(
        tweets: posts,
        tweetsPage: 0,
        tweetsHasReachedMax: hasReachedMax,
        loadingTweets: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(error: e.toString(), loadingTweets: false));
    }
  }

  Future<void> _onLoadMoreUserPosts(LoadMoreUserPosts event, Emitter<ProfileState> emit) async {
    final currentState = state is ProfileCompositeState ? state as ProfileCompositeState :  ProfileCompositeState();
    if (!currentState.tweetsHasReachedMax) {
      try {
        final nextPage = currentState.tweetsPage + 1;
        final newPosts = await userService.getUserPosts(event.userId, page: nextPage, offset: event.offset);
        if (newPosts.isEmpty) {
          emit(currentState.copyWith(tweetsHasReachedMax: true));
        } else {
          final allPosts = List<PostModel>.from(currentState.tweets)..addAll(newPosts);
          emit(currentState.copyWith(
            tweets: allPosts,
            tweetsPage: nextPage,
            tweetsHasReachedMax: newPosts.length < event.offset,
          ));
        }
      } catch (e) {
        emit(currentState.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _onFetchUserLikedPosts(FetchUserLikedPosts event, Emitter<ProfileState> emit) async {
    final currentState = state is ProfileCompositeState ? state as ProfileCompositeState : ProfileCompositeState();
    emit(currentState.copyWith(loadingLikedPosts: true));
    try {
      final posts = await userService.getUserLikedPosts(event.userId, page: 0, offset: event.offset);
      final hasReachedMax = posts.length < event.offset;
      emit(currentState.copyWith(
        likedPosts: posts,
        likedPostsPage: 0,
        likedPostsHasReachedMax: hasReachedMax,
        loadingLikedPosts: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(error: e.toString(), loadingLikedPosts: false));
    }
  }

  Future<void> _onLoadMoreUserLikedPosts(LoadMoreUserLikedPosts event, Emitter<ProfileState> emit) async {
    final currentState = state is ProfileCompositeState ? state as ProfileCompositeState :  ProfileCompositeState();
    if (!currentState.likedPostsHasReachedMax) {
      try {
        final nextPage = currentState.likedPostsPage + 1;
        final newPosts = await userService.getUserLikedPosts(event.userId, page: nextPage, offset: event.offset);
        if (newPosts.isEmpty) {
          emit(currentState.copyWith(likedPostsHasReachedMax: true));
        } else {
          final allPosts = List<PostModel>.from(currentState.likedPosts)..addAll(newPosts);
          emit(currentState.copyWith(
            likedPosts: allPosts,
            likedPostsPage: nextPage,
            likedPostsHasReachedMax: newPosts.length < event.offset,
          ));
        }
      } catch (e) {
        emit(currentState.copyWith(error: e.toString()));
      }
    }
  }
}
