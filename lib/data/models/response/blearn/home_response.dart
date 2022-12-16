import '../../models.dart';

class HomeResponse {
  HomeBody? body;
  String? status;
  String? message;
  HomeResponse({this.body, this.status, this.message});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    body = HomeBody.fromJson(json['body']);
    status = json['status'] as String?;
    message = json['message'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['body'] = body?.toJson();
    json['status'] = status;
    json['message'] = message;
    return json;
  }
}

class HomeBody {
  List<String>? banners;
  List<FeaturedCategories>? featuredCategories;
  List<Course>? featuredCourses;
  List<Course>? popularCourses;
  List<Instructor>? popularInstructors;
  List<LMSLiveClass>? liveClasses;

  HomeBody({
    this.banners,
    this.featuredCategories,
    this.featuredCourses,
    this.popularCourses,
    this.popularInstructors,
    this.liveClasses,
  });

  HomeBody.fromJson(Map<String, dynamic> json) {
    // banners =
    //     (json['banners'] as List?)?.map((dynamic e) => e as String).toList();
    // featuredCategories = (json['featured_categories'] as List?)
    //     ?.map((dynamic e) =>
    //         FeaturedCategories.fromJson(e as Map<String, dynamic>))
    //     .toList();
    // featuredCourses = (json['featured_courses'] as List?)
    //     ?.map((dynamic e) => Course.fromJson(e as Map<String, dynamic>))
    //     .toList();

    // popularCourses = (json['popular_courses'] as List?)
    //     ?.map((dynamic e) => Course.fromJson(e as Map<String, dynamic>))
    //     .toList();

    // (json['popular_instructors'] as List?)
    //     ?.map((dynamic e) => Instructor.fromJson(e as Map<String, dynamic>))
    //     .toList();

    //  (json['live_classes'] as List?)
    //     ?.map((dynamic e) => LiveClass.fromJson(e as Map<String, dynamic>))
    //     .toList();

    banners = List.from(json['banners']).map((e) => e as String).toList();

    featuredCategories = List.from(json['featured_categories'])
        .map((e) => FeaturedCategories.fromJson(e))
        .toList();

    featuredCourses = List.from(json['featured_courses'])
        .map((e) => Course.fromJson(e))
        .toList();

    popularCourses = List.from(json['popular_courses'])
        .map((e) => Course.fromJson(e))
        .toList();

    popularInstructors = List.from(json['popular_instructors'])
        .map((e) => Instructor.fromJson(e))
        .toList();

    liveClasses = List.from(json['live_classes'])
        .map((e) => LMSLiveClass.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['banners'] = banners;
    json['featured_categories'] =
        featuredCategories?.map((e) => e.toJson()).toList();
    json['featured_courses'] = featuredCourses?.map((e) => e.toJson()).toList();
    json['popular_courses'] = popularCourses?.map((e) => e.toJson()).toList();
    json['popular_instructors'] =
        popularInstructors?.map((e) => e.toJson()).toList();
    json['live_classes'] = liveClasses?.map((e) => e.toJson()).toList();
    return json;
  }
}

class FeaturedCategories {
  int? id;
  String? name;
  String? image;

  FeaturedCategories({
    this.id,
    this.name,
    this.image,
  });

  FeaturedCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['image'] = image;
    return json;
  }
}

// class Instructor {
//   int? id;
//   String? name;
//   String? image;
//   String? occupation;
//   String? experience;
//   String? specialization;

//   Instructor({
//     this.id,
//     this.name,
//     this.image,
//     this.occupation,
//     this.experience,
//     this.specialization,
//   });

//   Instructor.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     image = json['image'];
//     occupation = json['occupation'];
//     experience = json['experience'];
//     specialization = json['specialization'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['id'] = id;
//     json['name'] = name;
//     json['image'] = image;
//     json['occupation'] = occupation;
//     json['experience'] = experience;
//     json['specialization'] = specialization;
//     return json;
//   }
// }
