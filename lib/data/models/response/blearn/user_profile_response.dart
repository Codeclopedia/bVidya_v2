
import '../../models.dart';

class UserProfileResponse {
  final Profile? body;
  final String? status;
  final String? message;

  UserProfileResponse({
    this.body,
    this.message,
    this.status,
  });

  UserProfileResponse.fromJson(Map<String, dynamic> json)
      : body = Profile?.fromJson(json['body']),
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