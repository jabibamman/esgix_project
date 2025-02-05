import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostService postService;

  PostDetailBloc({required this.postService}) : super(PostDetailInitial()) {
    on<LoadPostDetail>(_onLoadPostDetail);
    on<CreateComment>(_onCreateComment);
  }

  Future<void> _onLoadPostDetail(
      LoadPostDetail event, Emitter<PostDetailState> emit) async {
    emit(PostDetailLoading());
    try {
      PostModel post;
      if (event.post != null) {
        post = event.post!;
      } else {
        post = await postService.getPostById(event.postId);
      }
      final comments = await postService.getPosts(parentId: post.id);
      emit(PostDetailLoaded(post: post, comments: comments));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }

  Future<void> _onCreateComment(
      CreateComment event, Emitter<PostDetailState> emit) async {
    final currentState = state;
    if (currentState is PostDetailLoaded) {
      emit(currentState.copyWith(creatingComment: true, errorMessage: null));
      try {
        final parentId = event.parentId ?? currentState.post.id;
        await postService.createPost(event.content, parentId: parentId);
        final updatedComments =
        await postService.getPosts(parentId: currentState.post.id);
        emit(currentState.copyWith(
            comments: updatedComments, creatingComment: false));
      } catch (e) {
        emit(currentState.copyWith(
            creatingComment: false, errorMessage: e.toString()));
      }
    }
  }
}