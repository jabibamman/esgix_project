import 'package:esgix_project/authenticated/search/search_screen.dart';
import 'package:flutter/material.dart';

import '../../authenticated/createPost/create_post_screen.dart';
import '../../authenticated/home/home_screen.dart';
import '../../unauthenticated/login/login_screen.dart';
import '../../unauthenticated/register/register_screen.dart';
import '../../authenticated/postDetails/post_details_screen.dart';
import '../services/auth_service.dart';
class AppRoutes {
  /* TODO: Uncomment the following code when these others routes are implemented */
  static const List<String> bottomNavRoutes = [
    '/home',
    '/search',
    //'/notifications',
    //'/messages',
  ];

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/home': (context) => const HomeScreen(),
      '/search': (context) => const SearchScreen(),
      '/create-post': (context) => const CreatePostScreen(),
      //'/search-details': (context) => const SearchDetailsScreen(),
      //'/notifications': (context) => const NotificationsScreen(),
      //'/messages': (context) => const MessagesScreen(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/post') {
      final postId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => PostDetailScreen(postId: postId),
      );
    }
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  static Future<Widget> getInitialRoute() async {
    if (await AuthService().isLoggedIn()) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
