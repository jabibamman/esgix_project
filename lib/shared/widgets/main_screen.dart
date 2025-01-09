import 'package:flutter/material.dart';
import '../../authenticated/home/home_screen.dart';
import '../../authenticated/search/search_screen.dart';
import '../../authenticated/postDetails/post_details_screen.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Navigator(
      key: PageStorageKey('HomeNavigator'),
      onGenerateRoute: (settings) {
        if (settings.name == '/post') {
          final postId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: postId),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    ),
    Navigator(
      key: PageStorageKey('SearchNavigator'),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        );
      },
    ),
    Center(child: Text("Notifications")),
    Center(child: Text("Messages")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
