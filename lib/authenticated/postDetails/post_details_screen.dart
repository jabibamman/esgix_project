import 'package:flutter/material.dart';
import '../../shared/models/post_model.dart';
import '../../shared/services/post_service.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<PostModel> post;
  late Future<List<PostModel>> comments;
  final PostService postService = PostService();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    post = postService.getPostById(widget.postId);
    comments = postService.getPosts(parentId: widget.postId);
  }

  Future<void> addComment(String content) async {
    try {

      await postService.createPost(content, parentId: widget.postId);
      setState(() {
        comments = postService.getPosts(parentId: widget.postId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de l'ajout du commentaire : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du post"),
      ),
      body: FutureBuilder<PostModel>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          final post = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostDetails(post),
                  const SizedBox(height: 16.0),
                  _buildCommentsSection(),
                  const SizedBox(height: 16.0),
                  _buildAddCommentSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostDetails(PostModel post) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.authorUsername, style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(post.content, style: TextStyles.bodyText1),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 8.0),
              Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: AppColors.lightGray,
                  child: Center(child: Icon(Icons.broken_image, color: AppColors.darkGray)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return FutureBuilder<List<PostModel>>(
      future: comments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        }
        final commentsList = snapshot.data!;
        if (commentsList.isEmpty) {
          return const Text("Aucun commentaire pour le moment.");
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentsList.length,
          itemBuilder: (context, index) {
            final comment = commentsList[index];
            return ListTile(
              title: Text(comment.authorUsername, style: TextStyles.bodyText1),
              subtitle: Text(comment.content),
            );
          },
        );
      },
    );
  }

  Widget _buildAddCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ajouter un commentaire :", style: TextStyle(fontSize: 16.0)),
        const SizedBox(height: 8.0),
        TextField(
          controller: commentController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Écrire un commentaire...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            final content = commentController.text.trim();
            if (content.isNotEmpty) {
              addComment(content);
              commentController.clear();
            }
          },
          child: const Text("Publier"),
        ),
      ],
    );
  }
}
