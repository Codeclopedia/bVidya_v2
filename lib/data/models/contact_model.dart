import 'models.dart';

enum ContactStatus {
  none,
  sentInvite,
  invited,
  friend,
  blocked,
  group,
  unknown,
  self,
}

class Contacts {
  final int userId;
  final String name;
  final String profileImage;
  final String? email;
  final String? phone;
  final String? fcmToken;
  final String? bio;
  final ContactStatus status;
  // final int statusIndex;
  // ContactStatus get status => ContactStatus.values[statusIndex];

  static Contacts fromContact(Contact cont, ContactStatus status) {
    return Contacts.fromJson(cont.toJson()..addAll({'status': status.index}));
  }

  Contacts(
      {required this.userId,
      required this.name,
      required this.status,
      // required this.peerId,
      required this.profileImage,
      this.email,
      this.phone,
      this.fcmToken,
      this.bio});

  Contacts.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        status = ContactStatus.values[(json['status'] as int?) ?? 0],
        fcmToken = json['fcm_token'],
        profileImage = json['profile_image'],
        bio = json['bio'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['status'] = status.index;
    data['fcm_token'] = fcmToken;
    data['profile_image'] = profileImage;
    data['bio'] = bio;
    return data;
  }
}
