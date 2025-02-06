import 'package:bloc/bloc.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:meta/meta.dart';

import '../../dto/UserWhoLikedDto.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostService postService;
  final UserService userService;

  PostsBloc(this.postService, this.userService) : super(PostsInitial()) {
    on<ToggleLikeEvent>(_onToggleLike);
    on<FetchLikedUsersEvent>(_onFetchLikedUsers);

    on<EditPostEvent>(_onEditPost);
    on<DeletePostEvent>(_onDeletePost);
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

  Future<void> _onEditPost(EditPostEvent event, Emitter<PostsState> emit) async {
    try {
      final updatedPost = await postService.updatePost(
        event.postId,
        event.newContent,
      );
      emit(PostEdited(content: updatedPost));
    } catch (e) {
      emit(PostsError("Erreur lors de la mise à jour du post : $e"));
    }
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<PostsState> emit) async {
    try {
      await postService.deletePost(event.postId);
      emit(PostDeleted(postId: event.postId));
    } catch (e) {
      emit(PostsError("Erreur lors de la suppression du post : $e"));
    }
  }
}
