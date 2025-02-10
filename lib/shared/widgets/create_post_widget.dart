import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_creation_bloc/post_creation_bloc.dart';

class CreatePostWidget extends StatelessWidget {
  CreatePostWidget({Key? key}) : super(key: key);

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bloc = context.read<PostCreationBloc>();

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Material(
        color: Colors.transparent,
        child: BlocConsumer<PostCreationBloc, PostCreationState>(
          listener: (context, state) {
            if (state is PostCreationSuccess) {
              Navigator.pop(context, true);
            } else if (state is PostCreationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is PostCreationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final imageUrl = (state is PostCreationForm) ? state.imageUrl : null;
            final isImageUrlInputVisible = (state is PostCreationForm) ? state.isImageUrlInputVisible : false;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: "Quoi de neuf ?",
                      filled: true,
                      fillColor: colorScheme.background,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isImageUrlInputVisible
                          ? Expanded(
                        child: TextField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(hintText: "URL de l'image"),
                          onSubmitted: (_) => bloc.add(UpdateImageUrl(_imageUrlController.text.trim())),
                        ),
                      )
                          : IconButton(
                        onPressed: () => bloc.add(ToggleImageInput()),
                        icon: const Icon(Icons.image),
                      ),
                      if (isImageUrlInputVisible)
                        TextButton(
                          onPressed: () => bloc.add(UpdateImageUrl(_imageUrlController.text.trim())),
                          child: const Text("Valider"),
                        ),
                    ],
                  ),

                  if (imageUrl != null && imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                    ),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () => bloc.add(SubmitPost(content: _contentController.text, imageUrl: imageUrl)),
                    child: const Text("Publier"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}