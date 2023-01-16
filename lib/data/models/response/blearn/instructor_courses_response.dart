// import '../profile/instructor_profile_response.dart';
// import 'courses_response.dart';

class InstructorCoursesResponse {
  final List<InstructorCourse>? body;
  final String? status;
  final String? message;

  InstructorCoursesResponse({
    this.body,
    this.message,
    this.status,
  });

  InstructorCoursesResponse.fromJson(Map<String, dynamic> json)
      : body = json['body'] != null
            ? List.from(json['body'])
                .map((e) => InstructorCourse.fromJson(e))
                .toList()
            : null,
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.map((e) => e.toJson()).toList();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class InstructorCourse {
  final int? id;
  final String? name;
  final int? categoryId;
  final int? subcategoryId;
  final int? userId;
  final String? description;
  final String? objective;
  final String? benefit;
  final String? audience;
  final String? level;
  final String? language;
  final String? duration;
  final String? numberOfLesson;
  final String? image;
  final String? slug;
  final String? rating;
  final int? ratingCount;
  final String? views;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  InstructorCourse({
    this.id,
    this.name,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.description,
    this.objective,
    this.benefit,
    this.audience,
    this.level,
    this.language,
    this.duration,
    this.numberOfLesson,
    this.image,
    this.slug,
    this.rating,
    this.ratingCount,
    this.views,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  InstructorCourse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryId = json['category_id'],
        subcategoryId = json['subcategory_id'],
        userId = json['user_id'],
        description = json['description'],
        objective = json['objective'],
        benefit = json['benefit'],
        audience = json['audience'],
        level = json['level'],
        language = json['language'],
        duration = json['duration'],
        numberOfLesson = json['number_of_lesson'],
        image = json['image'],
        slug = json['slug'],
        rating = json['rating'],
        ratingCount = json['rating_count'],
        views = json['views'],
        status = json['status'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['user_id'] = userId;
    data['description'] = description;
    data['objective'] = objective;
    data['benefit'] = benefit;
    data['audience'] = audience;
    data['level'] = level;
    data['language'] = language;
    data['duration'] = duration;
    data['number_of_lesson'] = numberOfLesson;
    data['image'] = image;
    data['slug'] = slug;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    data['views'] = views;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
