import 'package:dio/dio.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BChatApiService {

  static BChatApiService instance = BChatApiService._();
  late final Dio _dio;

  BChatApiService._() {
    _dio = DioServices.instance.dio;
  }
  
}
