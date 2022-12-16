class BaseResponse {
  final String? status;
  final String? message;

  BaseResponse({
    this.message,
    this.status,
  });

  BaseResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
