import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final ProfileBloc _profileBloc;
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _profileBloc = ProfileBloc(userService: UserService());
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileBloc.add(FetchUserProfile(widget.userId));
      _profileBloc.add(FetchUserPosts(userId: widget.userId));
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _profileBloc.add(FetchUserPosts(userId: widget.userId));
        } else if (_tabController.index == 3) {
          _profileBloc.add(FetchUserLikedPosts(userId: widget.userId));
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
        if (_tabController.index == 0) {
          _profileBloc.add(LoadMoreUserPosts(userId: widget.userId));
        } else if (_tabController.index == 3) {
          _profileBloc.add(LoadMoreUserLikedPosts(userId: widget.userId));
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildProfileHeader(),
              Expanded(child: _buildTabBarView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => current is ProfileCompositeState && (current.user != null),
      builder: (context, state) {
        if (state is ProfileCompositeState && state.user != null) {
          final user = state.user!;

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
                            Text(
                              user.username,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            if (user.emailVisibility ?? false)
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
                              ),
                            const SizedBox(height: 10),
                            Text(user.description),
                            const SizedBox(height: 10),
                            if (user.created != null)
                              Row(
                                children: [
                                  const Icon(Icons.date_range, color: AppColors.darkGray, size: 16),
                                  Text(
                                    ' Joined in ${user.created!}',
                                    style: const TextStyle(color: AppColors.darkGray),
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
        return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildBar() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.darkGray,
      indicatorColor: AppColors.primary,
      tabs: const [
        Tab(text: "Tweets"),
        Tab(text: "Retweets"),
        Tab(text: "Media"),
        Tab(text: "Likes"),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildUserPosts(),
        Center(child: Text("Retweets")),
        Center(child: Text("Media")),
        _buildUserLikedPosts(),
      ],
    );
  }

  Widget _buildUserPosts() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
      current is ProfileCompositeState,
      builder: (context, state) {
        if (state is ProfileCompositeState) {
          if (state.loadingTweets) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tweets.isEmpty) {
            return const Center(child: Text("Aucun tweet trouvé"));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.tweetsHasReachedMax ? state.tweets.length : state.tweets.length + 1,
            itemBuilder: (context, index) {
              if (index < state.tweets.length) {
                return TweetCard(post: state.tweets[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildUserLikedPosts() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
      current is ProfileCompositeState,
      builder: (context, state) {
        if (state is ProfileCompositeState) {
          if (state.loadingLikedPosts) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.likedPosts.isEmpty) {
            return const Center(child: Text("Aucun post liké trouvé"));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.likedPostsHasReachedMax ? state.likedPosts.length : state.likedPosts.length + 1,
            itemBuilder: (context, index) {
              if (index < state.likedPosts.length) {
                return TweetCard(post: state.likedPosts[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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

  Widget _buildFollowsCount({required int following, required int followers}) {
    return Row(
      children: [
        Text(following.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        const Text(' Following    ', style: TextStyle(color: AppColors.darkGray)),
        Text(followers.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        const Text(' Followers', style: TextStyle(color: AppColors.darkGray)),
      ],
    );
  }


}
