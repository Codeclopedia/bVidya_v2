// To parse this JSON data, do
//
//     final classRequestResponse = classRequestResponseFromJson(jsonString);

import 'dart:convert';

class ClassRequestResponse {
  ClassRequestResponse({
    this.body,
    this.status,
  });

  ClassRequestBody? body;
  String? status;

  factory ClassRequestResponse.fromRawJson(String str) =>
      ClassRequestResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassRequestResponse.fromJson(Map<String, dynamic> json) =>
      ClassRequestResponse(
        body: ClassRequestBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class ClassRequestBody {
  ClassRequestBody({
    this.personalClasses,
  });

  List<PersonalClass>? personalClasses;

  factory ClassRequestBody.fromRawJson(String str) =>
      ClassRequestBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassRequestBody.fromJson(Map<String, dynamic> json) =>
      ClassRequestBody(
        personalClasses: List<PersonalClass>.from(
            json["personal_classes"].map((x) => PersonalClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "personal_classes":
            List<dynamic>.from(personalClasses?.map((x) => x.toJson()) ?? {}),
      };
}

class PersonalClass {
  PersonalClass({
    this.id,
    this.userId,
    this.instructorId,
    this.topic,
    this.description,
    this.type,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.studentName,
    this.studentImage,
    this.preferred_date_time,
  });

  int? id;
  int? userId;
  int? instructorId;
  String? topic;
  String? description;
  String? type;
  String? status;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? studentName;
  String? studentImage;
  String? preferred_date_time;

  factory PersonalClass.fromRawJson(String str) =>
      PersonalClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonalClass.fromJson(Map<String, dynamic> json) => PersonalClass(
        id: json["id"],
        userId: json["user_id"],
        instructorId: json["instructor_id"],
        topic: json["topic"],
        description: json["description"],
        type: json["type"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        studentName: json["student_name"],
        studentImage: json["student_image"],
        preferred_date_time: json["preferred_date_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "instructor_id": instructorId,
        "topic": topic,
        "description": description,
        "type": type,
        "status": status,
        "reason": reason,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "student_name": studentName,
        "student_image": studentImage,
        "preferred_date_time": preferred_date_time,
      };
}
