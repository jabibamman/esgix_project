import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/user_model.dart';
import '../exceptions/auth_exceptions.dart';

class AuthService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthService({Dio? dioClient, FlutterSecureStorage? storage})
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

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _persistToken(token);
        final userId = response.data['record']['id'];
        await _persistId(userId);
        dio.options.headers['Authorization'] = 'Bearer $token';
        return UserModel.fromJson(response.data['record']);
      } else {
        throw LoginException(
            "Échec de la connexion. Vérifiez vos identifiants.");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Erreur réseau lors de la connexion';
      throw LoginException(message);
    } catch (e) {
      throw LoginException(
          "Erreur inattendue lors de la connexion : ${e.toString()}");
    }
  }

  Future<void> register(UserModel user) async {
    try {
      final response = await dio.post('/auth/register', data: user.toJson());
      if (response.statusCode != 200) {
        throw RegistrationException("Échec de l'inscription.");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Erreur réseau lors de l\'inscription';
      throw RegistrationException(message);
    } catch (e) {
      throw RegistrationException(
          "Erreur inattendue lors de l'inscription : ${e.toString()}");
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await dio.get('/users/profile');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
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

  Future<void> logout() async {
    try {
      await _clearToken();
      dio.options.headers.remove('Authorization');
    } catch (e) {
      throw LogoutException("Erreur lors de la déconnexion : ${e.toString()}");
    }
  }

  Future<void> _persistToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> _persistId(String userId) async {
    await secureStorage.write(key: 'auth_id', value: userId);
  }

  Future<void> _clearToken() async {
    await secureStorage.delete(key: 'auth_token');
  }

  Future<bool> isLoggedIn() {
    return secureStorage.read(key: 'auth_token').then((token) => token != null);
  }
}
