import 'dart:convert';
import 'dart:io';

import 'package:bvidya/core/ui_core.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/data/models/models.dart';

bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

// final timeFormat = DateFormat()

Future<User?> getMeAsUser() async {
  try {
    final pref = await SharedPreferences.getInstance();
    final userStr = pref.getString("user");
    if (userStr != null) {
      final user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      return user;
    }
  } catch (e) {}

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

Future<bool?> shareApp() async {
  // FlutterShare.share(title: 'bVidyaAPp', text: '');
  String url = '';
  if (Platform.isAndroid) {
    url = 'https://play.google.com/store/apps/details?id=com.bvidya';
  } else if (Platform.isIOS) {
    url = 'https://apps.apple.com/us/app/bvidya/id1638111395';
  } else {
    url = 'https://app.bvidya.com';
  }
  return await FlutterShare.share(
      title: 'bVidya App',
      text: 'Let’s connect on bvidya!\n'
          'A fast, secure, and user-friendly app for everyone to use. '
          'Especially beneficial for students and teachers.\n'
          'Download it here – $url');
}

Future<void> rateApp(BuildContext context) async {
  if (Platform.isAndroid) {
    try {
      launchUrl(Uri.parse(
          'https://play.google.com/store/apps/details?id=com.bvidya'));
    } catch (e) {
      AppSnackbar.instance
          .error(context, 'Error in launching Google Play Store');
    }
  } else if (Platform.isIOS) {
    try {
      launchUrl(Uri.parse('https://apps.apple.com/us/app/bvidya/id1638111395'));
    } catch (e) {
      AppSnackbar.instance.error(context, 'Error in launching AppStore');
    }
  }
}
