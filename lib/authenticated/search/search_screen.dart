import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/search_bloc/search_bloc.dart';
import '../../shared/blocs/search_bloc/search_event.dart';
import '../../shared/blocs/search_bloc/search_state.dart';
import '../../shared/widgets/tweet_card.dart';
import '../../theme/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            prefixIcon: Icon(Icons.search, color: AppColors.darkGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.lightGray,
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              context.read<SearchBloc>().add(SearchQueryChanged(query));
            }
          },
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(child: Text('Enter a query to search.'));
          } else if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final post = state.results[index];
                return TweetCard(post: post);
              },
            );
          } else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
