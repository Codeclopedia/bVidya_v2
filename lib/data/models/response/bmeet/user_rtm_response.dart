class RTMUserTokenResponse {
  String? appid;
  String? rtmToken;
  String? rtmUser;

  RTMUserTokenResponse({this.appid, this.rtmToken, this.rtmUser});

  RTMUserTokenResponse.fromJson(Map<String, dynamic> json) {
    appid = json['appid'];
    rtmToken = json['rtm_token'];
    rtmUser = json['rtm_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appid'] = appid;
    data['rtm_token'] = rtmToken;
    data['rtm_user'] = rtmUser;
    return data;
  }
}

