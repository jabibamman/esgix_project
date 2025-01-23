import 'package:esgix_project/theme/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
            ),
            child: const Icon(
              Icons.post_add,
              color: AppColors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
            ),
          ),
          Center(
            child: Text('Profile Screen'),
          ),
        ],
      ),
    );
  }
}
