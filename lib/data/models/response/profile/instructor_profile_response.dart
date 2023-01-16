// // import '../bmeet/start_meeting_response.dart';

// class InstructorProfileResponse {
//   final ProfileBody? body;
//   final String? status;
//   final String? message;

//   InstructorProfileResponse({
//     this.body,
//     this.message,
//     this.status,
//   });

//   InstructorProfileResponse.fromJson(Map<String, dynamic> json)
//       : body = json['body'] != null ? ProfileBody.fromJson(json['body']) : null,
//         status = json['status'],
//         message = json['message'];

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['body'] = body?.toJson();
//     data['status'] = status;
//     data['message'] = message;
//     return data;
//   }
// }

// class ProfileBody {
//   Profile? profile;
//   List<Followers>? followers;
//   List<Watchtime>? watchtime;
//   List<InstructorCourse>? courses;
//   // List<Meeting>? meetings;
//   List<Webinar>? webinar;
//   List<Liked>? liked;

//   ProfileBody(
//       {this.profile,
//       this.followers,
//       this.watchtime,
//       this.courses,
//       // this.meetings,
//       this.webinar,
//       this.liked});

//   ProfileBody.fromJson(Map<String, dynamic> json) {
//     profile = Profile?.fromJson(json['profile']);
//     if (json['followers'] != null) {
//       followers = <Followers>[];
//       json['followers'].forEach((v) {
//         followers?.add(Followers.fromJson(v));
//       });
//     }
//     if (json['watchtime'] != null) {
//       watchtime = <Watchtime>[];
//       json['watchtime'].forEach((v) {
//         watchtime?.add(Watchtime.fromJson(v));
//       });
//     }
//     if (json['courses'] != null) {
//       courses = <InstructorCourse>[];
//       json['courses'].forEach((v) {
//         courses?.add(InstructorCourse.fromJson(v));
//       });
//     }
//     // if (json['meetings'] != null) {
//     //   meetings = <Meeting>[];
//     //   json['meetings'].forEach((v) {
//     //     meetings?.add(Meeting.fromJson(v));
//     //   });
//     // }
//     if (json['webinar'] != null) {
//       webinar = <Webinar>[];
//       json['webinar'].forEach((v) {
//         webinar?.add(Webinar.fromJson(v));
//       });
//     }
//     if (json['liked'] != null) {
//       liked = <Liked>[];
//       json['liked'].forEach((v) {
//         liked?.add(Liked.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (profile != null) {
//       data['profile'] = profile?.toJson();
//     }
//     if (followers != null) {
//       data['followers'] = followers?.map((v) => v.toJson()).toList();
//     }
//     if (watchtime != null) {
//       data['watchtime'] = watchtime?.map((v) => v.toJson()).toList();
//     }
//     if (courses != null) {
//       data['courses'] = courses?.map((v) => v.toJson()).toList();
//     }
//     // if (meetings != null) {
//     //   data['meetings'] = meetings?.map((v) => v.toJson()).toList();
//     // }
//     if (webinar != null) {
//       data['webinar'] = webinar?.map((v) => v.toJson()).toList();
//     }
//     if (liked != null) {
//       data['liked'] = liked?.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Profile {
//   final String? name;
//   final String? phone;
//   final String? email;
//   final String? gender;
//   final dynamic age;
//   final String? language;
//   final String? bio;
//   final String? occupation;
//   final dynamic experience;
//   final String? specialization;
//   final String? city;
//   final String? state;
//   final String? country;
//   final String? address;
//   final String? image;
//   final String? twitterUrl;
//   final String? facebookUrl;
//   final String? instagramUrl;
//   final String? youtubeUrl;
//   final String? websiteUrl;

//   Profile(
//       {this.name,
//       this.phone,
//       this.email,
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

