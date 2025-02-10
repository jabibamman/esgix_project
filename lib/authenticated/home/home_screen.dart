import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/auth_bloc/auth_bloc.dart';
import '../../shared/blocs/auth_bloc/auth_event.dart';
import '../../shared/blocs/auth_bloc/auth_state.dart';
import '../../shared/blocs/home_bloc/home_bloc.dart';
import '../../shared/blocs/home_bloc/home_event.dart';
import '../../shared/blocs/home_bloc/home_state.dart';
import '../../shared/core/image_utils.dart';
import '../../shared/models/user_model.dart';
import '../../shared/widgets/tweet_card.dart';
import '../../theme/colors.dart';
import '../../theme/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchPosts(offset: 10));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 20 && !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        context.read<HomeBloc>().add(FetchPosts(offset: 10));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshPosts() async {
    context.read<HomeBloc>().add(RefreshPosts());
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            setState(() {
              isLoadingMore = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return _buildAppBar(context, state.user);
                } else {
                  return _buildAppBarPlaceholder();
                }
              },
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshPosts,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading && context.read<HomeBloc>().allPosts.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is HomeLoaded) {
                  final posts = state.posts;
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucun post disponible",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < posts.length) {
                        final post = posts[index];
                        return TweetCard(key: ValueKey(post.id), post: post);
                      } else {
                        return _buildLoadMoreButton(context);
                      }
                    },
                  );
                } else if (state is HomeError) {
                  return Center(
                    child: Text(
                      'Erreur: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserModel currentUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/profile',
                arguments: currentUser.id,
              );
            },
            child: buildImage(
              imageUrl: currentUser.avatar,
              context: context,
              width: 50,
              height: 50,
              borderRadius: 25,
              disableActions: true,
              disableOpenDetail: true,
            ),
          ),
        ),
        Image.asset(
          AppImages.logo,
          height: 30,
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.primary),
          tooltip: 'Déconnexion',
          onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
          },
        ),
      ],
    );
  }

  Widget _buildAppBarPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(radius: 25, backgroundColor: AppColors.lightGray),
        Image.asset(AppImages.logo, height: 30),
        const Icon(Icons.logout, color: AppColors.primary),
      ],
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<HomeBloc>().add(FetchPosts(offset: 10));
          },
          icon: const Text('😔'),
          label: const Text(
            'Vous avez atteint la fin.\n Appuyez pour recharger la page.',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
