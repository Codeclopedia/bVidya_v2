// To parse this JSON data, do
//
//     final requestedClassesResponse = requestedClassesResponseFromJson(jsonString);

import 'dart:convert';

class RequestedClassesResponse {
  RequestedClassesResponse({
    this.body,
    this.status,
  });

  RequestedClassesBody? body;
  String? status;

  factory RequestedClassesResponse.fromRawJson(String str) =>
      RequestedClassesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestedClassesResponse.fromJson(Map<String, dynamic> json) =>
      RequestedClassesResponse(
        body: RequestedClassesBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class RequestedClassesBody {
  RequestedClassesBody({
    this.requestedClasses,
  });

  List<RequestedClass>? requestedClasses;

  factory RequestedClassesBody.fromRawJson(String str) =>
      RequestedClassesBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestedClassesBody.fromJson(Map<String, dynamic> json) =>
      RequestedClassesBody(
        requestedClasses: List<RequestedClass>.from(
            json["personal_classes"].map((x) => RequestedClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "personal_classes":
            List<dynamic>.from(requestedClasses?.map((x) => x.toJson()) ?? {}),
      };
}

class RequestedClass {
  RequestedClass({
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
    this.instructorName,
    this.instructorImage,
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
  String? instructorName;
  String? instructorImage;
  String? preferred_date_time;

  factory RequestedClass.fromRawJson(String str) =>
      RequestedClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestedClass.fromJson(Map<String, dynamic> json) => RequestedClass(
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
        instructorName: json["instructor_name"],
        instructorImage: json["instructor_image"],
        preferred_date_time: json["preferred_date_time"].toString(),
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
        "instructor_name": instructorName,
        "instructor_image": instructorImage,
        "preferred_date_time": preferred_date_time,
      };
}
