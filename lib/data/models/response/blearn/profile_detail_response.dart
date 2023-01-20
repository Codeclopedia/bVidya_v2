import '../profile/user_profile_response.dart';
import 'courses_response.dart';
// import 'dart:convert';

class ProfileDetailResponse {
  ProfileDataBody? body;
  String? status;
  String? message;

  ProfileDetailResponse({this.body, this.status, this.message});

  // factory ProfileDetailResponse.fromRawJson(String str) =>
  //     ProfileDetailResponse.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProfileDetailResponse(
        body: ProfileDataBody.fromJson(json["body"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() =>
      {"body": body?.toJson(), "status": status, 'message': message};
}

class ProfileDataBody {
  ProfileDataBody({
    this.profile,
    this.followers,
    this.watchtime,
    this.courses,
    this.meetings,
    this.webinar,
    this.liked,
  });

  Profile? profile;
  List<Follower>? followers;
  List<Watchtime>? watchtime;
  List<Course>? courses;
  List<InstructorMeeting>? meetings;
  List<dynamic>? webinar;
  List<dynamic>? liked;

  // factory ProfileDataBody.fromRawJson(String str) =>
  //     ProfileDataBody.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory ProfileDataBody.fromJson(Map<String, dynamic> json) =>
      ProfileDataBody(
        profile: Profile.fromJson(json["profile"]),
        followers: List<Follower>.from(
            json["followers"].map((x) => Follower.fromJson(x))),
        watchtime: List<Watchtime>.from(
            json["watchtime"].map((x) => Watchtime.fromJson(x))),
        courses:
            List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
        meetings: List<InstructorMeeting>.from(
            json["meetings"].map((x) => InstructorMeeting.fromJson(x))),
        webinar: List<dynamic>.from(json["webinar"].map((x) => x)),
        liked: List<dynamic>.from(json["liked"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile?.toJson(),
        "followers": List<dynamic>.from(followers!.map((x) => x.toJson())),
        "watchtime": List<dynamic>.from(watchtime!.map((x) => x.toJson())),
        "courses": List<dynamic>.from(courses!.map((x) => x.toJson())),
        "meetings": List<dynamic>.from(meetings!.map((x) => x.toJson())),
        "webinar": List<dynamic>.from(webinar!.map((x) => x)),
        "liked": List<dynamic>.from(liked!.map((x) => x)),
      };
}

// class Course {
//     Course({
//         this.id,
//         this.name,
//         this.categoryId,
//         this.subcategoryId,
//         this.userId,
//         this.description,
//         this.objective,
//         this.benefit,
//         this.audience,
//         this.level,
//         this.language,
//         this.duration,
//         this.numberOfLesson,
//         this.image,
//         this.slug,
//         this.rating,
//         this.ratingCount,
//         this.views,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//     });

//     int id;
//     String name;
//     int categoryId;
//     int subcategoryId;
//     int userId;
//     String description;
//     String objective;
//     String benefit;
//     String audience;
//     String level;
//     String language;
//     String duration;
//     String numberOfLesson;
//     String image;
//     String slug;
//     String rating;
//     int ratingCount;
//     String views;
//     String status;
//     DateTime createdAt;
//     DateTime updatedAt;

//     factory Course.fromRawJson(String str) => Course.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Course.fromJson(Map<String, dynamic> json) => Course(
//         id: json["id"],
//         name: json["name"],
//         categoryId: json["category_id"],
//         subcategoryId: json["subcategory_id"],
//         userId: json["user_id"],
//         description: json["description"],
//         objective: json["objective"],
//         benefit: json["benefit"],
//         audience: json["audience"],
//         level: json["level"],
//         language: json["language"],
//         duration: json["duration"],
//         numberOfLesson: json["number_of_lesson"],
//         image: json["image"],
//         slug: json["slug"],
//         rating: json["rating"],
//         ratingCount: json["rating_count"],
//         views: json["views"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "category_id": categoryId,
//         "subcategory_id": subcategoryId,
//         "user_id": userId,
//         "description": description,
//         "objective": objective,
//         "benefit": benefit,
//         "audience": audience,
//         "level": level,
//         "language": language,
//         "duration": duration,
//         "number_of_lesson": numberOfLesson,
//         "image": image,
//         "slug": slug,
//         "rating": rating,
//         "rating_count": ratingCount,
//         "views": views,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//     };
// }

class Follower {
  Follower({
    this.count,
  });

  int? count;

  // factory Follower.fromRawJson(String str) =>
  //     Follower.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class InstructorMeeting {
  InstructorMeeting({
    this.id,
    this.userId,
    this.meetingId,
    this.name,
    this.description,
    this.status,
    this.streamChannel,
    this.streamToken,
    this.startsAt,
    this.endsAt,
    this.repeats,
    this.disableVideo,
    this.disableAudio,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? meetingId;
  String? name;
  String? description;
  String? status;
  dynamic streamChannel;
  dynamic streamToken;
  DateTime? startsAt;
  DateTime? endsAt;
  String? repeats;
  String? disableVideo;
  String? disableAudio;
  DateTime? createdAt;
  DateTime? updatedAt;

  // factory InstructorMeeting.fromRawJson(String str) =>
  //     InstructorMeeting.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory InstructorMeeting.fromJson(Map<String, dynamic> json) =>
      InstructorMeeting(
        id: json["id"],
        userId: json["user_id"],
        meetingId: json["meeting_id"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
        streamChannel: json["stream_channel"],
        streamToken: json["stream_token"],
        startsAt: DateTime.parse(json["starts_at"]),
        endsAt: DateTime.parse(json["ends_at"]),
        repeats: json["repeats"],
        disableVideo: json["disable_video"],
        disableAudio: json["disable_audio"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "meeting_id": meetingId,
        "name": name,
        "description": description,
        "status": status,
        "stream_channel": streamChannel,
        "stream_token": streamToken,
        "starts_at": startsAt?.toIso8601String(),
        "ends_at": endsAt?.toIso8601String(),
        "repeats": repeats,
        "disable_video": disableVideo,
        "disable_audio": disableAudio,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

// class Profile {
//     Profile({
//         this.name,
//         this.phone,
//         this.email,
//         this.referralCode,
//         this.gender,
//         this.age,
//         this.language,
//         this.bio,
//         this.occupation,
//         this.experience,
//         this.specialization,
//         this.city,
//         this.state,
//         this.country,
//         this.address,
//         this.image,
//         this.twitterUrl,
//         this.facebookUrl,
//         this.instagramUrl,
//         this.youtubeUrl,
//         this.websiteUrl,
//     });

//     String name;
//     String phone;
//     String email;
//     String referralCode;
//     String gender;
//     String age;
//     String language;
//     String bio;
//     String occupation;
//     String experience;
//     String specialization;
//     String city;
//     String state;
//     String country;
//     String address;
//     String image;
//     String twitterUrl;
//     String facebookUrl;
//     String instagramUrl;
//     String youtubeUrl;
//     String websiteUrl;

//     factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Profile.fromJson(Map<String, dynamic> json) => Profile(
//         name: json["name"],
//         phone: json["phone"],
//         email: json["email"],
//         referralCode: json["referral_code"],
//         gender: json["gender"],
//         age: json["age"],
//         language: json["language"],
//         bio: json["bio"],
//         occupation: json["occupation"],
//         experience: json["experience"],
//         specialization: json["specialization"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         address: json["address"],
//         image: json["image"],
//         twitterUrl: json["twitter_url"],
//         facebookUrl: json["facebook_url"],
//         instagramUrl: json["instagram_url"],
//         youtubeUrl: json["youtube_url"],
//         websiteUrl: json["website_url"],
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "phone": phone,
//         "email": email,
//         "referral_code": referralCode,
//         "gender": gender,
//         "age": age,
//         "language": language,
//         "bio": bio,
//         "occupation": occupation,
//         "experience": experience,
//         "specialization": specialization,
//         "city": city,
//         "state": state,
//         "country": country,
//         "address": address,
//         "image": image,
//         "twitter_url": twitterUrl,
//         "facebook_url": facebookUrl,
//         "instagram_url": instagramUrl,
//         "youtube_url": youtubeUrl,
//         "website_url": websiteUrl,
//     };
// }

class Watchtime {
  Watchtime({
    this.total,
  });

  String? total;

  // factory Watchtime.fromRawJson(String str) =>
  //     Watchtime.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Watchtime.fromJson(Map<String, dynamic> json) => Watchtime(
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
      };
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
