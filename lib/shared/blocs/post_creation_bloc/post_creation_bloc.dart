import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/post_service.dart';

part 'post_creation_event.dart';
part 'post_creation_state.dart';

class PostCreationBloc extends Bloc<PostCreationEvent, PostCreationState> {
  final PostService postService;

  PostCreationBloc({required this.postService}) : super(PostCreationInitial()) {
    on<ToggleImageInput>(_onToggleImageInput);
    on<UpdateImageUrl>(_onUpdateImageUrl);
    on<SubmitPost>(_onSubmitPost);
  }

  void _onToggleImageInput(ToggleImageInput event, Emitter<PostCreationState> emit) {
    if (state is PostCreationForm) {
      final currentState = state as PostCreationForm;
      emit(currentState.copyWith(isImageUrlInputVisible: !currentState.isImageUrlInputVisible));
    }
  }

  void _onUpdateImageUrl(UpdateImageUrl event, Emitter<PostCreationState> emit) {
    if (state is PostCreationForm) {
      final currentState = state as PostCreationForm;
      emit(currentState.copyWith(imageUrl: event.imageUrl, isImageUrlInputVisible: false));
    }
  }

  Future<void> _onSubmitPost(SubmitPost event, Emitter<PostCreationState> emit) async {
    if (event.content.trim().isEmpty) {
      emit(PostCreationError("Le contenu du post ne peut pas être vide."));
      return;
    }

    emit(PostCreationLoading());

    try {
      await postService.createPost(event.content, imageUrl: event.imageUrl);
      emit(PostCreationSuccess());
    } catch (e) {
      emit(PostCreationError("Erreur lors de la création du post : $e"));
    }
  }
}