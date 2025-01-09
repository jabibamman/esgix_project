import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/home_bloc/home_bloc.dart';
import '../../shared/blocs/home_bloc/home_event.dart';
import '../../shared/blocs/home_bloc/home_state.dart';
import '../../authenticated/home/tweet_card.dart';
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
    context.read<HomeBloc>().add(FetchPosts());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        context.read<HomeBloc>().add(FetchPosts());
      }
    });
  }

  Future<void> _refreshPosts() async {
    context.read<HomeBloc>().add(RefreshPosts());
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 30,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoaded) {
              setState(() {
                isLoadingMore = false;
              });
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading && context.read<HomeBloc>().allPosts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is HomeLoaded) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.posts.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<HomeBloc>().add(FetchPosts());
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
                    final post = state.posts[index];
                    return TweetCard(post: post, userId: '');
                  },
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else {
                  return const Center(
                  child: CircularProgressIndicator(
                  color: AppColors.primary
                  ),
                );
              }
            }
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
