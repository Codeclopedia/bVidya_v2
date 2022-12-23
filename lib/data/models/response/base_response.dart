class BaseResponse {
  final String? status;
  final String? message;
  final dynamic body;

  BaseResponse({this.message, this.status, this.body});

  BaseResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        body = json['body'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['body'] = body;
    return data;
  }
}
