// To parse this JSON data, do
//
//     final schduledClassesInstructorModel = schduledClassesInstructorModelFromJson(jsonString);

import 'dart:convert';

class SchduledClassesInstructorModel {
  SchduledClassesInstructorModel({
    this.body,
    this.status,
  });

  ScheduledClassInstructorBody? body;
  String? status;

  factory SchduledClassesInstructorModel.fromRawJson(String str) =>
      SchduledClassesInstructorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SchduledClassesInstructorModel.fromJson(Map<String, dynamic> json) =>
      SchduledClassesInstructorModel(
        body: ScheduledClassInstructorBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class ScheduledClassInstructorBody {
  ScheduledClassInstructorBody({
    this.scheduledClasses,
  });

  List<ScheduledClassInstructor>? scheduledClasses;

  factory ScheduledClassInstructorBody.fromRawJson(String str) =>
      ScheduledClassInstructorBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledClassInstructorBody.fromJson(Map<String, dynamic> json) =>
      ScheduledClassInstructorBody(
        scheduledClasses: List<ScheduledClassInstructor>.from(
            json["scheduled_classes"]
                .map((x) => ScheduledClassInstructor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduled_classes":
            List<dynamic>.from(scheduledClasses?.map((x) => x.toJson()) ?? []),
      };
}

class ScheduledClassInstructor {
  ScheduledClassInstructor({
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
  List<ParticipantInstructorModel>? participants;

  factory ScheduledClassInstructor.fromRawJson(String str) =>
      ScheduledClassInstructor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduledClassInstructor.fromJson(Map<String, dynamic> json) =>
      ScheduledClassInstructor(
        id: json["id"],
        instructorId: json["instructor_id"],
        meetingId: json["meeting_id"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        scheduledAt: DateTime.parse(json["scheduled_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        participants: List<ParticipantInstructorModel>.from(json["participants"]
            .map((x) => ParticipantInstructorModel.fromJson(x))),
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

class ParticipantInstructorModel {
  ParticipantInstructorModel({
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
  Instructor? user;
  RImage? userImage;
  Instructor? instructor;
  RImage? instructorImage;

  factory ParticipantInstructorModel.fromRawJson(String str) =>
      ParticipantInstructorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParticipantInstructorModel.fromJson(Map<String, dynamic> json) =>
      ParticipantInstructorModel(
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
        user: Instructor.fromJson(json["user"]),
        userImage: RImage.fromJson(json["user_image"]),
        instructor: Instructor.fromJson(json["instructor"]),
        instructorImage: RImage.fromJson(json["instructor_image"]),
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
