// To parse this JSON data, do
//
//     final wishlistResponse = wishlistResponseFromJson(jsonString);

import 'dart:convert';

class WishlistResponse {
  WishlistResponse({
    this.body,
    this.status,
  });

  WishlistCoursesBody? body;
  String? status;

  factory WishlistResponse.fromRawJson(String str) =>
      WishlistResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        body: WishlistCoursesBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body!.toJson(),
        "status": status,
      };
}

class WishlistCoursesBody {
  WishlistCoursesBody({
    this.wishlistedCourses,
  });

  List<WishlistedCourse?>? wishlistedCourses;

  factory WishlistCoursesBody.fromRawJson(String str) =>
      WishlistCoursesBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishlistCoursesBody.fromJson(Map<String, dynamic> json) =>
      WishlistCoursesBody(
        wishlistedCourses: json["wishlisted_courses"] == null
            ? []
            : List<WishlistedCourse?>.from(json["wishlisted_courses"]!
                .map((x) => WishlistedCourse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wishlisted_courses": wishlistedCourses == null
            ? []
            : List<dynamic>.from(wishlistedCourses!.map((x) => x!.toJson())),
      };
}

class WishlistedCourse {
  WishlistedCourse({
    this.id,
    this.name,
    this.image,
    this.views,
    this.rating,
    this.duration,
    this.numberOfLesson,
  });

  int? id;
  String? name;
  String? image;
  String? views;
  String? rating;
  String? duration;
  String? numberOfLesson;

  factory WishlistedCourse.fromRawJson(String str) =>
      WishlistedCourse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishlistedCourse.fromJson(Map<String, dynamic> json) =>
      WishlistedCourse(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        views: json["views"],
        rating: json["rating"],
        duration: json["duration"],
        numberOfLesson: json["number_of_lesson"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "views": views,
        "rating": rating,
        "duration": duration,
        "number_of_lesson": numberOfLesson,
      };
}
