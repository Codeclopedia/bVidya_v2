// To parse this JSON data, do
//
//     final schduledClassesModel = schduledClassesModelFromJson(jsonString);

import 'dart:convert';

class SchduledClassesModel {
  SchduledClassesModel({
    this.body,
    this.status,
  });

  ScheduledClassBody? body;
  String? status;

  factory SchduledClassesModel.fromRawJson(String str) =>
      SchduledClassesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SchduledClassesModel.fromJson(Map<String, dynamic> json) =>
      SchduledClassesModel(
        body: ScheduledClassBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class ScheduledClassBody {
  ScheduledClassBody({
    this.scheduledRequests,
  });

  List<ScheduledRequest>? scheduledRequests;

  factory ScheduledClassBody.fromRawJson(String str) =>
      ScheduledClassBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledClassBody.fromJson(Map<String, dynamic> json) =>
      ScheduledClassBody(
        scheduledRequests: List<ScheduledRequest>.from(
            json["scheduled_requests"]
                .map((x) => ScheduledRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduled_requests":
            List<dynamic>.from(scheduledRequests?.map((x) => x.toJson()) ?? []),
      };
}

class ScheduledRequest {
  ScheduledRequest({
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
    this.instructor,
    this.scheduledClass,
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
  Instructor? instructor;
  ScheduledClass? scheduledClass;

  factory ScheduledRequest.fromRawJson(String str) =>
      ScheduledRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledRequest.fromJson(Map<String, dynamic> json) =>
      ScheduledRequest(
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
        instructor: Instructor.fromJson(json["instructor"]),
        scheduledClass: ScheduledClass.fromJson(json["scheduled_class"]),
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
        "instructor": instructor?.toJson(),
        "scheduled_class": scheduledClass?.toJson(),
      };
}

class Instructor {
  Instructor({
    this.name,
    this.id,
  });

  String? name;
  int? id;

  factory Instructor.fromRawJson(String str) =>
      Instructor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class ScheduledClass {
  ScheduledClass({
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
  List<Participant>? participants;

  factory ScheduledClass.fromRawJson(String str) =>
      ScheduledClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledClass.fromJson(Map<String, dynamic> json) => ScheduledClass(
        id: json["id"],
        instructorId: json["instructor_id"],
        meetingId: json["meeting_id"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        scheduledAt: DateTime.parse(json["scheduled_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        participants: List<Participant>.from(
            json["participants"].map((x) => Participant.fromJson(x))),
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

class Participant {
  Participant({
    this.scheduleId,
    this.userId,
    this.user,
    this.userImage,
  });

  int? scheduleId;
  int? userId;
  Instructor? user;
  UserImage? userImage;

  factory Participant.fromRawJson(String str) =>
      Participant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        scheduleId: json["schedule_id"],
        userId: json["user_id"],
        user: Instructor.fromJson(json["user"]),
        userImage: UserImage.fromJson(json["user_image"]),
      );

  Map<String, dynamic> toJson() => {
        "schedule_id": scheduleId,
        "user_id": userId,
        "user": user?.toJson(),
        "user_image": userImage?.toJson(),
      };
}

class UserImage {
  UserImage({
    this.image,
    this.userId,
  });

  String? image;
  int? userId;

  factory UserImage.fromRawJson(String str) =>
      UserImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        image: json["image"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "user_id": userId,
      };
}
