import 'package:flutter/material.dart';
import '../../authenticated/home/home_screen.dart';
import '../../authenticated/profile/profile_screen.dart';
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
      key: const PageStorageKey('HomeNavigator'),
      onGenerateRoute: generateRoute,
    ),
    Navigator(
      key: const PageStorageKey('SearchNavigator'),
      onGenerateRoute: (settings) {
        if (settings.name == '/post') {
          return generateRoute(settings);
        }
        return MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        );
      },
    ),
    Center(child: const Text("Notifications")),
    Center(child: const Text("Messages")),
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

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/post') {
    final postId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => PostDetailScreen(postId: postId),
    );
  }
  else if (settings.name == '/profile') {
    final userId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => ProfileScreen(userId: userId),
    );
  }

  return MaterialPageRoute(
    builder: (context) => HomeScreen(),
  );
}
