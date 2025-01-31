import 'package:flutter/material.dart';
import '../../shared/models/post_model.dart';
import '../../shared/services/post_service.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../shared/widgets/tweet_card.dart';
import '../../shared/widgets/tweet_detail_card.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel? post;

  const PostDetailScreen({super.key, this.post});

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
    if (widget.post != null) {
      post = Future.value(widget.post);
    } else {
      final postId = ModalRoute.of(context)!.settings.arguments as String;
      post = postService.getPostById(postId);
    }

    comments = post.then((p) => postService.getPosts(parentId: p.id));
  }

  Future<List<PostModel>> fetchReplies(String commentId) async {
    return await postService.getPosts(parentId: commentId);
  }

  Future<void> addComment(String content, {String? parentId}) async {
    try {
      final postModel = await post;
      await postService.createPost(content, parentId: parentId ?? postModel.id);
      setState(() {
        comments = postService.getPosts(parentId: postModel.id);
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
          final postModel = widget.post ?? snapshot.data;

          if (postModel == null && snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (postModel == null) {
            return Center(child: Text("Erreur : Impossible de charger le post."));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweetDetailCard(post: postModel), // ⬅️ On affiche directement le post
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
    return TweetDetailCard(post: post);
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
            return TweetCard(post: comment);
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
          title: Text(comment.author.username, style: TextStyles.bodyText1),
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
                  title: Text(reply.author.username, style: TextStyles.bodyText2),
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
