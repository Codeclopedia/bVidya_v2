class P2PCallResponse {
  final String? status;
  final String? message;
  final CallBody? body;

  P2PCallResponse({this.message, this.status, this.body});

  P2PCallResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        body = json['body'] != null ? CallBody.fromJson(json['body']) : null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['body'] = body;
    return data;
  }
}

class CallBody {
  final String appid;
  final String callId;
  final String callerName;
  final String calleeName;
  final String callChannel;
  final String callToken;

  CallBody(this.appid, this.callId, this.callerName, this.calleeName,
      this.callChannel, this.callToken);

  CallBody.fromJson(Map<String, dynamic> json)
      : appid = json['appid'],
        callId = json['call_id'],
        callerName = json['caller_name'],
        calleeName = json['callee_name'],
        callChannel = json['call_channel'],
        callToken = json['call_token'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['appid'] = appid;
    data['call_id'] = callId;
    data['caller_name'] = callerName;
    data['callee_name'] = calleeName;
    data['call_channel'] = callChannel;
    data['call_token'] = callToken;
    return data;
  }
}
