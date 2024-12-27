import 'package:esgix_project/shared/blocs/auth_bloc/auth_bloc.dart';
import 'package:esgix_project/shared/blocs/home_bloc/home_bloc.dart';
import 'package:esgix_project/shared/blocs/register_bloc/register_bloc.dart';
import 'package:esgix_project/shared/core/app_config.dart';
import 'package:esgix_project/shared/core/routes.dart';
import 'package:esgix_project/shared/services/auth_service.dart';
import 'package:esgix_project/shared/services/post_service.dart';
import 'package:esgix_project/unauthenticated/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  await AppConfig.loadEnv();
  final authService = AuthService();
  final postService = PostService();

  runApp(EsgiXApp(authService: authService, postService: postService));
}

class EsgiXApp extends StatelessWidget {
  final AuthService authService;
  final PostService postService;

  const EsgiXApp({super.key, required this.authService, required this.postService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: postService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authService),
          ),
          BlocProvider(
            create: (context) => HomeBloc(postService),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(authService),
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
      ),
    );
  }
}
