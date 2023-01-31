import 'dart:convert';

// import '/controller/providers/user_auth_provider.dart';
// import '/core/state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/auth_api_service.dart';

// const successfull = 'successfull';

class AuthRepository {
  static const successfull = 'successfull';

  final ApiAuthService api;

  User? _user;
  String userToken = '';
  String? fcmToken;
  String? _mobileNumber;

  User? get user => _user;

  AuthRepository(this.api);

  Future<User?> init() async {
    final pref = await SharedPreferences.getInstance();
    final userStr = pref.getString("user");
    if (userStr != null) {
      final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      _user = user;
      userToken = user.authToken;
      // print(_user!.toJson());
      // await Future.delayed(const Duration(seconds: 2));
      return user;
    }
    // await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  Future updateUser(User user) async {
    _user = user;
    userToken = user.authToken;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('user', jsonEncode(user.toJson()));
  }

//Login with email, password
  Future<String?> login(String email, String password) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final result = await api.userLogin(email, password, fcmToken);
      if (result.status != null &&
          result.status == successfull &&
          result.body != null) {
        _user = result.body;
        userToken = _user?.authToken ?? '';

        final pref = await SharedPreferences.getInstance();
        await pref.setString('user', jsonEncode(_user!.toJson()));
        return null;
      } else {
        return result.message ?? 'Unknown error occurred!!';
      }
    } else {
      return 'Firebase not initialized';
    }
  }

//Sign up -1
  Future<String?> generateRegistrationOtp(String phone) async {
    final result = await api.generateRegistrationOtp(phone);
    if (result.status != null && result.status == successfull) {
      _mobileNumber = phone;
      return null;
    }
    print('genereateRegistrationOtp ${result.toJson()}');
    return result.message ?? 'Unknown error occurred!!';
  }

  Future<String?> reSendRegistrationOtp() async {
    if (_mobileNumber == null) {
      return 'Please enter valid mobile number';
    }

    final result = await api.generateRegistrationOtp(_mobileNumber!);
    if (result.status != null &&
        result.status != null &&
        result.status == successfull) {
      return null;
    }
    return result.message ?? 'Unknown error occurred!!';
  }

//Sign up -2
  Future<String?> verifyRegistrationOtp(String name, String email,
      String password, String confirmpassword, String otp) async {
    if (_mobileNumber == null) return 'Please enter mobile number';
    final result = await api.createUserWithOTP(
        phoneNo: _mobileNumber!,
        password: password,
        confirmpassword: confirmpassword,
        email: email,
        name: name,
        otp: otp);
    if (result.body != null && result.status == successfull) {
      final signupBody = result.body;
      if (signupBody?.status == 'active') {
        // _user = result.body;
        // userToken = _user?.authToken ?? '';
        // final pref = await SharedPreferences.getInstance();
        // await pref.setString('user', jsonEncode(_user!.toJson()));
        return await login(email, password);
      }
    }
    return result.message ?? 'Unknown error occurred!!';
  }

//Login Mobile -1
  Future<String?> loginOtpGenerate(String mobile) async {
    final result = await api.loginOTPGenerate(mobile);
    if (result.status != null && result.status == successfull) {
      _mobileNumber = mobile;
      return null;
    }
    return result.message ?? 'Unknown error occurred!!';
  }

  Future<String?> loginOtpReGenerate() async {
    if (_mobileNumber == null) {
      return 'Please enter valid mobile number';
    }

    final result = await api.loginOTPGenerate(_mobileNumber!);
    if (result.status != null && result.status == successfull) {
      return null;
    }
    return result.message ?? 'Unknown error occurred!!';
  }

  Future<String?> loginOtpVerify(String otp) async {
    if (_mobileNumber == null) return 'Please enter mobile number';
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final result =
          await api.loginOTPVerification(_mobileNumber!, otp, fcmToken);
      if (result.status != null &&
          result.status == successfull &&
          result.body != null) {
        _user = result.body;
        userToken = _user?.authToken ?? '';
        final pref = await SharedPreferences.getInstance();
        await pref.setString('user', jsonEncode(_user!.toJson()));
        return null;
      }
      return result.message ?? 'Unknown error occurred!!';
    } else {
      return 'Unknown error occurred!!';
    }
  }

  Future<String?> forgetPassword(String email) async {
    final result = await api.requestForgotPassword(email);
    if (result.status != null && result.status == successfull) {
      return null;
    }
    return result.message ?? 'Unknown error occurred!!';
  }

  Future deleteAccount() async {
    final result = await api.deleteAccount();
    if (result.status != null && result.status == successfull) {
      return result.message;
    }
    return 'Unknown error occurred!';
  }

  void loggedOut() {
    _user = null;
  }
}
