import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/models.dart';

final userAuthChangeProvider =
    ChangeNotifierProvider<UserAuthProvider>((ref) => UserAuthProvider());

class UserAuthProvider extends ChangeNotifier {
  User? _user;

  String userToken = '';

  User? get user => _user;

  bool _isUserSinged = false;

  bool get isUserSigned => _isUserSinged;

  bool _inInitialized = false;

  loadUser() async {
    if (_inInitialized) {
      return;
    }
    _inInitialized = true;
    final pref = await SharedPreferences.getInstance();
    final userStr = pref.getString("user");
    if (userStr != null) {
      final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      _user = user;
      userToken = user.authToken;
    }
    _isUserSinged = user != null;
    print(' User :$userStr');
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

  @override
  void dispose() {
    print('Disposed app');
    super.dispose();
  }
}
