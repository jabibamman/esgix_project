import 'package:esgix_project/authenticated/home/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/home_bloc/home_bloc.dart';
import '../../shared/blocs/home_bloc/home_event.dart';
import '../../shared/blocs/home_bloc/home_state.dart';
import '../../theme/colors.dart';
import '../../theme/images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(RepositoryProvider.of(context))..add(FetchPosts()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 30,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is HomeLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return TweetCard(post: post);
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
              return const Center(child: Text('No posts available.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<HomeBloc>().add(RefreshPosts()),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
