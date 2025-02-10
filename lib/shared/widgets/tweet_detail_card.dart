import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_bloc/home_bloc.dart';
import '../blocs/home_bloc/home_event.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../core/image_utils.dart';
import '../models/post_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../utils/date_utils.dart';
import 'liked_users_list.dart';

class TweetDetailCard extends StatefulWidget {
  final PostModel post;

  const TweetDetailCard({super.key, required this.post});

  @override
  _TweetDetailCardState createState() => _TweetDetailCardState();
}

class _TweetDetailCardState extends State<TweetDetailCard> {
  late bool likedByUser;
  late int likeCount;

  late String postContent;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    likedByUser = widget.post.likedByUser;
    likeCount = widget.post.likeCount;

    postContent = widget.post.content;
    _editController = TextEditingController(text: postContent);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostsBloc, PostsState>(
          listenWhen: (previous, current) =>
          current is LikeToggled && current.postId == widget.post.id,
          listener: (context, state) {
            if (state is LikeToggled) {
              setState(() {
                likedByUser = state.isLiked;
                likeCount = state.likeCount;
              });
            }
          },
        ),
        BlocListener<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is PostEdited) {
              setState(() {
                postContent = state.content;
                widget.post.content = state.content;
              });
              context.read<HomeBloc>().add(UpdatePostInList(widget.post));


              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Post modifié avec succès !")),
              );
            }
            else if (state is PostDeleted && state.postId == widget.post.id) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Post supprimé")),
              );
            }
          },
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12.0),
              _buildContent(),
              if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) ...[
                const SizedBox(height: 12.0),
                _buildImage(widget.post.imageUrl!),
              ],
              const SizedBox(height: 12.0),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile', arguments: widget.post.author.id);
          },
          child:  _buildAvatar(widget.post.author.avatar),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.author.username,
                style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                formatTwitterDate(widget.post.createdAt),
                style: TextStyles.bodyText2.copyWith(color: AppColors.darkGray),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptionsMenu(context),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      postContent,
      style: TextStyles.bodyText1,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInteractionIcon(Icons.comment, widget.post.commentCount),
        _buildInteractionIcon(Icons.repeat, 500),
        GestureDetector(
          onTap: () {
            context.read<PostsBloc>().add(ToggleLikeEvent(widget.post.id, likedByUser));
          },
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  likedByUser ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(likedByUser),
                  color: likedByUser ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(width: 4.0),
              Text('$likeCount'),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.people),
          onPressed: () {
            context.read<PostsBloc>().add(FetchLikedUsersEvent(widget.post.id));
            LikedUsersList.show(context, widget.post.id);
          },
        ),
        _buildInteractionIcon(Icons.share, null),
      ],
    );
  }

  Widget _buildInteractionIcon(IconData icon, int? count) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkGray),
        if (count != null) ...[
          const SizedBox(width: 4.0),
          Text('$count'),
        ],
      ],
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return buildImage(
      context: context,
      post: widget.post,
      imageUrl: avatarUrl,
      width: 50,
      height: 50,
      borderRadius: 25.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.person,
      disableActions: true,
      disableOpenDetail: true,
    );
  }

  Widget _buildImage(String imageUrl) {
    return buildImage(
      context: context,
      post: widget.post,
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      borderRadius: 12.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.broken_image,
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Modifier"),
            onTap: () {
              Navigator.pop(context);
              _showEditDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Supprimer"),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete();
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    _editController = TextEditingController(text: postContent);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le post"),
        content: TextField(
          controller: _editController,
          maxLines: 5,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = _editController.text;
              context.read<PostsBloc>().add(
                EditPostEvent(postId: widget.post.id, newContent: newText),
              );
              Navigator.pop(context);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le post"),
        content: const Text("Es-tu sûr de vouloir supprimer ce post ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PostsBloc>().add(DeletePostEvent(postId: widget.post.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }
}
