import 'package:flutter/material.dart';
import '../../shared/models/post_model.dart';
import '../../shared/utils/interaction_utils.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import 'package:esgix_project/shared/utils/date_utils.dart';

class TweetCard extends StatelessWidget {
  final PostModel post;

  const TweetCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: Image.network(
                post.authorAvatar ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    CircleAvatar(radius: 25, backgroundColor: AppColors.lightGray),
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
                        post.authorUsername,
                        style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatTwitterDate(post.createdAt),
                        style: TextStyles.bodyText2.copyWith(color: AppColors.darkGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    post.content,
                    style: TextStyles.bodyText1,
                  ),
                  if (post.imageUrl != null) ...[
                    const SizedBox(height: 8.0),
                    Image.network(
                      post.imageUrl!,
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
                      buildInteractionIcon(Icons.comment, post.commentCount),
                      buildInteractionIcon(Icons.repeat, generateRandomAudience(max: 500)),
                      buildInteractionIcon(Icons.favorite_border, post.likeCount),
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
    );
  }

}
