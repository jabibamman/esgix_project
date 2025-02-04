import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../models/post_model.dart';

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
  }

  void _toggleLike() {
    if (widget.post != null) {
      context.read<PostsBloc>().add(ToggleLikeEvent(widget.post!.id, likedByUser));
    }
  }

  void _postComment() {
    if (widget.post != null && _commentController.text.isNotEmpty) {
      // TODO: Gérer l'envoi du commentaire
      print("Commentaire envoyé : ${_commentController.text}");
      _commentController.clear();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
      body: Column(
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
          if (widget.post != null) _buildCommentField(),
        ],
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
          BlocListener<PostsBloc, PostsState>(
            listenWhen: (previous, current) =>
            current is LikeToggled && current.postId == widget.post!.id,
            listener: (context, state) {
              if (state is LikeToggled && state.postId == widget.post!.id) {
                setState(() {
                  likedByUser = state.isLiked;
                  likeCount = state.likeCount;
                });
              }
            },
            child: GestureDetector(
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

  Widget _buildCommentField() {
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
                hintText: "Post your reply",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _postComment(),
            ),
          ),
          GestureDetector(
            onTap: _postComment,
            child: const Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}