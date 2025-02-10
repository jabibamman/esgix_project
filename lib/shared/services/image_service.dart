import 'package:dio/dio.dart';

class ImageService {
  final Dio dio = Dio();

  Future<bool> isImageAvailable(String url) async {
    try {
      final response = await dio.head(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
