class LiveRTMResponse {
  final String? status;
  final String? message;
  final LiveRtmToken? body;

  LiveRTMResponse({this.message, this.status, this.body});

  LiveRTMResponse.fromJson(Map<String, dynamic> json)
      : body = LiveRtmToken.fromJson(json['body']),
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

class LiveRtmToken {
  String? roomStatus;
  final String? _appid;
  final String? _rtmChannel;
  final String? _rtmToken;
  final String? _rtmUser;

  LiveRtmToken(this.roomStatus, this._appid, this._rtmChannel, this._rtmToken,
      this._rtmUser);

  String get appid => _appid ?? '';
  String get rtmChannel => _rtmChannel ?? '';
  String get rtmToken => _rtmToken ?? '';
  String get rtmUser => _rtmUser ?? '';
  // String get roomStatus => _roomStatus ?? '';

  LiveRtmToken.fromJson(dynamic json)
      : _appid = json['appid'],
        _rtmChannel = json['rtm_channel'],
        roomStatus = json['room_status'],
        _rtmToken = json['rtm_token'],
        _rtmUser = json['rtm_user'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appid'] = _appid;
    map['rtm_channel'] = _rtmChannel;
    map['room_status'] = roomStatus;
    map['rtm_token'] = _rtmToken;
    map['rtm_user'] = _rtmUser;
    return map;
  }
}
