class CourseDetailResponse {
  CourseDetailBody? body;
  String? status;
  String? message;

  CourseDetailResponse({this.body, this.status, this.message});

  CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    body =
        json['body'] != null ? CourseDetailBody.fromJson(json['body']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class CourseDetailBody {
  List<CourseDtl>? courses;
  List<CourseFeedback>? courseFeedback;
  bool? isWishlisted;
  bool? isSubscribed;
  int? subscribers;

  CourseDetailBody(
      {this.courses,
      this.courseFeedback,
      this.isWishlisted,
      this.isSubscribed,
      this.subscribers});

  CourseDetailBody.fromJson(Map<String, dynamic> json) {
    courses = <CourseDtl>[];
    if (json['course'] != null) {
      json['course'].forEach((v) {
        courses?.add(CourseDtl.fromJson(v));
      });
    }
    courseFeedback = <CourseFeedback>[];
    if (json['course_feedback'] != null) {
      json['course_feedback'].forEach((v) {
        // print('${jsonEncode(v)}');
        courseFeedback?.add(CourseFeedback.fromJson(v));
      });
    }
    isWishlisted = json['is_wishlisted'];
    isSubscribed = json['is_subscribed'];
    subscribers = json['subscribers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courses != null) {
      data['course'] = courses!.map((v) => v.toJson()).toList();
    }
    if (courseFeedback != null) {
      data['course_feedback'] = courseFeedback!.map((v) => v.toJson()).toList();
    }
    data['is_wishlisted'] = isWishlisted;
    data['is_subscribed'] = isSubscribed;
    data['subscribers'] = subscribers;
    return data;
  }
}

class CourseDtl {
  int? id;
  String? name;
  int? categoryId;
  int? subcategoryId;
  int? userId;
  String? description;
  String? objective;
  String? benefit;
  String? audience;
  String? level;
  String? language;
  String? duration;
  String? numberOfLesson;
  String? image;
  String? slug;
  String? rating;
  int? ratingCount;
  String? views;
  String? status;
  String? createdAt;
  String? updatedAt;

  CourseDtl(
      {this.id,
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
      this.updatedAt});

  CourseDtl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    userId = json['user_id'];
    description = json['description'];
    objective = json['objective'];
    benefit = json['benefit'];
    audience = json['audience'];
    level = json['level'];
    language = json['language'];
    duration = json['duration'];
    numberOfLesson = json['number_of_lesson'];
    image = json['image'];
    slug = json['slug'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    views = json['views'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class CourseFeedback {
  int? id;
  int? courseId;
  int? rating;
  String? comment;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? image;

  CourseFeedback(
      {this.id,
      this.courseId,
      this.rating,
      this.comment,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.image});

  CourseFeedback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    rating = json['rating'];
    comment = json['comment'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course_id'] = courseId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
