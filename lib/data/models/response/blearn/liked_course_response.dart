class LikedCourseResponse {
  LikedCourseResponse({this.body, this.status, this.message});

  LikedSource? body;
  String? status;
  String? message;

  factory LikedCourseResponse.fromJson(Map<String, dynamic> json) =>
      LikedCourseResponse(
        body: json["body"] != null ? LikedSource.fromJson(json["body"]) : null,
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
        "message": message,
      };
}

class LikedSource {
  LikedSource({
    required this.userId,
    required this.courseId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  int userId;
  String courseId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory LikedSource.fromJson(Map<String, dynamic> json) => LikedSource(
        userId: json["user_id"],
        courseId: json["course_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "course_id": courseId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
