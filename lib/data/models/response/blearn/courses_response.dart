class CoursesResponse {
  final Courses? body;
  final String? status;
  final String? message;

  CoursesResponse({
    this.body,
    this.message,
    this.status,
  });

  CoursesResponse.fromJson(Map<String, dynamic> json)
      : body = Courses.fromJson(json['body']),
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

class Courses {
  final List<Course>? courses;
  Courses({
    this.courses,
  });

  Courses.fromJson(Map<String, dynamic> json)
      : courses =
            List.from(json['courses']).map((e) => Course.fromJson(e)).toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['courses'] = courses?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Course {
  final int id;
  final String name;
  final int categoryId;
  final int subcategoryId;
  final int userId;
  final String description;
  final String objective;
  final String benefit;
  final String audience;
  final String level;
  final String language;
  final String duration;
  final String numberOfLesson;
  final String image;
  final String slug;
  final String rating;
  final int ratingCount;
  final String views;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String instructorName;
  final String instructorImage;

  Course({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.userId,
    required this.description,
    required this.objective,
    required this.benefit,
    required this.audience,
    required this.level,
    required this.language,
    required this.duration,
    required this.numberOfLesson,
    required this.image,
    required this.slug,
    required this.rating,
    required this.ratingCount,
    required this.views,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.instructorName,
    required this.instructorImage,
  });

  Course.fromJson(Map<String, dynamic> json)
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
        updatedAt = json['updated_at'],
        instructorName = json['instructor_name'],
        instructorImage = json['instructor_image'];

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
    data['instructor_name'] = instructorName;
    data['instructor_image'] = instructorImage;
    return data;
  }
}

// class Course {
//   final int? id;
//   final String? name;
//   final int? categoryId;
//   final int? subcategoryId;
//   final int? userId;
//   final String? description;
//   final String? objective;
//   final String? benefit;
//   final String? audience;
//   final String? level;
//   final String? language;
//   final String? duration;
//   final String? numberOfLesson;
//   final String? image;
//   final String? slug;
//   final String? createdAt;
//   final String? updatedAt;
//   final String? instructorName;
//   final String? instructorImage;

//   Course(
//       {this.id,
//       this.name,
//       this.categoryId,
//       this.subcategoryId,
//       this.userId,
//       this.description,
//       this.objective,
//       this.benefit,
//       this.audience,
//       this.level,
//       this.language,
//       this.duration,
//       this.numberOfLesson,
//       this.image,
//       this.slug,
//       this.createdAt,
//       this.updatedAt,
//       this.instructorName,
//       this.instructorImage});

//   Course.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         categoryId = json['category_id'],
//         subcategoryId = json['subcategory_id'],
//         userId = json['user_id'],
//         description = json['description'],
//         objective = json['objective'],
//         benefit = json['benefit'],
//         audience = json['audience'],
//         level = json['level'],
//         language = json['language'],
//         duration = json['duration'],
//         numberOfLesson = json['number_of_lesson'],
//         image = json['image'],
//         slug = json['slug'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'],
//         instructorName = json['instructor_name'],
//         instructorImage = json['instructor_image'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['category_id'] = categoryId;
//     data['subcategory_id'] = subcategoryId;
//     data['user_id'] = userId;
//     data['description'] = description;
//     data['objective'] = objective;
//     data['benefit'] = benefit;
//     data['audience'] = audience;
//     data['level'] = level;
//     data['language'] = language;
//     data['duration'] = duration;
//     data['number_of_lesson'] = numberOfLesson;
//     data['image'] = image;
//     data['slug'] = slug;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['instructor_name'] = instructorName;
//     data['instructor_image'] = instructorImage;
//     return data;
//   }
// }
