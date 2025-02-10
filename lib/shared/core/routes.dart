import 'package:esgix_project/authenticated/search/search_screen.dart';
import 'package:esgix_project/shared/models/post_model.dart';
import 'package:flutter/material.dart';

import '../widgets/create_post_widget.dart';
import '../../authenticated/home/home_screen.dart';
import '../../shared/services/auth_service.dart';
import '../../unauthenticated/login/login_screen.dart';
import '../../unauthenticated/register/register_screen.dart';
import '../../authenticated/postDetails/post_details_screen.dart';
import '../../authenticated/profile/profile_screen.dart';
import '../../authenticated/search/search_screen.dart';
import 'package:flutter/material.dart';

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
      '/home': (context) => HomeScreen(),
      '/search': (context) => const SearchScreen(),
      //'/search-details': (context) => const SearchDetailsScreen(),
      //'/notifications': (context) => const NotificationsScreen(),
      //'/messages': (context) => const MessagesScreen(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/post') {
      final post = settings.arguments as PostModel;
      return MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      );
    }
    else if (settings.name == '/profile') {
      final userId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: userId),
      );
    }
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  static Future<Widget> getInitialRoute() async {
    if (await AuthService().isLoggedIn()) {
      return HomeScreen();
    }
    return const LoginScreen();
  }
}
