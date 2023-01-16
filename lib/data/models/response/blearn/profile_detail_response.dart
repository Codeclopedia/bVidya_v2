import '../profile/user_profile_response.dart';
import 'courses_response.dart';

class ProfileDetailResponse {
  ProfileDataBody? body;
  String? status;
  String? message;

  ProfileDetailResponse({this.body, this.status, this.message});

  ProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? ProfileDataBody.fromJson(json['body']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class ProfileDataBody {
  Profile? profile;
  List<Course>? courses;
  int? followersCount;
  int? followingsCount;
  bool? isFollowed;
  String? totalWatchtime;

  ProfileDataBody(
      {this.profile,
      this.courses,
      this.followersCount,
      this.followingsCount,
      this.isFollowed,
      this.totalWatchtime});

  ProfileDataBody.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    courses = <Course>[];

    if (json['courses'] != null) {
      json['courses'].forEach((v) {
        courses?.add(Course.fromJson(v));
      });
    }
    followersCount = json['followers_count'];
    followingsCount = json['followings_count'];
    isFollowed = json['is_followed'];
    totalWatchtime = json['total_watchtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile'] = profile?.toJson();

    data['courses'] = courses?.map((v) => v.toJson()).toList();
    data['followers_count'] = followersCount;
    data['followings_count'] = followingsCount;
    data['is_followed'] = isFollowed;
    data['total_watchtime'] = totalWatchtime;
    return data;
  }
}

// class Profile {
//   String? name;
//   String? phone;
//   String? email;
//   String? referralCode;
//   String? gender;
//   String? age;
//   String? language;
//   String? bio;
//   String? occupation;
//   String? experience;
//   String? specialization;
//   String? city;
//   String? state;
//   String? country;
//   String? address;
//   String? image;
//   String? twitterUrl;
//   String? facebookUrl;
//   String? instagramUrl;
//   String? youtubeUrl;
//   String? websiteUrl;
// 
//   Profile(
//       {this.name,
//       this.phone,
//       this.email,
//       this.referralCode,
//       this.gender,
//       this.age,
//       this.language,
//       this.bio,
//       this.occupation,
//       this.experience,
//       this.specialization,
//       this.city,
//       this.state,
//       this.country,
//       this.address,
//       this.image,
//       this.twitterUrl,
//       this.facebookUrl,
//       this.instagramUrl,
//       this.youtubeUrl,
//       this.websiteUrl});

//   Profile.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     phone = json['phone'];
//     email = json['email'];
//     referralCode = json['referral_code'];
//     gender = json['gender'];
//     age = json['age'];
//     language = json['language'];
//     bio = json['bio'];
//     occupation = json['occupation'];
//     experience = json['experience'];
//     specialization = json['specialization'];
//     city = json['city'];
//     state = json['state'];
//     country = json['country'];
//     address = json['address'];
//     image = json['image'];
//     twitterUrl = json['twitter_url'];
//     facebookUrl = json['facebook_url'];
//     instagramUrl = json['instagram_url'];
//     youtubeUrl = json['youtube_url'];
//     websiteUrl = json['website_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['phone'] = phone;
//     data['email'] = email;
//     data['referral_code'] = referralCode;
//     data['gender'] = gender;
//     data['age'] = age;
//     data['language'] = language;
//     data['bio'] = bio;
//     data['occupation'] = occupation;
//     data['experience'] = experience;
//     data['specialization'] = specialization;
//     data['city'] = city;
//     data['state'] = state;
//     data['country'] = country;
//     data['address'] = address;
//     data['image'] = image;
//     data['twitter_url'] = twitterUrl;
//     data['facebook_url'] = facebookUrl;
//     data['instagram_url'] = instagramUrl;
//     data['youtube_url'] = youtubeUrl;
//     data['website_url'] = websiteUrl;
//     return data;
//   }
// }

// class Courses {
//   int? id;
//   String? name;
//   int? categoryId;
//   int? subcategoryId;
//   int? userId;
//   String? description;
//   String? objective;
//   String? benefit;
//   String? audience;
//   String? level;
//   String? language;
//   String? duration;
//   String? numberOfLesson;
//   String? image;
//   String? slug;
//   String? rating;
//   int? ratingCount;
//   String? views;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? instructorName;
//   String? instructorImage;

//   Courses(
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
//       this.rating,
//       this.ratingCount,
//       this.views,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.instructorName,
//       this.instructorImage});

//   Courses.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     categoryId = json['category_id'];
//     subcategoryId = json['subcategory_id'];
//     userId = json['user_id'];
//     description = json['description'];
//     objective = json['objective'];
//     benefit = json['benefit'];
//     audience = json['audience'];
//     level = json['level'];
//     language = json['language'];
//     duration = json['duration'];
//     numberOfLesson = json['number_of_lesson'];
//     image = json['image'];
//     slug = json['slug'];
//     rating = json['rating'];
//     ratingCount = json['rating_count'];
//     views = json['views'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     instructorName = json['instructor_name'];
//     instructorImage = json['instructor_image'];
//   }

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
//     data['rating'] = rating;
//     data['rating_count'] = ratingCount;
//     data['views'] = views;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['instructor_name'] = instructorName;
//     data['instructor_image'] = instructorImage;
//     return data;
//   }
// }
