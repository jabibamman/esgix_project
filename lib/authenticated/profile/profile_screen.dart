import 'package:esgix_project/theme/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Column(
                        children: [
                          Container(
                            color: AppColors.darkGray,
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(16),
                            height: 150,
                            child: _buildBackButton(),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            height: 213,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                const Text(
                                  'Pixsellz',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  '@pixsellz',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('description'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: AppColors.darkGray,
                                      size: 16,
                                    ),
                                    const Text(
                                      ' Joined in 2020',
                                      style: TextStyle(
                                        color: AppColors.darkGray,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildFollowsCount(following: 217, followers: 118),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 105,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircleAvatar(
                            radius: 40,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.darkGray,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildBar(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Icon(
                  Icons.post_add,
                  color: AppColors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          color: AppColors.black.withValues(alpha: 0.5),
          width: 40,
          height: 40,
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBar() {
    return Row(
      children: [
        _buildBarItem(title: 'Tweets', index: 0),
        _buildBarItem(title: 'Retweets', index: 1),
        _buildBarItem(title: 'Media', index: 2),
        _buildBarItem(title: 'Likes', index: 3),
      ],
    );
  }

  Widget _buildBarItem({required String title, required int index}) {
    final isSelected = this.selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.darkGray,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.bottomCenter,
              height: isSelected ? 3 : 2,
              color: isSelected ? AppColors.primary : null,
            ),
            Container(
              height: isSelected ? 0 : 1,
              color: AppColors.darkGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowsCount({required int following, required int followers}) {
    return Row(
      children: [
        Text(
          following.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ' Following    ',
          style: TextStyle(
            color: AppColors.darkGray,
          ),
        ),
        Text(
          followers.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ' Followers',
          style: TextStyle(
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}
