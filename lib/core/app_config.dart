import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://esgix.tech';
  static final String apiKey = dotenv.env['API_KEY'] ?? '';

  static Future<void> loadEnv() async {
    await dotenv.load();
  }
}