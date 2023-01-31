import 'package:dio/dio.dart';
import '/core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class ApiAuthService {
  static ApiAuthService instance = ApiAuthService._();

  late Dio _dio;

  ApiAuthService._() {
    _dio = DioServices.instance.dio;
  }

  Future<Category?> getcategory(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    final response = await _dio.get("https://myjson.dit.upm.es/api/bins/ibql");
    if (response.statusCode == 200) {
      return Category.fromJson(response.data);
    } else {
      return null;
    }
  }

//Login with email password
  Future<LoginResponse> userLogin(
    String email,
    String password,
    String fcmToken,
  ) async {
    final data = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
    try {
      final response =
          await _dio.post('$baseUrlApi${ApiList.login}', data: data);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LoginResponse(status: 'error', message: '$e');
    }
  }

//Login with Mobile Number-1

  Future<LoginResponse> loginOTPGenerate(
    String mobile,
  ) async {
    final data = {
      'mobile': mobile,
    };
    try {
      final response =
          await _dio.post('$baseUrlApi${ApiList.loginOtp}', data: data);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LoginResponse(status: 'error', message: '$e');
    }
  }

//Login with Mobile Number-2
  Future<LoginResponse> loginOTPVerification(
    String mobile,
    String otp,
    String fcmToken,
  ) async {
    final data = {
      'mobile': mobile,
      'otp': otp,
      'fcm_token': fcmToken,
    };
    try {
      final response =
          await _dio.post('$baseUrlApi${ApiList.verifyloginOtp}', data: data);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LoginResponse(status: 'error', message: e.toString());
    }
  }

//Sign up -1
  Future<LoginResponse> generateRegistrationOtp(String mobileNumber) async {
    dynamic data = {
      'phone': mobileNumber,
    };
    try {
      final response = await _dio.post(
        '$baseUrlApi${ApiList.generateRegistrationOtp}',
        data: data,
      );
      print('$response');
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      print(e);
      return LoginResponse(status: 'error', message: '$e');
    }
  }

//Sign Up -2
  Future<LoginResponse> createUserWithOTP({
    required String name,
    required String phoneNo,
    required String email,
    required String password,
    required String confirmpassword,
    required String otp,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'phone': phoneNo,
      'password': password,
      'password_confirmation': confirmpassword,
      'otp': otp,
    };
    try {
      final response =
          await _dio.post('$baseUrlApi${ApiList.signUp}', data: data);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return LoginResponse(status: 'error', message: '$e');
    }
  }

  Future<ForgotResponse> requestForgotPassword(String email) async {
    final data = {
      'email': email,
    };
    try {
      final response =
          await _dio.post('$baseUrlApi${ApiList.forgotPassword}', data: data);
      if (response.statusCode == 200) {
        return ForgotResponse.fromJson(response.data);
      } else {
        return ForgotResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ForgotResponse(status: 'error', message: '$e');
    }
  }

  Future<BaseResponse> deleteAccount() async {
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.deleteUserAccount}');
      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: '$e');
    }
  }
}
