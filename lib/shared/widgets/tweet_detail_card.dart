import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../core/image_utils.dart';
import '../models/post_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../utils/date_utils.dart';

class TweetDetailCard extends StatelessWidget {
  final PostModel post;

  const TweetDetailCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        bool isLiked = post.isLiked;
        int likeCount = post.likeCount;

        if (state is LikeToggled && state.postId == post.id) {
          isLiked = state.isLiked;
          likeCount = state.likeCount;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(post.author.avatar),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author.username,
                            style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            formatTwitterDate(post.createdAt),
                            style: TextStyles.bodyText2.copyWith(color: AppColors.darkGray),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(post.content, style: TextStyles.bodyText1),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 12.0),
                  _buildImage(post.imageUrl!),
                ],
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInteractionIcon(Icons.comment, post.commentCount),
                    _buildInteractionIcon(Icons.repeat, 500),
                    GestureDetector(
                      onTap: () {
                        context.read<PostsBloc>().add(ToggleLikeEvent(post.id, isLiked));
                      },
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Text('$likeCount'),
                        ],
                      ),
                    ),
                    _buildInteractionIcon(Icons.share, null),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
      imageUrl: avatarUrl,
      width: 50,
      height: 50,
      borderRadius: 25.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.person,
    );
  }

  Widget _buildImage(String imageUrl) {
    return buildImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      borderRadius: 12.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.broken_image,
    );
  }
}
