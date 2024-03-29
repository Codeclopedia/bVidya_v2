import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

// import '../models/response/profile/schduled_classes_model.dart';
// import '../models/response/profile/scheduled_class_instructor_model.dart';
import '../models/response/profile/instructor_dashboard_response.dart';
import '/core/constants.dart';
import '../models/models.dart';
import '../network/dio_services.dart';

class ProfileApiService {
  static ProfileApiService instance = ProfileApiService._();

  late Dio _dio;
  ProfileApiService._() {
    _dio = DioServices.instance.dio;
  }

  //Get
  Future<BaseResponse> reportProblem(
      String token, String module, String message) async {
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final data = {
        'module': module,
        'message': message,
      };

      final response =
          await _dio.post(baseUrlApi + ApiList.reportProblem, data: data);
      print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return BaseResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<UserProfileResponse> getUserProfile(String token) async {
    // print(token);
    _dio.options.headers['X-Auth-Token'] = token;
    try {
      final response = await _dio.get(baseUrlApi + ApiList.userProfile);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
      } else {
        return UserProfileResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return UserProfileResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  // Future<NotificationsResponse> getNotificationSettings() async {
  //   final sharedprefInstance = await SharedPreferences.getInstance();
  //   final jsonData = sharedprefInstance.getString("NotificationSettings");

  //   final notificationdata = NotificationsResponse.fromRawJson(jsonData ?? "");
  //   return notificationdata;
  // }

  Future<SubscribedCoursesResponse> getSubscribedCourses(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response = await _dio.get(baseUrlApi + ApiList.subscribedList);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return SubscribedCoursesResponse.fromJson(response.data);
      } else {
        return SubscribedCoursesResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return SubscribedCoursesResponse(status: 'error');
    }
  }

  Future<FollowInstructorResponse> followedInstructor(String authToken) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.instructorFollowed}');
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return FollowInstructorResponse.fromJson(response.data);
      } else {
        return FollowInstructorResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return FollowInstructorResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<DashboardResponse> getDashboardDetails(String authToken) async {
    _dio.options.headers["X-Auth-Token"] = authToken;
    try {
      final response =
          await _dio.get('$baseUrlApi${ApiList.instructorDashboard}');
      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(response.data);
      } else {
        return DashboardResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print(e);
      return DashboardResponse(
        status: 'error',
      );
    }
  }

  Future<ImageUpdateResponse> updateProfilePic(String token, File file) async {
    try {
      _dio.options.headers['X-Auth-Token'] = token;
      String fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await _dio
          .post('$baseUrlApi${ApiList.updateProfileImage}', data: formData);
      // print('${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return ImageUpdateResponse.fromJson(response.data);
      } else {
        return ImageUpdateResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return ImageUpdateResponse(status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<UpdateProfileResponse> updateUserProfile(
      {required String token,
      required String name,
      required String email,
      required String age,
      required String phone,
      required String bio,
      required String language,
      required String occupation,
      required String city,
      required String address,
      required String state,
      required String country}) async {
    // debugPrint('Sir Sorry $token');
    final data = {
      'name': name,
      'phone': phone,
      'email': email,
      'gender': '',
      'age': age,
      'bio': bio,
      'language': language,
      'occupation': occupation,
      'city': city,
      'state': state,
      'address': address,
      'country': country,
    };
    try {
      _dio.options.headers['X-Auth-Token'] = token;
      // print('request: ${jsonEncode(data)} $token');
      final response =
          await _dio.post('$baseUrlApi${ApiList.updateProfile}', data: data);
      // print('${response.statusCode} ${response.statusMessage}');
      // print('${response.data}');
      if (response.statusCode == 200) {
        return UpdateProfileResponse.fromJson(response.data);
      } else {
        return UpdateProfileResponse(
            status: 'error',
            message: '${response.statusCode}- ${response.statusMessage}');
      }
    } catch (e) {
      return UpdateProfileResponse(
          status: 'error', message: 'Unknown error -$e');
    }
  }

  Future<RequestedClassesResponse> getRequestedClassList(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response = await _dio.get(baseUrlApi + ApiList.requestedClasses);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print("response ${response.data} . ${response.realUri}");
        return RequestedClassesResponse.fromJson(response.data);
      } else {
        return RequestedClassesResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print(e);
      return RequestedClassesResponse(status: 'error');
    }
  }

  Future<BaseResponse> updateRequestedClassStatus(String token, Map arg) async {
    _dio.options.headers['X-Auth-Token'] = token;
    int classID = arg['classID'];
    String status = arg['accepted'] == true ? 'accepted' : 'rejected';
    String remark = arg['remark'];
    final data = {"id": classID, 'status': status, 'remark': remark};

    try {
      final response = await _dio
          .post(baseUrlApi + ApiList.updateRequestedClassRequest, data: data);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return BaseResponse(status: 'error');
    }
  }

  Future<BaseResponse> deleteClassRequest(String token, String classID) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response =
          await _dio.get(baseUrlApi + ApiList.deleteClassRequest + classID);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return BaseResponse(status: 'error');
    }
  }

  Future<StudentScheduledClasses> getSchduledClassesStudent(
      String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response =
          await _dio.get(baseUrlApi + ApiList.scheduledClassesStudent);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return StudentScheduledClasses.fromJson(response.data);
      } else {
        return StudentScheduledClasses(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return StudentScheduledClasses(status: 'error');
    }
  }

  Future<InstructorScheduledClasses> getSchduledClassesInstructor(
      String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response =
          await _dio.get(baseUrlApi + ApiList.scheduledClassesInstructor);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return InstructorScheduledClasses.fromJson(response.data);
      } else {
        return InstructorScheduledClasses(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return InstructorScheduledClasses(status: 'error');
    }
  }
  // Future<SchduledClassesModel> getSchduledClassesStudent(String token) async {
  //   _dio.options.headers['X-Auth-Token'] = token;

  //   try {
  //     final response =
  //         await _dio.get(baseUrlApi + ApiList.scheduledClassesStudent);
  //     // print('response ${response.data} . ${response.realUri}');
  //     if (response.statusCode == 200) {
  //       print(response);
  //       return SchduledClassesModel.fromJson(response.data);
  //     } else {
  //       return SchduledClassesModel(
  //         status: 'error',
  //       );
  //     }
  //   } catch (e) {
  //     print("error $e");
  //     return SchduledClassesModel(status: 'error');
  //   }
  // }

  // Future<SchduledClassesInstructorModel> getSchduledClassesInstructor(
  //     String token) async {
  //   _dio.options.headers['X-Auth-Token'] = token;

  //   try {
  //     final response =
  //         await _dio.get(baseUrlApi + ApiList.scheduledClassesInstructor);
  //     // print('response ${response.data} . ${response.realUri}');
  //     if (response.statusCode == 200) {
  //       print(response);
  //       return SchduledClassesInstructorModel.fromJson(response.data);
  //     } else {
  //       return SchduledClassesInstructorModel(
  //         status: 'error',
  //       );
  //     }
  //   } catch (e) {
  //     print("error $e");
  //     return SchduledClassesInstructorModel(status: 'error');
  //   }
  // }

  Future<CreditDetailModel> getCreditsDetails(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response =
          await _dio.get(baseUrlApi + ApiList.purchasedCreditDetails);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return CreditDetailModel.fromJson(response.data);
      } else {
        return CreditDetailModel(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return CreditDetailModel(status: 'error');
    }
  }

  Future<SubscriptionPlansModel> getSubscriptionPlans(String token) async {
    _dio.options.headers['X-Auth-Token'] = token;

    try {
      final response = await _dio.get(baseUrlApi + ApiList.getAllSubscriptions);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return SubscriptionPlansModel.fromJson(response.data);
      } else {
        return SubscriptionPlansModel(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return SubscriptionPlansModel(status: 'error');
    }
  }

  Future<PaymentDetailModel> getpaymentId(String token, String planID) async {
    _dio.options.headers['X-Auth-Token'] = token;
    final data = {"plan_id": planID};

    try {
      final response =
          await _dio.post(baseUrlApi + ApiList.getpaymentId, data: data);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        print(response);
        return PaymentDetailModel.fromJson(response.data);
      } else {
        return PaymentDetailModel(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return PaymentDetailModel(status: 'error');
    }
  }

  Future<BaseResponse> purchasePromotionalOffer(
      String token, String planId) async {
    _dio.options.headers['X-Auth-Token'] = token;
    final data = {"plan_id": planId};

    try {
      final response = await _dio
          .post(baseUrlApi + ApiList.purchasePromotionalsCredits, data: data);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data);
      } else {
        return BaseResponse(status: 'error', message: response.statusMessage);
      }
    } catch (e) {
      print("error $e");
      return BaseResponse(status: 'error');
    }
  }
  // Future<InstructorScheduledClasses> getSchduledClassesInstructor(
  //     String token) async {
  //   _dio.options.headers['X-Auth-Token'] = token;

  //   try {
  //     final response =
  //         await _dio.get(baseUrlApi + ApiList.scheduledClassesInstructor);
  //     // print('response ${response.data} . ${response.realUri}');
  //     if (response.statusCode == 200) {
  //       print(response);
  //       return InstructorScheduledClasses.fromJson(response.data);
  //     } else {
  //       return InstructorScheduledClasses(
  //         status: 'error',
  //       );
  //     }
  //   } catch (e) {
  //     print("error $e");
  //     return InstructorScheduledClasses(status: 'error');
  //   }
  // }

  Future<PaymentSuccessModel> getpaymentSuccessDetails(
      String token, String orderId, String paymentId, String signature) async {
    _dio.options.headers['X-Auth-Token'] = token;
    final data = {
      'razorpay_order_id': orderId,
      'razorpay_payment_id': paymentId,
      'razorpay_signature': signature
    };

    print("hiited payment successful api with details $data");
    try {
      final response =
          await _dio.post(baseUrlApi + ApiList.getpaymentRecord, data: data);
      // print('response ${response.data} . ${response.realUri}');
      if (response.statusCode == 200) {
        return PaymentSuccessModel.fromJson(response.data);
      } else {
        return PaymentSuccessModel(
          status: 'error',
        );
      }
    } catch (e) {
      print("error $e");
      return PaymentSuccessModel(status: 'error');
    }
  }
}
