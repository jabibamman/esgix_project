import 'package:bloc/bloc.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../services/post_service.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostService postService;
  final UserService userService;
  final FlutterSecureStorage secureStorage;

  PostsBloc(this.postService, this.userService, this.secureStorage) : super(PostsInitial()) {
    on<ToggleLikeEvent>(_onToggleLike);
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
}
