import '../models/models.dart';
import '../services/bmeet_api_services.dart';

class BMeetRepository {
  static const successfull = 'successfull';

  final BMeetApiService _api;
  final String _authToken;

  BMeetRepository(this._api, this._authToken);

  Future<ScheduledMeeting?> createInstantMeeting() async {
    final result = await _api.createInstantMeeting(_authToken);
    if (result.status == successfull) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<ScheduledMeeting?> createMeeting(
      {required String title,
      required String subject,
      required DateTime date,
      required DateTime startAt,
      required DateTime endAt,
      required bool noAudio,
      required bool noVideo}) async {
    final result = await _api.createMeeting(_authToken,
        title: title,
        date: date,
        subject: subject,
        startAt: startAt,
        endAt: endAt,
        noAudio: noAudio,
        noVideo: noVideo);
    if (result.status == successfull) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<ScheduledMeeting?> updateMeeting({required Map data}) async {
    final result = await _api.updateMeet(_authToken, data);
    if (result.status == successfull) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<String?> deleteMeeting(String id) async {
    final result = await _api.deleteMeeting(_authToken, id);
    if (result.status == successfull) {
      return null;
    } else {
      return result.message;
    }
  }

  Future<Meeting?> startHostMeeting(int id) async {
    final result = await _api.startHostMeet(_authToken, id);
    if (result.status == successfull) {
      return result.body!.meeting;
    } else {
      return null;
    }
  }

  Future<JoinMeeting?> joinMeeting(String id) async {
    final result = await _api.joinMeet(_authToken, id);
    if (result.status == successfull && result.body?.meeting != null) {
      return result.body!.meeting;
    } else {
      return null;
    }
  }

  Future<RTMUserTokenResponse?> fetchUserToken(int id, String name) async {
    return await _api.fetchUserToken(_authToken, id, name);
  }

  Future<Meetings?> fetchMeetingList() async {
    final result = await _api.fetchMeetingList(_authToken);
    if (result.status == successfull) {
      return result.body!;
    } else {
      return null;
    }
  }

  Future<String?> leaveMeet(int meetingId) async {
    final result = await _api.leaveMeet(_authToken, meetingId);
    if (result.status == successfull) {
      return null;
    } else {
      return result.message ?? 'Error while leaving meeting';
    }
  }

  Future<ClassRequestBody?> getClassRequests() async {
    final result = await _api.getClassRequestList(
      _authToken,
    );
    if (result.status == "success") {
      return result.body!;
    } else {
      return null;
    }
  }

  Future requestPersonalClass(
      {required String topic,
      required String classType,
      required DateTime date,
      required DateTime time,
      required String description,
      required int instructorid}) async {
    final result = await _api.requestPersonalClass(
        authToken: _authToken,
        topic: topic,
        classType: classType,
        datetime: date,
        time: time,
        description: description,
        instructorid: instructorid);
    if (result.status == "success") {
      return result.message;
    } else {
      return "error";
    }
  }

  Future<Meeting?> startScheduledClass(int id) async {
    final result = await _api.startScheduledClass(_authToken, id);
    if (result.status == successfull) {
      return result.body!.meeting;
    } else {
      return null;
    }
  }

  Future<JoinMeeting?> joinScheduledMeeting(String id) async {
    final result = await _api.joinScheduledClass(_authToken, id);
    if (result.status == successfull && result.body?.meeting != null) {
      return result.body!.meeting;
    } else {
      return null;
    }
  }
}
