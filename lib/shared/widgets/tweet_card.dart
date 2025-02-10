import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../core/image_utils.dart';
import '../models/post_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'package:esgix_project/shared/utils/date_utils.dart';

import 'liked_users_list.dart';

class TweetCard extends StatefulWidget {
  final PostModel post;

  const TweetCard({super.key, required this.post});

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  late bool likedByUser;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likedByUser = widget.post.likedByUser;
    likeCount = widget.post.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/post',
        arguments: widget.post,
      ),
      child: BlocListener<PostsBloc, PostsState>(
        listenWhen: (previous, current) =>
        current is LikeToggled && current.postId == widget.post.id,
        listener: (context, state) {
          if (state is LikeToggled && state.postId == widget.post.id) {
            setState(() {
              likedByUser = state.isLiked;
              likeCount = state.likeCount;
            });
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context, widget.post.author.avatar, widget.post.author.id),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 4.0),
                      _buildContent(),
                      if (widget.post.imageUrl?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 8.0),
                        _buildImage(widget.post.imageUrl!),
                      ],
                      const SizedBox(height: 8.0),
                      _buildActions(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.post.author.username,
          style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          formatTwitterDate(widget.post.createdAt),
          style: TextStyles.bodyText2.copyWith(color: AppColors.darkGray),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.post.content,
      style: TextStyles.bodyText1,
    );
  }

  Widget _buildActions(BuildContext context) {
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
              Icon(
                likedByUser ? Icons.favorite : Icons.favorite_border,
                color: likedByUser ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 4.0),
              Text('$likeCount'),
            ],
          ),
        ),
        _buildLikeButton(context),
        _buildInteractionIcon(Icons.share, null),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PostsBloc>().add(FetchLikedUsersEvent(widget.post.id));
        LikedUsersList.show(context, widget.post.id);
      },
      child: const Icon(Icons.people, color: Colors.blue),
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

  Widget _buildAvatar(BuildContext context, String? avatarUrl, String userId) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: userId,
        );
      },
      child: buildImage(
        imageUrl: avatarUrl,
        post: widget.post,
        width: 50,
        height: 50,
        borderRadius: 25.0,
        placeholderColor: AppColors.lightGray,
        placeholderIcon: Icons.person,
        disableActions: true,
        disableOpenDetail: true,
        context: context,
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return buildImage(
      imageUrl: imageUrl,
      post: widget.post,
      context: context,
      width: double.infinity,
      height: 200,
      borderRadius: 12.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.broken_image,
    );
  }
}
