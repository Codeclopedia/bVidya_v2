// To parse this JSON data, do
//
//     final lessonsResponse = lessonsResponseFromJson(jsonString);

import 'dart:convert';

class LessonsResponse {
  LessonsResponse({
    this.body,
    this.status,
    this.message,
  });

  Lessons? body;
  String? status;
  String? message;

  factory LessonsResponse.fromRawJson(String str) =>
      LessonsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonsResponse.fromJson(Map<String, dynamic> json) =>
      LessonsResponse(
          body: Lessons.fromJson(json["body"]),
          status: json["status"],
          message: json["message"]);

  Map<String, dynamic> toJson() => {
        "body": body!.toJson(),
        "status": status,
        "message": message,
      };
}

class Lessons {
  Lessons({
    this.lessons,
  });

  List<Lesson>? lessons;

  factory Lessons.fromRawJson(String str) => Lessons.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lessons.fromJson(Map<String, dynamic> json) => Lessons(
        lessons:
            List<Lesson>.from(json["lessons"]!.map((x) => Lesson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lessons": lessons == null
            ? []
            : List<dynamic>.from(lessons!.map((x) => x.toJson())),
      };
}

class Lesson {
  Lesson({
    this.id,
    this.name,
    this.courseId,
    this.userId,
    this.description,
    this.image,
    this.videoId,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.videoUrl,
    this.playlist,
  });

  int? id;
  String? name;
  int? courseId;
  int? userId;
  String? description;
  String? image;
  int? videoId;
  String? duration;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? videoUrl;
  List<Playlist?>? playlist;

  factory Lesson.fromRawJson(String str) => Lesson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        name: json["name"],
        courseId: json["course_id"],
        userId: json["user_id"],
        description: json["description"],
        image: json["image"],
        videoId: json["video_id"],
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        videoUrl: json["video_url"],
        playlist: json["playlist"] == null
            ? []
            : List<Playlist?>.from(
                json["playlist"]!.map((x) => Playlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course_id": courseId,
        "user_id": userId,
        "description": description,
        "image": image,
        "video_id": videoId,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "video_url": videoUrl,
        "playlist": playlist == null
            ? []
            : List<dynamic>.from(playlist!.map((x) => x!.toJson())),
      };
}

class Playlist {
  Playlist({
    this.id,
    this.lessonId,
    this.videoId,
    this.order,
    this.title,
    this.location,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.media,
  });

  int? id;
  int? lessonId;
  int? videoId;
  int? order;
  String? title;
  String? location;
  String? duration;
  DateTime? createdAt;
  DateTime? updatedAt;
  MediaDetails? media;

  factory Playlist.fromRawJson(String str) =>
      Playlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        lessonId: json["lesson_id"],
        videoId: json["video_id"],
        order: json["order"],
        title: json["title"],
        location: json["location"],
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        media: MediaDetails.fromJson(json["media"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lesson_id": lessonId,
        "video_id": videoId,
        "order": order,
        "title": title,
        "location": location,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "media": media!.toJson(),
      };
}

class MediaDetails {
  MediaDetails({
    this.id,
    this.title,
    this.location,
  });

  int? id;
  String? title;
  String? location;

  factory MediaDetails.fromRawJson(String str) =>
      MediaDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        id: json["id"],
        title: json["title"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "location": location,
      };
}
