import 'dart:convert';

import 'package:dio/dio.dart';
import '../../core/constants/api_list.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class BChatApiService {
  static BChatApiService instance = BChatApiService._();
  late final Dio _dio;

  BChatApiService._() {
    _dio = DioServices.instance.dio;
  }

  Future<ChatTokenResponse> fetchChatToken(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get('$baseUrlApi${ApiList.getChatToken}');
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return ChatTokenResponse.fromJson(response.data);
      } else {
        return ChatTokenResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ChatTokenResponse(status: 'error', message: '$e');
    }
  }

  Future<ContactListResponse> getContacts(String token) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response = await _dio.get('$baseUrlApi${ApiList.allContacts}');
      print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return ContactListResponse.fromJson(response.data);
      } else {
        return ContactListResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ContactListResponse(status: 'error', message: '$e');
    }
  }
  Future<ContactListResponse> getContactsByIds(String token,String userIds) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {'user_ids': userIds};
      final response = await _dio.post('$baseUrlApi${ApiList.allContacts}',data: data);
      print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return ContactListResponse.fromJson(response.data);
      } else {
        return ContactListResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ContactListResponse(status: 'error', message: '$e');
    }
  }

  Future<BaseResponse> addContact(String token, String userId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {'user_id': userId};
      final response =
          await _dio.post('$baseUrlApi${ApiList.addContact}', data: data);
      print('${jsonEncode(response.data)}');
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

  Future<SearchContactResponse> searchContact(String token, String term) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {'term': term};
      final response =
          await _dio.post('$baseUrlApi${ApiList.searchContact}', data: data);
      print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return SearchContactResponse.fromJson(response.data);
      } else {
        return SearchContactResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return SearchContactResponse(status: 'error', message: '$e');
    }
  }

  Future<BaseResponse> deleteContact(String token, String userId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {'user_id': userId};
      final response =
          await _dio.post('$baseUrlApi${ApiList.deleteContact}', data: data);
      print('${jsonEncode(response.data)}');
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
