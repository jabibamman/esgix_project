import 'package:flutter/material.dart';

import '../../unauthenticated/login/login_screen.dart';
import '../../unauthenticated/register/register_screen.dart';
import '../services/auth_service.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
    };
  }

  static Future<Widget> getInitialRoute() async {
    if (await AuthService().isLoggedIn()) {
      // return const HomeScreen();
    }
    return const LoginScreen();
  }
}