import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveDataLocally(String key, data) async {
  final sharedPreferenceInstance = await SharedPreferences.getInstance();

  final status =
      await sharedPreferenceInstance.setString(key, jsonEncode(data));
  return status;
}

Future<String?> getLocalData(String key) async {
  final sharedPreferenceInstance = await SharedPreferences.getInstance();

  final response = sharedPreferenceInstance.getString(key);
  return response;
}
