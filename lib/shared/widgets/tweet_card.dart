import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../core/image_utils.dart';
import '../models/post_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'package:esgix_project/shared/utils/date_utils.dart';

class TweetCard extends StatefulWidget {
  final PostModel post;

  const TweetCard({super.key, required this.post});

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
    likeCount = widget.post.likeCount;
    widget.post.isLiked = isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/post',
          arguments: widget.post,
        );
      },
      child: BlocListener<PostsBloc, PostsState>(
        listenWhen: (previous, current) =>
        current is LikeToggled && current.postId == widget.post.id,
        listener: (context, state) {
          if (state is LikeToggled && state.postId == widget.post.id) {
            setState(() {
              isLiked = state.isLiked;
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
                _buildAvatar(widget.post.author.avatar),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.post.content ?? "Contenu indisponible",
                        style: TextStyles.bodyText1,
                      ),
                      if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) ...[
                        const SizedBox(height: 8.0),
                        _buildImage(widget.post.imageUrl!),
                      ],
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInteractionIcon(Icons.comment, widget.post.commentCount),
                          _buildInteractionIcon(Icons.repeat, 500),
                          GestureDetector(
                            onTap: () {
                              context.read<PostsBloc>().add(ToggleLikeEvent(widget.post.id, isLiked));
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
              ],
            ),
          ),
        ),
      ),
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
