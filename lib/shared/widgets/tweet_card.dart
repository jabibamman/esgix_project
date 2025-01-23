import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../utils/interaction_utils.dart';
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
  late int likeCount;
  late bool isLiked;
  final PostService postService = PostService();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likeCount;
    isLiked = false;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    try {
      final userId = await postService.getId();
      final postLikes = await userService.getUsersWhoLikedPost(widget.post.id);

      if (!mounted) return;
      setState(() {
        isLiked = postLikes.any((like) => like['id'] == userId);
      });
    } catch (e) {
      print("Erreur lors de la vérification des likes : $e");
    }
  }

  Future<void> _handleLike() async {
    try {
      await postService.likePost(widget.post.id);
      if (!mounted) return;
      setState(() {
        isLiked = !isLiked;
        likeCount += isLiked ? 1 : -1;
      });
    } catch (e) {
      print("Erreur lors de l'ajout d'un like : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      {
        Navigator.pushNamed(
          context,
          '/post',
          arguments: widget.post.id,
        ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: GestureDetector(
                  onTap: () =>
                  {
                    Navigator.pushNamed(
                      context,
                      '/profile',
                      arguments: widget.post.author.id,
                    ),
                  },
                  child: Image.network(
                    widget.post.author.avatar ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.lightGray
                    ),
                  ),
                ),
              ),
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
                      widget.post.content,
                      style: TextStyles.bodyText1,
                    ),
                    if (widget.post.imageUrl != null) ...[
                      const SizedBox(height: 8.0),
                      Image.network(
                        widget.post.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100,
                          color: AppColors.lightGray,
                          child: Center(
                            child: Icon(Icons.broken_image, color: AppColors.darkGray),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildInteractionIcon(Icons.comment, widget.post.commentCount),
                        buildInteractionIcon(Icons.repeat, generateRandomAudience(max: 500)),
                        GestureDetector(
                          onTap: _handleLike,
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
                        buildInteractionIcon(Icons.bar_chart, generateRandomAudience()),
                        buildInteractionIcon(Icons.bookmark_border, null),
                        buildInteractionIcon(Icons.share, null),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInteractionIcon(IconData icon, int? count) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkGray),
        const SizedBox(width: 4.0),
        if (count != null) Text('$count'),
      ],
    );
  }
}
