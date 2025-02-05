import 'package:esgix_project/shared/models/post_model.dart';
import 'package:esgix_project/shared/widgets/create_post_widget.dart';
import 'package:esgix_project/unauthenticated/login/login_screen.dart';
import 'package:esgix_project/unauthenticated/register/register_screen.dart';
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
    HomeScreen(),
    const SearchScreen(),
    const Center(child: Text("Notifications")),
    const Center(child: Text("Messages")),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldRefresh = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreatePostWidget(),
          );

          if (shouldRefresh == true && _currentIndex == 0) {
            setState(() {
              _pages[0] = HomeScreen();
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/post':
      final post = settings.arguments as PostModel?;
      return MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      );
    case '/login':
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case '/register':
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
   }
}
