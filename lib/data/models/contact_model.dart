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
  final String? role;
  final String? apnToken;
  bool? ispinned;
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
      this.apnToken,
      this.role,
      this.fcmToken,
      this.bio,
      this.ispinned});

  Contacts.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        role = json['role'],
        apnToken = json['apn_token'],
        status = ContactStatus.values[(json['status'] as int?) ?? 0],
        fcmToken = json['fcm_token'],
        profileImage = json['profile_image'],
        bio = json['bio'],
        ispinned = json['is_pinned'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['apn_token'] = apnToken;
    data['status'] = status.index;
    data['fcm_token'] = fcmToken;
    data['profile_image'] = profileImage;
    data['bio'] = bio;
    data['is_pinned'] = ispinned;
    return data;
  }
}
