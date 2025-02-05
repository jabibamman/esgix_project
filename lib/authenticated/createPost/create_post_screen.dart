import 'package:flutter/material.dart';
import '../../shared/services/post_service.dart';
import '../../theme/colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final PostService _postService = PostService();
  String? _imageUrl;
  bool _isSubmitting = false;

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
      Navigator.pop(context);
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

  void _selectImage() async {
    // TODO
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sélection d'image à implémenter.")),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Quoi de neuf ?",
                hintText: "Entrez le contenu de votre post...",
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Ajouter une image"),
                ),
                if (_imageUrl != null)
                  const Text(
                    "Image ajoutée",
                    style: TextStyle(color: AppColors.success),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Publier"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


