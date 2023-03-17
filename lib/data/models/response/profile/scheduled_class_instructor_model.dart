// To parse this JSON data, do
//
//     final schduledClassesInstructorModel = schduledClassesInstructorModelFromJson(jsonString);

import 'dart:convert';

import 'schduled_classes_model.dart';

class InstructorScheduledClasses {
  InstructorScheduledClasses({
    this.body,
    this.status,
  });

  InstructorScheduledClassBody? body;
  String? status;

  factory InstructorScheduledClasses.fromRawJson(String str) =>
      InstructorScheduledClasses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstructorScheduledClasses.fromJson(Map<String, dynamic> json) =>
      InstructorScheduledClasses(
        body: InstructorScheduledClassBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class InstructorScheduledClassBody {
  InstructorScheduledClassBody({
    this.scheduledClasses,
  });

  List<InstructorScheduledClass>? scheduledClasses;

  factory InstructorScheduledClassBody.fromRawJson(String str) =>
      InstructorScheduledClassBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstructorScheduledClassBody.fromJson(Map<String, dynamic> json) =>
      InstructorScheduledClassBody(
        scheduledClasses: List<InstructorScheduledClass>.from(
            json["scheduled_classes"]
                .map((x) => InstructorScheduledClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduled_classes":
            List<dynamic>.from(scheduledClasses?.map((x) => x.toJson()) ?? []),
      };
}

class InstructorScheduledClass {
  InstructorScheduledClass({
    this.id,
    this.instructorId,
    this.meetingId,
    this.title,
    this.type,
    this.status,
    this.scheduledAt,
    this.createdAt,
    this.updatedAt,
    this.participants,
  });

  int? id;
  int? instructorId;
  int? meetingId;
  String? title;
  String? type;
  String? status;
  DateTime? scheduledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ScheduledClassParticipantDetail>? participants;

  factory InstructorScheduledClass.fromRawJson(String str) =>
      InstructorScheduledClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstructorScheduledClass.fromJson(Map<String, dynamic> json) =>
      InstructorScheduledClass(
        id: json["id"],
        instructorId: json["instructor_id"],
        meetingId: json["meeting_id"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        scheduledAt: DateTime.parse(json["scheduled_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        participants: List<ScheduledClassParticipantDetail>.from(
            json["participants"]
                .map((x) => ScheduledClassParticipantDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "instructor_id": instructorId,
        "meeting_id": meetingId,
        "title": title,
        "type": type,
        "status": status,
        "scheduled_at": scheduledAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "participants":
            List<dynamic>.from(participants?.map((x) => x.toJson()) ?? []),
      };
}

class ScheduledClassParticipantDetail {
  ScheduledClassParticipantDetail({
    this.id,
    this.userId,
    this.instructorId,
    this.scheduleId,
    this.topic,
    this.description,
    this.type,
    this.status,
    this.reason,
    this.preferredDateTime,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.userImage,
    this.instructor,
    this.instructorImage,
    this.paymentDetail,
  });

  int? id;
  int? userId;
  int? instructorId;
  int? scheduleId;
  String? topic;
  String? description;
  String? type;
  String? status;
  String? reason;
  DateTime? preferredDateTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserDetails? user;
  RImage? userImage;
  UserDetails? instructor;
  RImage? instructorImage;
  PaymentDetail? paymentDetail;

  factory ScheduledClassParticipantDetail.fromRawJson(String str) =>
      ScheduledClassParticipantDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledClassParticipantDetail.fromJson(Map<String, dynamic> json) =>
      ScheduledClassParticipantDetail(
        id: json["id"],
        userId: json["user_id"],
        instructorId: json["instructor_id"],
        scheduleId: json["schedule_id"],
        topic: json["topic"],
        description: json["description"],
        type: json["type"],
        status: json["status"],
        reason: json["reason"],
        preferredDateTime: DateTime.parse(json["preferred_date_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: UserDetails.fromJson(json["user"]),
        userImage: RImage.fromJson(json["user_image"]),
        instructor: UserDetails.fromJson(json["instructor"]),
        instructorImage: RImage.fromJson(json["instructor_image"]),
        paymentDetail: PaymentDetail.fromJson(json["payment_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "instructor_id": instructorId,
        "schedule_id": scheduleId,
        "topic": topic,
        "description": description,
        "type": type,
        "status": status,
        "reason": reason,
        "preferred_date_time": preferredDateTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "user_image": userImage?.toJson(),
        "instructor": instructor?.toJson(),
        "instructor_image": instructorImage?.toJson(),
        "payment_detail": paymentDetail?.toJson(),
      };
}

class UserDetails {
  UserDetails({
    this.name,
    this.id,
  });

  String? name;
  int? id;

  factory UserDetails.fromRawJson(String str) =>
      UserDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class RImage {
  RImage({
    this.image,
    this.userId,
  });

  String? image;
  int? userId;

  factory RImage.fromRawJson(String str) => RImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RImage.fromJson(Map<String, dynamic> json) => RImage(
        image: json["image"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "user_id": userId,
      };
}
