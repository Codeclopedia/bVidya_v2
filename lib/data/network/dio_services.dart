import 'package:dio/dio.dart';
import '/core/constants.dart';

class DioServices {
  static DioServices instance = DioServices._();
  late Dio _dio;
  DioServices._() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrlApi,
      receiveDataWhenStatusError: true,
    );
    _dio = Dio(options);
    _dio.options.headers["Accept"] = "application/json";
    // _dio.options.connectTimeout = 150000;
    // _dio.options.sendTimeout = 100000;
    // _dio.options.receiveTimeout = 120000;
    _dio.options.connectTimeout = const Duration(seconds: 150);
    _dio.options.sendTimeout = const Duration(seconds: 100);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
  }

  Dio get dio => _dio;

  // static Future<Response> get(Dio dio, String url) async {
  //   return dio.get(url);
  // }
}
