class SearchContactResponse {
  SearchContactResponse({this.body, this.status, this.message});

  final SearchContactBody? body;
  final String? status;
  final String? message;

  SearchContactResponse.fromJson(Map<String, dynamic> json)
      : body = json["body"] != null
            ? SearchContactBody.fromJson(json["body"])
            : null,
        message = json["message"],
        status = json["status"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.toJson();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class SearchContactBody {
  final List<Contact>? contacts;
  SearchContactBody({
    this.contacts,
  });

  SearchContactBody.fromJson(Map<String, dynamic> json)
      : contacts = json["contacts"] != null
            ? List.from(json["contacts"].map((x) => Contact.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contacts'] = contacts?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Contact {
  final int? userId;
  final String? name;
  final String? phone;
  final String? email;

  Contact({
    this.userId,
    this.name,
    this.phone,
    this.email,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : userId = json["user_id"],
        name = json["name"],
        phone = json["phone"],
        email = json["email"];

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "phone": phone,
        "email": email,
      };
}
