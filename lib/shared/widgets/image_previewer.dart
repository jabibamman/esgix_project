import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../../shared/blocs/post_detail/post_detail_bloc.dart';
import '../../shared/models/post_model.dart';

class ImagePreviewer extends StatefulWidget {
  final String imageUrl;
  final PostModel? post;

  const ImagePreviewer({
    Key? key,
    required this.imageUrl,
    this.post,
  }) : super(key: key);

  @override
  _ImagePreviewerState createState() => _ImagePreviewerState();
}

class _ImagePreviewerState extends State<ImagePreviewer> {
  late bool likedByUser;
  late int likeCount;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likedByUser = widget.post?.likedByUser ?? false;
    likeCount = widget.post?.likeCount ?? 0;

    final post = widget.post;
    if (post != null) {
      context.read<PostDetailBloc>().add(LoadPostDetail(postId: post.id, post: post));
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    if (widget.post != null) {
      context
          .read<PostsBloc>()
          .add(ToggleLikeEvent(widget.post!.id, likedByUser));
    }
  }

  void _postComment() {
    if (widget.post == null) return;
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      context
          .read<PostDetailBloc>()
          .add(CreateComment(content: content, parentId: widget.post!.id));

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<PostDetailBloc, PostDetailState>(
        listener: (context, state) {
          final postsState = context.read<PostsBloc>().state;
          if (postsState is LikeToggled && widget.post != null) {
            if (postsState.postId == widget.post!.id) {
              setState(() {
                likedByUser = postsState.isLiked;
                likeCount = postsState.likeCount;
              });
            }
          }

          if (state is PostDetailLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur : ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          final List<PostModel> comments = (state is PostDetailLoaded)
              ? List<PostModel>.from(state.comments)
              : [];
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              if (widget.post != null) _buildActionBar(),
              if (widget.post != null) _buildCommentsList(comments),
              if (widget.post != null) _buildCommentField(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: _toggleLike,
            child: Row(
              children: [
                Icon(
                  likedByUser ? Icons.favorite : Icons.favorite_border,
                  color: likedByUser ? Colors.red : Colors.white,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '$likeCount',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              // TODO: Statistiques sur le post
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Partage du post
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(List<PostModel> comments) {
    return Container(
      color: Colors.black,
      height: 200,
      child: comments.isEmpty
          ? const Center(
        child: Text(
          'Aucun commentaire.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            title: Text(
              comment.author.username,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              comment.content ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentField(PostDetailState state) {
    final isLoading = (state is PostDetailLoaded) ? state.creatingComment : false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Ajouter un commentaire...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _postComment(),
            ),
          ),
          if (isLoading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            GestureDetector(
              onTap: _postComment,
              child: const Icon(Icons.send, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}