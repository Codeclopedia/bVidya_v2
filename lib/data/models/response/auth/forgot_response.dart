class ForgotResponse {
  // User? body;
  String? status;
  String? message;
  ForgotResponse({body, status, message});

  ForgotResponse.fromJson(Map<String, dynamic> json) {
    // body = json['body'] != null ? User.fromJson(json['body']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    // if (body != null) {
    //   data['body'] = body!.toJson();
    // }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
