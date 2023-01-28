// To parse this JSON data, do
//
//     final profileDetailResponse = profileDetailResponseFromJson(jsonString);

import 'dart:convert';

import '../../models.dart';

class ProfileDetailResponse {
  ProfileDetailResponse({
    this.body,
    this.status,
  });

  ProfileDetailBody? body;
  String? status;

  factory ProfileDetailResponse.fromRawJson(String str) =>
      ProfileDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProfileDetailResponse(
        body: ProfileDetailBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class ProfileDetailBody {
  ProfileDetailBody({
    this.profile,
    this.courses,
    this.courseFeedbacks,
    this.followersCount,
    this.followingsCount,
    this.isFollowed,
    this.totalWatchtime,
  });

  Profile? profile;
  List<Course>? courses;
  List<CourseFeedback>? courseFeedbacks;
  int? followersCount;
  int? followingsCount;
  bool? isFollowed;
  String? totalWatchtime;

  factory ProfileDetailBody.fromRawJson(String str) =>
      ProfileDetailBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileDetailBody.fromJson(Map<String, dynamic> json) =>
      ProfileDetailBody(
        profile: Profile.fromJson(json["profile"]),
        courses:
            List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
        courseFeedbacks: List<CourseFeedback>.from(
            json["course_feedbacks"].map((x) => CourseFeedback.fromJson(x))),
        followersCount: json["followers_count"],
        followingsCount: json["followings_count"],
        isFollowed: json["is_followed"],
        totalWatchtime: json["total_watchtime"],
      );

  Map<String, dynamic> toJson() => {
        "profile": profile?.toJson(),
        "courses": List<dynamic>.from(courses?.map((x) => x.toJson()) ?? {}),
        "course_feedbacks":
            List<dynamic>.from(courseFeedbacks?.map((x) => x.toJson()) ?? {}),
        "followers_count": followersCount,
        "followings_count": followingsCount,
        "is_followed": isFollowed,
        "total_watchtime": totalWatchtime,
      };
}
