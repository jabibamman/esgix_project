import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc/posts_bloc.dart';
import '../../theme/colors.dart';
import '../core/image_utils.dart';

class LikedUsersList extends StatelessWidget {
  final String postId;

  const LikedUsersList({super.key, required this.postId});

  static void show(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => LikedUsersList(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is LikedUsersFetched && state.postId == postId) {
          if (state.likedUsers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Personne n'a liké ce post 🥲",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.likedUsers.length,
            itemBuilder: (context, index) {
              final user = state.likedUsers[index];
              return ListTile(
                leading: _buildAvatar(context, user.avatar),
                title: Text(user.username),
              );
            },
          );
        } else if (state is PostsError) {
          return Center(child: Text("Erreur : ${state.error}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAvatar(BuildContext context, String? avatarUrl) {
    return buildImage(
      imageUrl: avatarUrl,
      width: 50,
      height: 50,
      borderRadius: 25.0,
      placeholderColor: AppColors.lightGray,
      placeholderIcon: Icons.person,
      context: context,
    );
  }

}
