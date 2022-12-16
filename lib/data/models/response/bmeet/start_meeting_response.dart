class StartMeetingResponse {
  final String? status;
  final String? message;
  final MeetingBody? body;

  StartMeetingResponse({this.message, this.status, this.body});

  StartMeetingResponse.fromJson(Map<String, dynamic> json)
      : body = MeetingBody.fromJson(json['body']),
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

class MeetingBody {
  final Meeting? meeting;
  MeetingBody({this.meeting});
  MeetingBody.fromJson(Map<String, dynamic> json)
      : meeting = Meeting.fromJson(json['meeting']);
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['meeting'] = meeting?.toJson();
    return data;
  }
}

class Meeting {
  final String _appid;
  final String _channel;
  final String _token;
  String role;
  final String _audienceLatency;
  // final String? _name;
  // final String? _status;

  Meeting(
    this._appid,
    this._channel,
    this._token,
    this.role,
    this._audienceLatency,
    //  this._name, this._status,
  );

  String get appid => _appid;
  String get channel => _channel;
  String get token => _token;
  // String get role => role;
  String get audienceLatency => _audienceLatency;
  // String get name => _name ?? '';
  // String get status => _status ?? '';

  Meeting.fromJson(dynamic json)
      : _appid = json['appid'],
        _channel = json['channel'],
        _token = json['token'],
        role = json['role'],
        _audienceLatency = json['audienceLatency']
  // _name = json['name'],
  // _status = json['status']
  ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appid'] = _appid;
    // map['name'] = _name;
    map['channel'] = _channel;
    map['token'] = _token;
    map['role'] = role;
    // map['status'] = _status;
    map['audienceLatency'] = _audienceLatency;
    return map;
  }
}
