import 'dart:convert';

import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/models.dart';

bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

// final timeFormat = DateFormat()

Future<User?> getMeAsUser() async {
  final pref = await SharedPreferences.getInstance();
  final userStr = pref.getString("user");
  if (userStr != null) {
    final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
    return user;
  }
  return null;
}

Future<void> shareUserMeetContent(String title, String id, String type) async {
  final user = await getMeAsUser();
  if (user == null) return;
  FlutterShare.share(
      title: title,
      text: '${user.name} just invited you to a bvidya $type.\n'
          '$type code -$id\n'
          'To join, copy the code and enter it on the bvidya app or website.');
}
