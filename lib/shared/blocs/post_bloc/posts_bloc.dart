import 'package:bloc/bloc.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:meta/meta.dart';

import '../../dto/UserWhoLikedDto.dart';
import '../../services/post_service.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostService postService;
  final UserService userService;

  PostsBloc(this.postService, this.userService) : super(PostsInitial()) {
    on<ToggleLikeEvent>(_onToggleLike);
    on<FetchLikedUsersEvent>(_onFetchLikedUsers);
  }

  Future<void> _onToggleLike(ToggleLikeEvent event, Emitter<PostsState> emit) async {
    try {
      await postService.likePost(event.postId);
      final post = await postService.getPostById(event.postId);
      emit(LikeToggled(
        postId: event.postId,
        isLiked: post.likedByUser,
        likeCount: post.likeCount,
      ));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onFetchLikedUsers(FetchLikedUsersEvent event, Emitter<PostsState> emit) async {
    try {
      final users = await userService.getUsersWhoLikedPost(event.postId);
      emit(LikedUsersFetched(postId: event.postId, likedUsers: users));
    } catch (e) {
      emit(PostsError("Erreur lors de la récupération des likes"));
    }
  }
}
