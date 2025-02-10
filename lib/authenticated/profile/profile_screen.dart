import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix_project/shared/models/user_model.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:esgix_project/theme/colors.dart';
import '../../shared/blocs/profile_bloc/profile_bloc.dart';
import '../../shared/blocs/profile_bloc/profile_event.dart';
import '../../shared/blocs/profile_bloc/profile_state.dart';
import '../../shared/core/image_utils.dart';
import '../../shared/widgets/tweet_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final profileBloc = context.read<ProfileBloc>();
    profileBloc.add(FetchUserProfile(widget.userId));
    profileBloc.add(FetchUserPosts(userId: widget.userId));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<ProfileBloc>().add(LoadMoreUserPosts(userId: widget.userId));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(userService: UserService())
        ..add(FetchUserProfile(widget.userId))
        ..add(FetchUserPosts(userId: widget.userId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, '/login');
                });
                return Container();
              }

              if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(state.user, context),
                    const SizedBox(height: 10),
                    Expanded(child: _buildUserPosts(context)),
                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user, BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildUserPosts(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
      current is ProfilePostsLoaded || current is ProfilePostsLoading || current is ProfileError,
      builder: (context, state) {
        if (state is ProfilePostsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfilePostsLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
            itemBuilder: (context, index) {
              if (index < state.posts.length) {
                return TweetCard(post: state.posts[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        }

        return const Center(child: Text("Aucun post trouvé"));
      },
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