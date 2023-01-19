// To parse this JSON data, do
//
//     final subscribedCoursesResponse = subscribedCoursesResponseFromJson(jsonString);

import 'dart:convert';

class SubscribedCoursesResponse {
  SubscribedCoursesResponse({
    this.body,
    this.status,
  });

  SubscribedCourseBody? body;
  String? status;

  factory SubscribedCoursesResponse.fromRawJson(String str) =>
      SubscribedCoursesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscribedCoursesResponse.fromJson(Map<String, dynamic> json) =>
      SubscribedCoursesResponse(
        body: SubscribedCourseBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body!.toJson(),
        "status": status,
      };
}

class SubscribedCourseBody {
  SubscribedCourseBody({
    this.subscribedCourses,
  });

  List<SubscribedCourse?>? subscribedCourses;

  factory SubscribedCourseBody.fromRawJson(String str) =>
      SubscribedCourseBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscribedCourseBody.fromJson(Map<String, dynamic> json) =>
      SubscribedCourseBody(
        subscribedCourses: json["subscribed_courses"] == null
            ? []
            : List<SubscribedCourse?>.from(json["subscribed_courses"]!
                .map((x) => SubscribedCourse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subscribed_courses": subscribedCourses == null
            ? []
            : List<dynamic>.from(subscribedCourses!.map((x) => x!.toJson())),
      };
}

class SubscribedCourse {
  SubscribedCourse({
    this.id,
    this.name,
    this.image,
    this.views,
    this.rating,
    this.progress,
    this.lessonsLeft,
  });

  int? id;
  String? name;
  String? image;
  String? views;
  String? rating;
  dynamic progress;
  int? lessonsLeft;

  factory SubscribedCourse.fromRawJson(String str) =>
      SubscribedCourse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscribedCourse.fromJson(Map<String, dynamic> json) =>
      SubscribedCourse(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        views: json["views"],
        rating: json["rating"],
        progress: json["progress"],
        lessonsLeft: json["lessons_left"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "views": views,
        "rating": rating,
        "progress": progress,
        "lessons_left": lessonsLeft,
      };
}
