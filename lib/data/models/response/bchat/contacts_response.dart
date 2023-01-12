class ContactListResponse {
  final ContactsBody? body;
  final String? status;
  final String? message;

  ContactListResponse({this.body, this.status, this.message});

  ContactListResponse.fromJson(Map<String, dynamic> json)
      : body =
            json['body'] != null ? ContactsBody.fromJson(json['body']) : null,
        message = json['message'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['body'] = body?.toJson();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class ContactsBody {
  final List<Contact>? contacts;

  ContactsBody({this.contacts});

  ContactsBody.fromJson(Map<String, dynamic> json)
      : contacts = json["details"] != null
            ? List.from(json["details"].map((x) => Contact.fromJson(x)))
            : null;
  //   if (json['contacts'] != null) {
  //     contacts = <Contacts>[];
  //     json['contacts'].forEach((v) {
  //       contacts!.add(new Contacts.fromJson(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['details'] = contacts?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contact {
  final int userId;
  final String name;
  final String? email;
  final String? phone;
  // final String peerId;
  final String? fcmToken;
  final String profileImage;
  final String? bio;

  Contact(
      {required this.userId,
      required this.name,
      // required this.peerId,
      required this.profileImage,
      this.email,
      this.phone,
      this.fcmToken,
      this.bio});

  Contact.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        // peerId = json['peer_id'],
        fcmToken = json['fcm_token'],
        profileImage = json['profile_image'],
        bio = json['bio'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    // data['peer_id'] = peerId;
    data['fcm_token'] = fcmToken;
    data['profile_image'] = profileImage;
    data['bio'] = bio;
    return data;
  }
}
