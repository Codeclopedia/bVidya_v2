import 'package:dio/dio.dart';
import '../../core/constants.dart';

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
    _dio.options.connectTimeout = 150000;
    _dio.options.sendTimeout = 100000;
    _dio.options.receiveTimeout = 120000;
  }
  Dio get dio => _dio;
}
