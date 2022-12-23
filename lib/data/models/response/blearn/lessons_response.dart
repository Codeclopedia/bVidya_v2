class LessonsResponse {
  final Lessons? body;
  final String? status;
  final String? message;

  LessonsResponse({
    this.body,
    this.message,
    this.status,
  });

  LessonsResponse.fromJson(Map<String, dynamic> json)
      : body = json['body']!=null?Lessons.fromJson(json['body']):null,
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.toJson();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class Lessons {
  final List<Lesson>? lessons;
  Lessons({
    this.lessons,
  });

  Lessons.fromJson(Map<String, dynamic> json)
      : lessons =
            List.from(json['lessons']).map((e) => Lesson.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lessons'] = lessons?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Lesson {
  int id;
  String name;
  dynamic courseId;
  dynamic userId;
  String description;
  String image;
  dynamic videoId;
  String duration;
  String createdAt;
  String updatedAt;
  String videoUrl;

  Lesson(
      {required this.id,
      required this.name,
      required this.courseId,
      required this.userId,
      required this.description,
      required this.image,
      required this.videoId,
      required this.duration,
      required this.createdAt,
      required this.updatedAt,
      required this.videoUrl});

  Lesson.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        courseId = json['course_id'],
        userId = json['user_id'],
        description = json['description'],
        image = json['image'],
        videoId = json['video_id'],
        duration = json['duration'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        videoUrl = json['video_url'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['course_id'] = courseId;
    data['user_id'] = userId;
    data['description'] = description;
    data['image'] = image;
    data['video_id'] = videoId;
    data['duration'] = duration;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['video_url'] = videoUrl;
    return data;
  }
}
