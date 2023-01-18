import 'dart:convert';
import 'dart:io';

import '/data/models/response/bchat/file_upload_response.dart';
import 'package:dio/dio.dart';
import '/core/constants/api_list.dart';
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

  Future<ContactListResponse> getContactsByIds(
      String token, String userIds) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      // print('contactsByIds ${userIds}');
      final data = {'user_ids': userIds};
      final response =
          await _dio.post('$baseUrlApi${ApiList.contactsByIds}', data: data);
      // print('contactsByIds ${jsonEncode(response.data)}');
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

  Future<ContactListResponse> getGroupUsers(
      String token,
      List<String> membersIds,
      String ownerId,
      List<String> adminIds,
      String groupId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {
        'user_ids': membersIds.join(','),
        'owner': ownerId,
        'admin': adminIds.join(','),
        'group_id': groupId,
      };
      final response = await _dio
          .post('$baseUrlApi${ApiList.groupContactsByIds}', data: data);
      // print('groups ${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        // return ContactListResponse(
        //     status: 'error', message: '${response.statusCode}- Data');
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
      // print('${jsonEncode(response.data)}');
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
      // print('${jsonEncode(response.data)}');
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
      // print('${jsonEncode(response.data)}');
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

  Future<P2PCallResponse> makeCall(
      String token, String calleeId, String calleeName) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final data = {
        'callee_id': calleeId,
        'callee_name': calleeName,
      };
      final response =
          await _dio.post('$baseUrlApi${ApiList.makeCall}', data: data);
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return P2PCallResponse.fromJson(response.data);
      } else {
        return P2PCallResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return P2PCallResponse(status: 'error', message: '$e');
    }
  }

  Future<P2PCallResponse> receiveCall(String token, String callId) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.receiveCall}$callId');
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return P2PCallResponse.fromJson(response.data);
      } else {
        return P2PCallResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return P2PCallResponse(status: 'error', message: '$e');
    }
  }

  Future<FileUploadResponse> uploadImage(String token, File file) async {
    _dio.options.headers["X-Auth-Token"] = token;
    try {
      String fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response =
          await _dio.post('$baseUrlApi${ApiList.uploadImage}', data: formData);
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return FileUploadResponse.fromJson(response.data);
      } else {
        return FileUploadResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return FileUploadResponse(status: 'error', message: '$e');
    }
  }

  //dynamic data = {
  //   'callee_id': id,
  //   'callee_name': name,
  // };
  // var response = await _dio
  //     .post(StringConstant.BASE_URL + 'messenger/start-call', data: data);
  // if (response.statusCode == 200) {
  //   return VideocallModal.fromJson(response.data);
  // } else {
  //   Helper.showMessage(response.statusMessage);
  //   return null;
  // }
}
