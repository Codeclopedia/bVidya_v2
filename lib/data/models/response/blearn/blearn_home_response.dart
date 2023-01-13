// To parse this JSON data, do
//
//     final blearnHomeResponse = blearnHomeResponseFromJson(jsonString);

import 'dart:convert';

import '../../models.dart';

class BlearnHomeResponse {
  BlearnHomeResponse({
    this.body,
    this.status,
  });

  BlearnHomeBody? body;
  String? status;

  factory BlearnHomeResponse.fromRawJson(String str) =>
      BlearnHomeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlearnHomeResponse.fromJson(Map<String, dynamic> json) =>
      BlearnHomeResponse(
        body:
            json["body"] == null ? null : BlearnHomeBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body!.toJson(),
        "status": status,
      };
}

class BlearnHomeBody {
  BlearnHomeBody({
    this.banners,
    this.homeCategories,
    this.trendingCourses,
    this.mostViewedCourses,
    this.recentlyAddedCourses,
    this.topCourses,
    this.bestInstructors,
    this.upcomingWebinars,
  });

  List<BlearnBanner?>? banners;
  List<HomeCategory?>? homeCategories;
  List<Course?>? trendingCourses;
  List<Course?>? mostViewedCourses;
  List<Course?>? recentlyAddedCourses;
  List<Course?>? topCourses;
  List<Instructor?>? bestInstructors;
  List<UpcomingWebinar?>? upcomingWebinars;

  factory BlearnHomeBody.fromRawJson(String str) =>
      BlearnHomeBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlearnHomeBody.fromJson(Map<String, dynamic> json) => BlearnHomeBody(
        banners: json["banners"] == null
            ? []
            : List<BlearnBanner?>.from(
                json["banners"]!.map((x) => BlearnBanner.fromJson(x))),
        homeCategories: json["home_categories"] == null
            ? []
            : List<HomeCategory?>.from(
                json["home_categories"]!.map((x) => HomeCategory.fromJson(x))),
        trendingCourses: json["trending_courses"] == null
            ? []
            : List<Course?>.from(
                json["trending_courses"]!.map((x) => Course.fromJson(x))),
        mostViewedCourses: json["most_viewed_courses"] == null
            ? []
            : List<Course?>.from(
                json["most_viewed_courses"]!.map((x) => Course.fromJson(x))),
        recentlyAddedCourses: json["recently_added_courses"] == null
            ? []
            : List<Course?>.from(
                json["recently_added_courses"]!.map((x) => Course.fromJson(x))),
        topCourses: json["top_courses"] == null
            ? []
            : List<Course?>.from(
                json["top_courses"]!.map((x) => Course.fromJson(x))),
        bestInstructors: json["best_instructors"] == null
            ? []
            : List<Instructor?>.from(
                json["best_instructors"]!.map((x) => Instructor.fromJson(x))),
        upcomingWebinars: json["upcoming_webinars"] == null
            ? []
            : List<UpcomingWebinar?>.from(json["upcoming_webinars"]!
                .map((x) => UpcomingWebinar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banners": banners == null
            ? []
            : List<dynamic>.from(banners!.map((x) => x!.toJson())),
        "home_categories": homeCategories == null
            ? []
            : List<dynamic>.from(homeCategories!.map((x) => x!.toJson())),
        "trending_courses": trendingCourses == null
            ? []
            : List<dynamic>.from(trendingCourses!.map((x) => x!.toJson())),
        "most_viewed_courses": mostViewedCourses == null
            ? []
            : List<dynamic>.from(mostViewedCourses!.map((x) => x!.toJson())),
        "recently_added_courses": recentlyAddedCourses == null
            ? []
            : List<dynamic>.from(recentlyAddedCourses!.map((x) => x!.toJson())),
        "top_courses": topCourses == null
            ? []
            : List<dynamic>.from(topCourses!.map((x) => x!.toJson())),
        "best_instructors": bestInstructors == null
            ? []
            : List<dynamic>.from(bestInstructors!.map((x) => x!.toJson())),
        "upcoming_webinars": upcomingWebinars == null
            ? []
            : List<dynamic>.from(upcomingWebinars!.map((x) => x!.toJson())),
      };
}

class BlearnBanner {
  BlearnBanner({
    this.id,
    this.name,
    this.image,
    this.actionWeb,
    this.actionApp,
  });

  int? id;
  String? name;
  String? image;
  String? actionWeb;
  String? actionApp;

  factory BlearnBanner.fromRawJson(String str) =>
      BlearnBanner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlearnBanner.fromJson(Map<String, dynamic> json) => BlearnBanner(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        actionWeb: json["action_web"],
        actionApp: json["action_app"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "action_web": actionWeb,
        "action_app": actionApp,
      };
}

class HomeCategory {
  HomeCategory({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory HomeCategory.fromRawJson(String str) =>
      HomeCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

enum Language { HINDI, ENGLISH }

final languageValues =
    EnumValues({"English": Language.ENGLISH, "Hindi": Language.HINDI});

enum Level { BEGINNER, INTERMEDIATE }

final levelValues = EnumValues(
    {"Beginner": Level.BEGINNER, "Intermediate": Level.INTERMEDIATE});

enum Status { PUBLISH }

final statusValues = EnumValues({"publish": Status.PUBLISH});

enum Views { THE_1_K }

final viewsValues = EnumValues({"1k": Views.THE_1_K});

class UpcomingWebinar {
  UpcomingWebinar({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.image,
    this.status,
    this.startsAt,
  });

  int? id;
  int? userId;
  String? name;
  String? description;
  String? image;
  String? status;
  DateTime? startsAt;

  factory UpcomingWebinar.fromRawJson(String str) =>
      UpcomingWebinar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpcomingWebinar.fromJson(Map<String, dynamic> json) =>
      UpcomingWebinar(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        startsAt: DateTime.parse(json["starts_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "image": image,
        "status": status,
        "starts_at": startsAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
