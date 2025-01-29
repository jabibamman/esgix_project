import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/user_model.dart';
import '../exceptions/user_exceptions.dart';

class UserService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  UserService({Dio? dioClient, FlutterSecureStorage? storage})
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

  Future<String> _getToken() async {
    return await secureStorage.read(key: 'auth_token') ?? '';
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await dio.get('/users/profile');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['record']);
      } else {
        throw ProfileFetchException("Impossible de récupérer le profil.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la récupération du profil';
      throw ProfileFetchException(message);
    } catch (e) {
      throw ProfileFetchException(
          "Erreur inattendue lors de la récupération du profil : ${e.toString()}");
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await dio.get('/users/$userId');

      if (response.statusCode == 200 && response.data != null) {
        final record = response.data;
        if (record != null) {
          print(record);
          return UserModel.fromJson(record);
        } else {
          throw UserFetchException("L'utilisateur est introuvable ou la réponse est invalide.");
        }
      } else {
        throw UserFetchException("Erreur lors de la récupération de l'utilisateur.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? "Erreur réseau lors de la récupération de l'utilisateur";
      throw UserFetchException(message);
    }
  }

  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      final token = await _getToken();
      final response = await dio.put(
        '/users/${user.id}',
        data: user.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['record']);
      } else {
        throw ProfileUpdateException(
            "Erreur lors de la mise à jour du profil.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la mise à jour du profil';
      throw ProfileUpdateException(message);
    } catch (e) {
      throw ProfileUpdateException(
          "Erreur inattendue lors de la mise à jour du profil : ${e.toString()}");
    }
  }

  Future<List<dynamic>> getUserPosts(String userId,
      {int page = 0, int offset = 10}) async {
    try {
      final response = await dio.get(
        '/user/$userId/posts',
        queryParameters: {
          'page': page.toString(),
          'offset': offset.toString(),
        },
      );
      if (response.statusCode == 200) {
        return response.data['posts'] as List<dynamic>;
      } else {
        throw UserPostsFetchException(
            "Erreur lors de la récupération des posts de l'utilisateur.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la récupération des posts';
      throw UserPostsFetchException(message);
    } catch (e) {
      throw UserPostsFetchException(
          "Erreur inattendue lors de la récupération des posts : ${e.toString()}");
    }
  }

  Future<List<dynamic>> getUserLikedPosts(String userId,
      {int page = 0, int offset = 10}) async {
    try {
      final response = await dio.get(
        '/user/$userId/likes',
        queryParameters: {
          'page': page.toString(),
          'offset': offset.toString(),
        },
      );
      if (response.statusCode == 200) {
        return response.data['liked_posts'] as List<dynamic>;
      } else {
        throw UserLikedPostsFetchException(
            "Erreur lors de la récupération des posts aimés.");
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ??
          'Erreur réseau lors de la récupération des posts aimés';
      throw UserLikedPostsFetchException(message);
    } catch (e) {
      throw UserLikedPostsFetchException(
          "Erreur inattendue lors de la récupération des posts aimés : ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getUsersWhoLikedPost(String postId) async {
    try {
      final response = await dio.get('/likes/$postId/users');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Erreur lors de la récupération des likes");
      }
    } catch (e) {
      throw Exception("Erreur réseau lors de la récupération des likes : $e");
    }
  }

}
