class ChatTokenResponse {
  final ChatTokenBody? body;
  final String? status;
  final String? message;

  ChatTokenResponse({this.body, this.message, this.status});

  ChatTokenResponse.fromJson(Map<String, dynamic> json)
      : body =
            json['body'] != null ? ChatTokenBody.fromJson(json['body']) : null,
        message = json['message'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['body'] = body?.toJson();
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class ChatTokenBody {
  final String appKey;
  final int userId;
  final String userToken;

  ChatTokenBody(
      {required this.appKey, required this.userId, required this.userToken});

  ChatTokenBody.fromJson(Map<String, dynamic> json)
      : appKey = json['app_key'],
        userId = json['user_id'],
        userToken = json['user_token'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['app_key'] = appKey;
    data['user_id'] = userId;
    data['user_token'] = userToken;
    return data;
  }
}
