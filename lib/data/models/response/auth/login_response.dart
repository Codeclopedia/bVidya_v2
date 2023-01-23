class LoginResponse {
  User? body;
  String? status;
  String? message;
  LoginResponse({body, status, message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? User.fromJson(json['body']) : null;
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

class User {
  int id;
  String authToken;
  String name;
  String email;
  String phone;
  String role;
  String fcmToken;
  String image;

 

  User(
      {required this.id,
      required this.authToken,
      required this.name,
      required this.email,
      required this.phone,
      required this.role,
      required this.fcmToken,
      required this.image});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        authToken = json['auth_token'] ?? '',
        phone = json['phone'] ?? '',
        email = json['email'] ?? '',
        role = json['role'] ?? '',
        id = json['id'] ?? '',
        fcmToken = json['fcm_token'] ?? '',
        image = json['image'] ?? '';

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
    data['auth_token'] = authToken;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['id'] = id;
    data['fcm_token'] = fcmToken;
    data['image'] = image;
    return data;
  }
}
