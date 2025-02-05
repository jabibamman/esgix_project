import 'package:flutter/material.dart';
import '../services/post_service.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({Key? key}) : super(key: key);

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final PostService _postService = PostService();

  String? _imageUrl;
  bool _isSubmitting = false;
  bool isImageUrlInputVisible = false;

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le contenu du post ne peut pas être vide.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _postService.createPost(content, imageUrl: _imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post créé avec succès !")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création du post : $e")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _toggleImageInput() {
    setState(() {
      isImageUrlInputVisible = !isImageUrlInputVisible;
    });
  }

  void _confirmImageUrl() {
    setState(() {
      _imageUrl = _imageUrlController.text.trim();
      isImageUrlInputVisible = false;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Material(
        color: Colors.transparent,
        child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    hintText: "Quoi de neuf ?",
                    hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                  maxLines: 5,
                  onTap: () {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isImageUrlInputVisible
                        ? Expanded(
                      child: TextField(
                        controller: _imageUrlController,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                          hintText: "URL de l'image",
                          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        onSubmitted: (_) => _confirmImageUrl(),
                      ),
                    )
                        : IconButton(
                      onPressed: _toggleImageInput,
                      icon: Icon(Icons.image, color: colorScheme.primary),
                    ),
                    if (isImageUrlInputVisible)
                      TextButton(
                        onPressed: _confirmImageUrl,
                        child: Text(
                          "Valider",
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                  ],
                ),

                if (_imageUrl != null && _imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            "Impossible de charger l’image",
                            style: TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 16.0),

                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: colorScheme.onPrimary)
                      : const Text("Publier"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}