//   Profile.fromJson(Map<String, dynamic> json)
//       : name = json['name'],
//         phone = json['phone'],
//         email = json['email'],
//         gender = json['gender'],
//         age = json['age'],
//         language = json['language'],
//         bio = json['bio'],
//         occupation = json['occupation'],
//         experience = json['experience'],
//         specialization = json['specialization'],
//         city = json['city'],
//         state = json['state'],
//         country = json['country'],
//         address = json['address'],
//         image = json['image'],
//         twitterUrl = json['twitter_url'],
//         facebookUrl = json['facebook_url'],
//         instagramUrl = json['instagram_url'],
//         youtubeUrl = json['youtube_url'],
//         websiteUrl = json['website_url'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['name'] = name;
//     data['phone'] = phone;
//     data['email'] = email;
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

// class Followers {
//   final dynamic count;

//   Followers({this.count});

//   Followers.fromJson(Map<String, dynamic> json) : count = json['count'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['count'] = count;
//     return data;
//   }
// }

// class Watchtime {
//   final dynamic total;

//   Watchtime({this.total});

//   Watchtime.fromJson(Map<String, dynamic> json) : total = json['total'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['total'] = total;
//     return data;
//   }
// }

// class Webinar {
//   final int? id;
//   final String? name;
//   final String? description;
//   final String? image;
//   final String? status;
//   final String? startsAt;
//   final String? endsAt;

//   Webinar(
//       {this.id,
//       this.name,
//       this.description,
//       this.image,
//       this.status,
//       this.startsAt,
//       this.endsAt});

//   Webinar.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         description = json['description'],
//         image = json['image'],
//         status = json['status'],
//         startsAt = json['starts_at'],
//         endsAt = json['ends_at'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = id;
//     data['name'] = name;
//     data['description'] = description;
//     data['image'] = image;
//     data['status'] = status;
//     data['starts_at'] = startsAt;
//     data['ends_at'] = endsAt;
//     return data;
//   }
// }

// class Liked {
//   final int? id;
//   final String? name;
//   final int? courseId;
//   final int? userId;
//   final String? description;
//   final String? image;
//   final String? videoId;
//   final String? duration;
//   final String? createdAt;
//   final String? updatedAt;
//   final dynamic rating;
//   final String? ratingCount;
//   final String? videoTitle;
//   final String? videoPath;

//   Liked(
//       {this.id,
//       this.name,
//       this.courseId,
//       this.userId,
//       this.description,
//       this.image,
//       this.videoId,
//       this.duration,
//       this.createdAt,
//       this.updatedAt,
//       this.rating,
//       this.ratingCount,
//       this.videoTitle,
//       this.videoPath});

//   Liked.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         courseId = json['course_id'],
//         userId = json['user_id'],
//         description = json['description'],
//         image = json['image'],
//         videoId = json['video_id'],
//         duration = json['duration'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'],
//         rating = json['rating'],
//         ratingCount = json['rating_count'],
//         videoTitle = json['video_title'],
//         videoPath = json['video_path'];
//   // }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = id;
//     data['name'] = name;
//     data['course_id'] = courseId;
//     data['user_id'] = userId;
//     data['description'] = description;
//     data['image'] = image;
//     data['video_id'] = videoId;
//     data['duration'] = duration;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['rating'] = rating;
//     data['rating_count'] = ratingCount;
//     data['video_title'] = videoTitle;
//     data['video_path'] = videoPath;
//     return data;
//   }
// }

// class InstructorCourse {
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
//   final String? rating;
//   final int? ratingCount;
//   final String? views;
//   final String? status;
//   final String? createdAt;
//   final String? updatedAt;

//   InstructorCourse({
//     this.id,
//     this.name,
//     this.categoryId,
//     this.subcategoryId,
//     this.userId,
//     this.description,
//     this.objective,
//     this.benefit,
//     this.audience,
//     this.level,
//     this.language,
//     this.duration,
//     this.numberOfLesson,
//     this.image,
//     this.slug,
//     this.rating,
//     this.ratingCount,
//     this.views,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });

//   InstructorCourse.fromJson(Map<String, dynamic> json)
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
//         rating = json['rating'],
//         ratingCount = json['rating_count'],
//         views = json['views'],
//         status = json['status'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'];

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
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
//     return data;
//   }
// }
