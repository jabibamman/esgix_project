import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/images.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool hasSearchResults = false;

  @override
  void dispose() {
    _searchController.dispose();
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
          controller: _searchController,
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
            setState(() {
              hasSearchResults = query.isNotEmpty;
            });
          },
        ),
        centerTitle: true,
      ),
      body: hasSearchResults
          ? ListView.builder(
        controller: _scrollController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(AppImages.logo),
            ),
            title: Text('Résultat $index', style: TextStyle(color: AppColors.primary)),
            subtitle: Text('Description du résultat $index'),
            onTap: () {
              Navigator.pushNamed(context, '/search-details', arguments: 'Query $index');
            },
          );
        },
      )
          : _buildTrendsForYou(),
    );
  }

  Widget _buildTrendsForYou() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trends for you',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'No new trends for you',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'It seems like there’s not a lot to show you right now, but you can see trends for other areas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: Text('Change location'),
            ),
          ],
        ),
      ),
    );
  }
}
