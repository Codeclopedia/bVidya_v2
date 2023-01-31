import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/state.dart';
// import '/core/ui_core.dart';
import '/data/models/models.dart';

final userLoginStateProvider = StateNotifierProvider<UserStateNotifier, User?>(
    ((ref) => UserStateNotifier()));

class UserStateNotifier extends StateNotifier<User?> {
  UserStateNotifier() : super(null);
  User? _user;
  String _userToken = '';
  String get userToken => _userToken;

  Future<User?> loadUser() async {
    if (_user != null) {
      return _user;
    }
    final pref = await SharedPreferences.getInstance();
    final userStr = pref.getString("user");
    if (userStr != null) {
      final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      _user = user;
      _userToken = user.authToken;
    }
    state = _user;
    return _user;
  }

  Future logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    _user = null;
    _userToken = '';
    state = null;
  }

  updateUser(User user) {
    _user = user;
    _userToken = user.authToken;
    state = _user;
  }
}

// final userAuthChangeProvider =
//     ChangeNotifierProvider<UserAuthProvider>((ref) => UserAuthProvider());

// class UserAuthProvider extends ChangeNotifier {
//   User? _user;

//   String userToken = '';

//   User? get user => _user;

//   bool _isUserSinged = false;

//   bool get isUserSigned => _isUserSinged;

//   bool _inInitialized = false;

//   Future<User?> loadUser() async {
//     if (_inInitialized && _user != null) {
//       return _user;
//     }
//     _inInitialized = true;
//     final pref = await SharedPreferences.getInstance();
//     final userStr = pref.getString("user");
//     if (userStr != null) {
//       final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
//       _user = user;
//       userToken = user.authToken;
//     }
//     _isUserSinged = user != null;
//     // print(' User :$userStr');
//     notifyListeners();
//     return _user;
//   }

//   setUserSigned(bool value) {
//     _isUserSinged = value;
//     notifyListeners();
//   }

//   logout() async {
//     final pref = await SharedPreferences.getInstance();
//     await pref.clear();
//     _user = null;
//     try {
//       notifyListeners();
//     } catch (e) {}
//   }

//   updateUser(User user) {
//     _user = user;
//     userToken = user.authToken;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     print('Disposed app');
//     super.dispose();
//   }
// }
