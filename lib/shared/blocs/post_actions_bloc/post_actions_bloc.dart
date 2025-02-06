import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';

part 'post_actions_event.dart';
part 'post_actions_state.dart';

class PostActionsBloc extends Bloc<PostActionsEvent, PostActionsState> {
  final PostService postService;

  PostActionsBloc({required this.postService}) : super(PostActionsInitial()) {
    on<DeletePostEvent>(_onDeletePost);
    on<EditPostEvent>(_onEditPost);
  }

  Future<void> _onDeletePost(DeletePostEvent event, Emitter<PostActionsState> emit) async {
    emit(PostDeleting());
    try {
      await postService.deletePost(event.postId);
      emit(PostDeleted(postId: event.postId));
    } catch (e) {
      emit(PostActionsError("Erreur lors de la suppression : $e"));
    }
  }

  Future<void> _onEditPost(EditPostEvent event, Emitter<PostActionsState> emit) async {
    emit(PostEditing());
    try {
      final updatedPost = await postService.updatePost(event.postId, event.newContent);
      emit(PostEdited(post: updatedPost));
    } catch (e) {
      emit(PostActionsError("Erreur lors de la mise à jour du post : $e"));
    }
  }
}
