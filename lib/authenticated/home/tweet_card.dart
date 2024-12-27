import 'package:flutter/material.dart';
import '../../shared/models/post_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

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
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: post.authorAvatar != null
                      ? Image.network(
                    post.authorAvatar!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.lightGray,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorUsername,
                        style: TextStyles.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${post.createdAt} • ${post.updatedAt}',
                        style: TextStyles.bodyText2.copyWith(
                          color: AppColors.darkGray,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              post.content,
              style: TextStyles.bodyText1,
            ),
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.lightGray,
                      height: 200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAction(Icons.chat_bubble_outline, post.commentCount),
                _buildAction(Icons.favorite_border, post.likeCount),
                IconButton(
                  icon: Icon(Icons.share_outlined, color: AppColors.darkGray),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.darkGray),
        const SizedBox(width: 4.0),
        Text(
          count.toString(),
          style: TextStyles.bodyText2.copyWith(color: AppColors.darkGray),
        ),
      ],
    );
  }
}
