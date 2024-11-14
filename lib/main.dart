import 'package:esgix_project/shared/blocs/auth_bloc/auth_bloc.dart';
import 'package:esgix_project/shared/blocs/register_bloc/register_bloc.dart';
import 'package:esgix_project/shared/core/app_config.dart';
import 'package:esgix_project/shared/core/routes.dart';
import 'package:esgix_project/shared/services/auth_service.dart';
import 'package:esgix_project/unauthenticated/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  await AppConfig.loadEnv();
  final authService = AuthService();
  runApp(EsgiXApp(authService: authService));
}

class EsgiXApp extends StatelessWidget {
  final AuthService authService;

  const EsgiXApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService),
        ),
        BlocProvider(
            create: (context) => RegisterBloc(authService)
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