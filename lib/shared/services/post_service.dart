import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:esgix_project/shared/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/post_model.dart';
import '../exceptions/post_exceptions.dart';
import 'auth_service.dart';

class PostService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final UserService userService = UserService();
  final AuthService authService = AuthService();

  PostService({Dio? dioClient, FlutterSecureStorage? storage})
      : dio = dioClient ?? Dio(),
        secureStorage = storage ?? FlutterSecureStorage() {
    dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': AppConfig.apiKey,
      },
    );
  }

  Future<PostModel> createPost(String content, {String? imageUrl, String? parentId}) async {
    try {
      final token = await authService.getToken();
      final response = await dio.post(
        '/posts',
        data: {
          'content': content,
          'imageUrl': imageUrl,
          if (parentId != null) 'parent': parentId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final postId = response.data['id'];
        print(response.data);
        return await getPostById(postId);
      } else {
        throw PostCreationException("Erreur lors de la création du post ou du commentaire.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la création du post ou du commentaire';
      throw PostCreationException(message);
    }
  }

  Future<List<PostModel>> getPosts({int page = 0, int offset = 10, String? parentId}) async {
    try {
      final userId = await authService.getId();
      print("userId: $userId");

      final queryParameters = {
        'page': page,
        'offset': offset,
        if (parentId != null) 'parent': parentId,
      };
      final response = await dio.get('/posts', queryParameters: queryParameters);

      if (response.statusCode == 200 && response.data != null) {
        final records = response.data['data'] as List?;
        if (records != null) {
          return Future.wait(records.map((json) async {
            final post = PostModel.fromJson(json);

            final likedUsers = await userService.getUsersWhoLikedPost(post.id);
            final isLiked = likedUsers.any((user) => user['id'] == userId);

            return post.copyWith(isLiked: isLiked);
          }).toList());
        } else {
          throw PostFetchException("Aucun post ou commentaire trouvé ou format invalide.");
        }
      } else {
        throw PostFetchException("Erreur lors de la récupération des posts.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la récupération des posts';
      throw PostFetchException(message);
    }
  }

  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await dio.get('/posts/$postId');

      if (response.statusCode == 200 && response.data != null) {
        final record = response.data;
        if (record != null) {
          return PostModel.fromJson(record);
        } else {
          throw PostFetchException("Le post est introuvable ou la réponse est invalide.");
        }
      } else {
        throw PostFetchException("Erreur lors de la récupération du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la récupération du post';
      throw PostFetchException(message);
    }
  }


  Future<PostModel> updatePost(String postId, String content, {String? imageUrl}) async {
    try {
      final token = await authService.getToken();
      final response = await dio.put(
        '/posts/$postId',
        data: {'content': content, 'imageUrl': imageUrl},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['record']);
      } else {
        throw PostUpdateException("Erreur lors de la mise à jour du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la mise à jour du post';
      throw PostUpdateException(message);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final token = await authService.getToken();
      final response = await dio.delete(
        '/posts/$postId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw PostDeletionException("Erreur lors de la suppression du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la suppression du post';
      throw PostDeletionException(message);
    }
  }

  Future<List<PostModel>> searchPosts({int page = 0, int offset = 10, required String query}) async {
    try {
      final response = await dio.get(
        '/search',
        queryParameters: {
          'page': page,
          'offset': offset,
          'query': query
        },
      );

      if (response.statusCode == 200) {
        final records = response.data['data'] as List?;
        if (records != null) {
          return records.map((json) => PostModel.fromJson(json)).toList();
        } else {
          throw PostSearchException("Aucun post trouvé ou format invalide.");
        }
      } else {
        throw PostSearchException("Erreur lors de la recherche des posts.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la recherche de posts';
      throw PostSearchException(message);
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final token = await authService.getToken();
      final response = await dio.post(
        '/likes/$postId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw PostLikeException("Erreur lors de l'ajout d'un like au post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de l\'ajout d\'un like';
      throw PostLikeException(message);
    }
  }
}
