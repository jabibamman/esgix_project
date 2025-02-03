import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/search_bloc/search_bloc.dart';
import '../../shared/blocs/search_bloc/search_event.dart';
import '../../shared/blocs/search_bloc/search_state.dart';
import '../../shared/widgets/tweet_card.dart';
import '../../theme/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<SearchBloc>().add(SearchLoadMore());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: searchController,
          focusNode: _focusNode,
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
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
        ),
        centerTitle: true,
      ),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const Center(child: Text('Enter a query to search.'));
            } else if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              if (state.results.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucun résultat trouvé 🥲",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.results.length
                    : state.results.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.results.length) {
                    final post = state.results[index];
                    return TweetCard(post: post);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else if (state is SearchError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
