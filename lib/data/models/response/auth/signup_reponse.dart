class SignupResponse {
  SignupUser? body;
  String? status;
  String? message;
  SignupResponse({body, status, message});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? SignupUser.fromJson(json['body']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class SignupUser {
  int id;
  String authToken;
  String name;
  String email;
  String phone;
  String role;
  String? status;
  String? referralCode;
  String? referredBy;
  String? uuid;

  SignupUser(
      {required this.id,
      required this.authToken,
      required this.name,
      required this.email,
      required this.phone,
      required this.role,
      this.referralCode,
      this.referredBy,
      this.uuid,
      this.status});

  SignupUser.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        authToken = json['access_token'] ?? '',
        phone = json['phone'] ?? '',
        email = json['email'] ?? '',
        role = json['role'] ?? '',
        id = json['id'] ?? '',
        referralCode = json['referral_code'],
        status = json['status'],
        referredBy = json['referred_by'],
        uuid = json['uuid'];

  // User.fromJson(Map<String, dynamic> json) {
  //   authToken = json['auth_token'];
  //   name = json['name'];
  //   email = json['email'];
  //   phone = json['phone'];
  //   role = json['role'];
  //   id = json['id'];
  //   fcmToken = json['fcm_token'];
  //   image = json['image'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['access_token'] = authToken;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['id'] = id;
    data['status'] = status;
    data['referred_by'] = referredBy;
    data['referral_code'] = referralCode;
    data['uuid'] = uuid;
    return data;
  }
}
