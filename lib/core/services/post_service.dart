import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_config.dart';
import '../models/post_model.dart';
import '../exceptions/post_exceptions.dart';

class PostService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

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

  Future<PostModel> createPost(String content, {String? imageUrl}) async {
    try {
      final response = await dio.post(
        '/posts',
        data: {'content': content, 'imageUrl': imageUrl},
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['record']);
      } else {
        throw PostCreationException("Erreur lors de la création du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la création du post';
      throw PostCreationException(message);
    }
  }

  Future<List<PostModel>> getPosts({int page = 0, int offset = 10}) async {
    try {
      final response = await dio.get(
        '/posts',
        queryParameters: {
          'page': page,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return (response.data['records'] as List)
            .map((json) => PostModel.fromJson(json))
            .toList();
      } else {
        throw PostFetchException("Erreur lors de la récupération des posts.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la récupération des posts';
      throw PostFetchException(message);
    }
  }

  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await dio.get('/posts/$postId');

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['record']);
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
      final response = await dio.put(
        '/posts/$postId',
        data: {'content': content, 'imageUrl': imageUrl},
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['record']);
      } else {
        throw PostUpdateException("Erreur lors de la mise à jour du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la mise à jour du post';
      throw PostUpdateException(message);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final response = await dio.delete('/posts/$postId');

      if (response.statusCode != 200) {
        throw PostDeletionException("Erreur lors de la suppression du post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la suppression du post';
      throw PostDeletionException(message);
    }
  }

  Future<List<PostModel>> searchPosts(String query) async {
    try {
      final response = await dio.get(
        '/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        return (response.data['records'] as List)
            .map((json) => PostModel.fromJson(json))
            .toList();
      } else {
        throw PostSearchException("Erreur lors de la recherche des posts.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de la recherche de posts';
      throw PostSearchException(message);
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final response = await dio.post('/likes/$postId');

      if (response.statusCode != 200) {
        throw PostLikeException("Erreur lors de l'ajout d'un like au post.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Erreur réseau lors de l\'ajout d\'un like';
      throw PostLikeException(message);
    }
  }
}