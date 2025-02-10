import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/post_detail/post_detail_bloc.dart';
import '../../shared/models/post_model.dart';
import '../../shared/widgets/tweet_card.dart';
import '../../shared/widgets/tweet_detail_card.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel? post;

  const PostDetailScreen({Key? key, this.post}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final postId = widget.post?.id ??
        (ModalRoute.of(context)?.settings.arguments as String? ?? '');
      context.read<PostDetailBloc>().add(LoadPostDetail(postId: postId, post: widget.post));
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final content = commentController.text.trim();
    if (content.isNotEmpty) {
      context.read<PostDetailBloc>().add(CreateComment(content: content));
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailBloc>.value(
      value: context.read<PostDetailBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détails du post"),
        ),
        body: BlocConsumer<PostDetailBloc, PostDetailState>(
          listener: (context, state) {
            if (state is PostDetailLoaded && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur : ${state.errorMessage}")),
              );
            }
          },
          builder: (context, state) {
            if (state is PostDetailLoading || state is PostDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostDetailError) {
              return Center(child: Text("Erreur : ${state.error}"));
            } else if (state is PostDetailLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweetDetailCard(post: state.post),
                      const SizedBox(height: 16.0),
                      _buildCommentsSection(state.comments),
                      const SizedBox(height: 16.0),
                      _buildAddCommentSection(state.creatingComment),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCommentsSection(List<PostModel> comments) {
    if (comments.isEmpty) {
      return const Text("Aucun commentaire pour le moment.");
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return TweetCard(post: comment);
      },
    );
  }

  Widget _buildAddCommentSection(bool creatingComment) {
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
        creatingComment
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _submitComment,
          child: const Text("Publier"),
        ),
      ],
    );
  }
}