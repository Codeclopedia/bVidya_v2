import 'dart:convert';

import 'package:bvidya/core/state.dart';
import 'package:bvidya/core/ui_core.dart';
import 'package:bvidya/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userAuthChangeProvider =
    ChangeNotifierProvider<UserAuthProvider>((ref) => UserAuthProvider());

class UserAuthProvider extends ChangeNotifier {
  User? _user;
  String userToken = '';
  User? get user => _user;

  bool _isUserSinged = false;
  bool get isUserSigned => _isUserSinged;

  loadUser() async {
    final pref = await SharedPreferences.getInstance();
    final userStr = pref.getString("user");
    if (userStr != null) {
      final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      _user = user;
      userToken = user.authToken;
      // print(_user!.toJson());
      // await Future.delayed(const Duration(seconds: 2));
    }
    // await Future.delayed(const Duration(seconds: 2));
    notifyListeners();
  }

  setUserSigned(bool value) {
    _isUserSinged = value;
    notifyListeners();
  }

  logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    _user = null;
    notifyListeners();
  }
}
