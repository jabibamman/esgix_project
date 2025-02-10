import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix_project/shared/models/user_model.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:esgix_project/theme/colors.dart';

import '../../shared/blocs/profile_bloc/profile_bloc.dart';
import '../../shared/blocs/profile_bloc/profile_event.dart';
import '../../shared/blocs/profile_bloc/profile_state.dart';
import '../../shared/core/image_utils.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(userService: UserService())..add(FetchUserProfile(userId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                // Redirection après le build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, '/login');
                });
                return Container();
              }

              if (state is ProfileLoaded) {
                final user = state.user;

                return Column(
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
                                    child: _buildBackButton(context),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    height: 213,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 40),
                                        Text(
                                          user.username,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (user.emailVisibility ?? false)
                                          Text(
                                            user.email,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.darkGray,
                                            ),
                                          ),
                                        const SizedBox(height: 10),
                                        Text(user.description),
                                        const SizedBox(height: 10),
                                        if (user.created != null)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.date_range,
                                                color: AppColors.darkGray,
                                                size: 16,
                                              ),
                                              Text(
                                                ' Joined in ${user.created!}',
                                                style: const TextStyle(
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
                                  child: buildImage(
                                    imageUrl: user.avatar,
                                    context: context,
                                    width: 80,
                                    height: 80,
                                    borderRadius: 40,
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
                );
              }

              return Container(); // Cas par défaut (ne devrait pas arriver)
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        color: AppColors.primary,
        width: 40,
        height: 40,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.arrow_back_ios, color: AppColors.white),
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
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFollowsCount({required int following, required int followers}) {
    return Row(
      children: [
        Text(
          following.toString(),
          style: const TextStyle(
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
          style: const TextStyle(
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