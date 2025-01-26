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
  final Map<String, TextEditingController> replyControllers = {};
  String? replyingToCommentId;

  @override
  void initState() {
    super.initState();
    post = postService.getPostById(widget.postId);
    comments = postService.getPosts(parentId: widget.postId);
  }

  Future<List<PostModel>> fetchReplies(String commentId) async {
    return await postService.getPosts(parentId: commentId);
  }

  Future<void> addComment(String content, {String? parentId}) async {
    try {
      await postService.createPost(content, parentId: parentId ?? widget.postId);
      setState(() {
        comments = postService.getPosts(parentId: widget.postId);
        if (parentId != null) {
          replyControllers[parentId]?.clear();
        } else {
          commentController.clear();
        }
        replyingToCommentId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout du commentaire : $e")),
      );
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    for (var controller in replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
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
            Text(post.author.username, style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
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
        final commentsList = snapshot.data ?? [];
        if (commentsList.isEmpty) {
          return const Text("Aucun commentaire pour le moment.");
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentsList.length,
          itemBuilder: (context, index) {
            final comment = commentsList[index];
            return _buildCommentWithReplies(comment);
          },
        );
      },
    );
  }

  Widget _buildCommentWithReplies(PostModel comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(comment.authorUsername, style: TextStyles.bodyText1),
          subtitle: Text(comment.content),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                replyingToCommentId = comment.id;
                if (!replyControllers.containsKey(comment.id)) {
                  replyControllers[comment.id] = TextEditingController();
                }
              });
            },
            child: const Text("Répondre"),
          ),
        ),
        if (replyingToCommentId == comment.id) _buildReplyInput(comment.id),
        FutureBuilder<List<PostModel>>(
          future: fetchReplies(comment.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            }
            final replies = snapshot.data ?? [];
            if (replies.isEmpty) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: replies
                    .map((reply) => ListTile(
                  title: Text(reply.authorUsername, style: TextStyles.bodyText2),
                  subtitle: Text(reply.content),
                ))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReplyInput(String parentId) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Column(
        children: [
          TextField(
            controller: replyControllers[parentId],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Écrire une réponse...",
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final content = replyControllers[parentId]?.text.trim();
                  if (content != null && content.isNotEmpty) {
                    addComment(content, parentId: parentId);
                  }
                },
                child: const Text("Publier"),
              ),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    replyingToCommentId = null;
                  });
                },
                child: const Text("Annuler"),
              ),
            ],
          ),
        ],
      ),
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
            }
          },
          child: const Text("Publier"),
        ),
      ],
    );
  }
}
