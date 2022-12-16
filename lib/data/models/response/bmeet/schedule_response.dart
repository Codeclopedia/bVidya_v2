class ScheduleResponse {
  final String? status;
  final String? message;
  final ScheduledMeeting? body;

  ScheduleResponse({this.message, this.status, this.body});

  ScheduleResponse.fromJson(Map<String, dynamic> json)
      : body = ScheduledMeeting.fromJson(json['body']),
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.toJson();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class ScheduledMeeting {
  final int _userId;
  final String _meetingId;
  final String _name;
  final String _description;
  final String _status;
  final String _startsAt;
  final String _endsAt;
  final dynamic _repeats;
  final dynamic _disableVideo;
  final dynamic _disableAudio;
  final String _updatedAt;
  final String _createdAt;
  final int _id;

  ScheduledMeeting(
      this._userId,
      this._meetingId,
      this._name,
      this._description,
      this._status,
      this._startsAt,
      this._endsAt,
      this._repeats,
      this._disableVideo,
      this._disableAudio,
      this._updatedAt,
      this._createdAt,
      this._id);

  ScheduledMeeting.fromJson(Map<String, dynamic> json)
      : _userId = json['user_id'],
        _meetingId = json['meeting_id'],
        _name = json['name'],
        _description = json['description'],
        _status = json['status'],
        _startsAt = json['starts_at'],
        _endsAt = json['ends_at'],
        _repeats = json['repeats'],
        _disableVideo = json['disable_video'],
        _disableAudio = json['disable_audio'],
        _updatedAt = json['updated_at'],
        _createdAt = json['created_at'],
        _id = json['id'];

  int get userId => _userId;
  String get meetingId => _meetingId;
  String get name => _name;
  String get description => _description;
  String get status => _status;
  String get startsAt => _startsAt;
  String get endsAt => _endsAt;
  dynamic get repeats => _repeats;
  dynamic get disableVideo => _disableVideo;
  dynamic get disableAudio => _disableAudio;
  String get updatedAt => _updatedAt;
  String get createdAt => _createdAt;
  int get id => _id;

  // Body.fromJson(dynamic json) {
  //   _userId = json['user_id'];
  //   _meetingId = json['meeting_id'];
  //   _name = json['name'];
  //   _description = json['description'];
  //   _status = json['status'];
  //   _startsAt = json['starts_at'];
  //   _endsAt = json['ends_at'];
  //   _repeats = json['repeats'];
  //   _disableVideo = json['disable_video'];
  //   _disableAudio = json['disable_audio'];
  //   _updatedAt = json['updated_at'];
  //   _createdAt = json['created_at'];
  //   _id = json['id'];
  // }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['meeting_id'] = _meetingId;
    map['name'] = _name;
    map['description'] = _description;
    map['status'] = _status;
    map['starts_at'] = _startsAt;
    map['ends_at'] = _endsAt;
    map['repeats'] = _repeats;
    map['disable_video'] = _disableVideo;
    map['disable_audio'] = _disableAudio;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
