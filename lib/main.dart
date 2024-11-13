import 'package:esgix_project/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_config.dart';
import 'core/routes.dart';
import 'core/services/auth_service.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'screens/login_screen.dart';

void main() async {
  await AppConfig.loadEnv();
  runApp(const EsgiXApp());
}

class EsgiXApp extends StatelessWidget {
  const EsgiXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
      ],
      child: FutureBuilder<Widget>(
        future: AppRoutes.getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          return MaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                displayMedium: TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                ),
              ),
            ),
            home: snapshot.data ?? const LoginScreen(),
            routes: AppRoutes.getRoutes(),
          );
        },
      ),
    );
  }
}