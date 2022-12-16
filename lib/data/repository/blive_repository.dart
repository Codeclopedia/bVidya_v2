import 'dart:io';

import 'package:bvidya/data/models/response/blive/live_rtm_response.dart';

import '../models/models.dart';
import '../services/blive_api_services.dart';
//
// const successfull = 'successfull';

class BLiveRepository {
  static const successfull = 'successfull';
  final BLiveApiService _api;
  final String _authToken;

  BLiveRepository(this._api, this._authToken);

  Future<ScheduleClass?> createClass(
      {required String title,
      required String desc,
      required DateTime date,
      required DateTime time,
      required File image}) async {
    final result = await _api.createClass(_authToken,
        title: title, date: date, desc: desc, time: time, image: image);
    if (result.status == successfull) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<String?> deleteLiveClass(String id) async {
    final result = await _api.deleteLiveClass(_authToken, id);
    if (result.status == successfull) {
      return null;
    } else {
      return result.message;
    }
  }

  Future<LiveClass?> getLiveClass(String id) async {
    final result = await _api.getLiveClass(_authToken, id);
    if (result.status == successfull) {
      return result.body?.liveClass;
    } else {
      return null;
    }
  }


  Future<LMSLiveClasses?> getLiveClasses() async {
    final result = await _api.getLiveClasses(_authToken);
    if (result.status == successfull && result.body != null) {
      // print('result: ${result.status} ${result.body?.toJson()}');
      return result.body;
    } else {
      return null;
    }
  }


  Future<LiveRtmToken?> fetchLiveRTM(int id) async {
    final result = await _api.fetchLiveRTMToken(_authToken,id);
    if (result.status == successfull && result.body != null) {
      return result.body;
    } else {
      return null;
    }
  }
  
}
