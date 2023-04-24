// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

import '../../models.dart';

class DashboardResponse {
  DashboardResponse({
    this.body,
    this.status,
  });

  DashBoardBody? body;
  String? status;

  factory DashboardResponse.fromRawJson(String str) =>
      DashboardResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        body: DashBoardBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class DashBoardBody {
  DashBoardBody({
    this.courses,
    this.courseCount,
    this.lessons,
    this.meetings,
    this.broadcasts,
    this.totalWatchtime,
    this.payoutRate,
    this.watchtimeTrends,
    this.personalClassRequests,
    this.personalClassEarning,
    this.followers,
    this.subscribers,
  });

  List<Course>? courses;
  int? courseCount;
  int? lessons;
  int? meetings;
  int? broadcasts;
  int? totalWatchtime;
  double? payoutRate;
  List<String>? watchtimeTrends;
  int? personalClassRequests;
  int? personalClassEarning;
  int? followers;
  int? subscribers;

  factory DashBoardBody.fromRawJson(String str) =>
      DashBoardBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashBoardBody.fromJson(Map<String, dynamic> json) => DashBoardBody(
        courses:
            List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
        courseCount: json["course_count"],
        lessons: json["lessons"],
        meetings: json["meetings"],
        broadcasts: json["broadcasts"],
        totalWatchtime: json["total_watchtime"],
        payoutRate: json["payout_rate"].toDouble(),
        watchtimeTrends:
            List<String>.from(json["watchtime_trends"].map((x) => x)),
        personalClassRequests: json["personal_class_requests"],
        personalClassEarning: json["personal_class_earning"],
        followers: json["followers"],
        subscribers: json["subscribers"],
      );

  Map<String, dynamic> toJson() => {
        "courses":
            List<dynamic>.from(courses?.map((x) => x.toJson()) ?? [Course()]),
        "course_count": courseCount,
        "lessons": lessons,
        "meetings": meetings,
        "broadcasts": broadcasts,
        "total_watchtime": totalWatchtime,
        "payout_rate": payoutRate,
        "watchtime_trends":
            List<dynamic>.from(watchtimeTrends?.map((x) => x) ?? []),
        "personal_class_requests": personalClassRequests,
        "personal_class_earning": personalClassEarning,
        "followers": followers,
        "subscribers": subscribers,
      };
}
