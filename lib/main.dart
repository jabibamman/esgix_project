import 'package:esgix_project/shared/blocs/auth_bloc/auth_bloc.dart';
import 'package:esgix_project/shared/blocs/home_bloc/home_bloc.dart';
import 'package:esgix_project/shared/blocs/post_bloc/posts_bloc.dart';
import 'package:esgix_project/shared/blocs/post_creation_bloc/post_creation_bloc.dart';
import 'package:esgix_project/shared/blocs/post_detail/post_detail_bloc.dart';
import 'package:esgix_project/shared/blocs/profile_bloc/profile_bloc.dart';
import 'package:esgix_project/shared/blocs/register_bloc/register_bloc.dart';
import 'package:esgix_project/shared/blocs/search_bloc/search_bloc.dart';
import 'package:esgix_project/shared/core/app_config.dart';
import 'package:esgix_project/shared/core/routes.dart';
import 'package:esgix_project/shared/services/auth_service.dart';
import 'package:esgix_project/shared/services/image_service.dart';
import 'package:esgix_project/shared/services/post_service.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:esgix_project/unauthenticated/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esgix_project/shared/widgets/main_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() async {
  await AppConfig.loadEnv();
  final authService = AuthService();
  final postService = PostService();
  final userService = UserService();
  final secureStorage = FlutterSecureStorage();
  final imageService = ImageService();


  runApp(EsgiXApp(authService: authService, postService: postService, userService: userService,
      imageService: imageService,
      secureStorage: secureStorage));
}

class EsgiXApp extends StatelessWidget {
  final AuthService authService;
  final PostService postService;
  final UserService userService;
  final ImageService imageService;
  final FlutterSecureStorage secureStorage;

  const EsgiXApp({super.key, required this.authService, required this.postService,
    required this.userService, required this.imageService,
    required this.secureStorage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: postService),
        RepositoryProvider.value(value: userService),
        RepositoryProvider.value(value: imageService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService)),
          BlocProvider(create: (context) => HomeBloc(postService)),
          BlocProvider(create: (context) => RegisterBloc(authService)),
          BlocProvider(create: (context) => SearchBloc(postService)),
          BlocProvider(create: (context) => PostsBloc(postService, userService)),
          BlocProvider(create: (context) => PostDetailBloc(postService: postService)),
          BlocProvider(create: (context) => PostCreationBloc(postService: postService)),
          BlocProvider(create: (context) => ProfileBloc(userService: userService)),
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
              home: const MainScreen(),
              routes: AppRoutes.getRoutes(),
              onGenerateRoute: AppRoutes.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
