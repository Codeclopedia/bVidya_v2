// To parse this JSON data, do
//
//     final schduledClassesModel = schduledClassesModelFromJson(jsonString);

import 'dart:convert';

import 'scheduled_class_instructor_model.dart';

class StudentScheduledClasses {
  StudentScheduledClasses({
    this.body,
    this.status,
  });

  StudentScheduledClassBody? body;
  String? status;

  factory StudentScheduledClasses.fromRawJson(String str) =>
      StudentScheduledClasses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentScheduledClasses.fromJson(Map<String, dynamic> json) =>
      StudentScheduledClasses(
        body: StudentScheduledClassBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class StudentScheduledClassBody {
  StudentScheduledClassBody({
    this.scheduledRequests,
  });

  List<StudentScheduledClassDetails>? scheduledRequests;

  factory StudentScheduledClassBody.fromRawJson(String str) =>
      StudentScheduledClassBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentScheduledClassBody.fromJson(Map<String, dynamic> json) =>
      StudentScheduledClassBody(
        scheduledRequests: List<StudentScheduledClassDetails>.from(
            json["scheduled_requests"]
                .map((x) => StudentScheduledClassDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduled_requests":
            List<dynamic>.from(scheduledRequests?.map((x) => x.toJson()) ?? []),
      };
}

class StudentScheduledClassDetails {
  StudentScheduledClassDetails({
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
  UserDetails? instructor;
  ClassDetails? scheduledClass;

  factory StudentScheduledClassDetails.fromRawJson(String str) =>
      StudentScheduledClassDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentScheduledClassDetails.fromJson(Map<String, dynamic> json) =>
      StudentScheduledClassDetails(
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
        instructor: UserDetails.fromJson(json["instructor"]),
        scheduledClass: ClassDetails.fromJson(json["scheduled_class"]),
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

class ClassDetails {
  ClassDetails({
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
  List<ClassParticipant>? participants;

  factory ClassDetails.fromRawJson(String str) =>
      ClassDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassDetails.fromJson(Map<String, dynamic> json) => ClassDetails(
        id: json["id"],
        instructorId: json["instructor_id"],
        meetingId: json["meeting_id"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        scheduledAt: DateTime.parse(json["scheduled_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        participants: List<ClassParticipant>.from(
            json["participants"].map((x) => ClassParticipant.fromJson(x))),
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

class ClassParticipant {
  ClassParticipant({
    this.scheduleId,
    this.userId,
    this.user,
    this.userImage,
    this.paymentDetail,
  });

  int? scheduleId;
  int? userId;
  UserDetails? user;
  UserImage? userImage;
  PaymentDetail? paymentDetail;

  factory ClassParticipant.fromRawJson(String str) =>
      ClassParticipant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassParticipant.fromJson(Map<String, dynamic> json) =>
      ClassParticipant(
          scheduleId: json["schedule_id"],
          userId: json["user_id"],
          user: UserDetails.fromJson(json["user"]),
          userImage: UserImage.fromJson(json["user_image"]),
          paymentDetail: PaymentDetail.fromJson(json["payment_detail"]));

  Map<String, dynamic> toJson() => {
        "schedule_id": scheduleId,
        "user_id": userId,
        "user": user?.toJson(),
        "user_image": userImage?.toJson(),
        "payment_detail": paymentDetail?.toJson(),
      };
}

class PaymentDetail {
  PaymentDetail({
    this.scheduledClassId,
    this.paymentLinkShortUrl,
    this.razorpayPaymentLinkStatus,
    this.status,
  });

  int? scheduledClassId;
  String? paymentLinkShortUrl;
  String? razorpayPaymentLinkStatus;
  String? status;

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        scheduledClassId: json["scheduled_class_id"],
        paymentLinkShortUrl: json["payment_link_short_url"],
        razorpayPaymentLinkStatus: json["razorpay_payment_link_status"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "scheduled_class_id": scheduledClassId,
        "payment_link_short_url": paymentLinkShortUrl,
        "razorpay_payment_link_status": razorpayPaymentLinkStatus,
        "status": status,
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
