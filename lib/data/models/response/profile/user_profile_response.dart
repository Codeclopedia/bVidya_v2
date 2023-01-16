class UserProfileResponse {
  final Profile? body;
  final String? status;
  final String? message;

  UserProfileResponse({
    this.body,
    this.message,
    this.status,
  });

  UserProfileResponse.fromJson(Map<String, dynamic> json)
      : body = json['body'] != null ? Profile.fromJson(json['body']) : null,
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

class Profile {
  final String? name;
  final String? phone;
  final String? email;
  final String? gender;
  final dynamic age;
  final String? language;
  final String? bio;
  final String? occupation;
  final dynamic experience;
  final String? specialization;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final String? image;
  final String? twitterUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? websiteUrl;

  Profile(
      {this.name,
      this.phone,
      this.email,
      this.gender,
      this.age,
      this.language,
      this.bio,
      this.occupation,
      this.experience,
      this.specialization,
      this.city,
      this.state,
      this.country,
      this.address,
      this.image,
      this.twitterUrl,
      this.facebookUrl,
      this.instagramUrl,
      this.youtubeUrl,
      this.websiteUrl});

  Profile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        email = json['email'],
        gender = json['gender'],
        age = json['age'],
        language = json['language'],
        bio = json['bio'],
        occupation = json['occupation'],
        experience = json['experience'],
        specialization = json['specialization'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        address = json['address'],
        image = json['image'],
        twitterUrl = json['twitter_url'],
        facebookUrl = json['facebook_url'],
        instagramUrl = json['instagram_url'],
        youtubeUrl = json['youtube_url'],
        websiteUrl = json['website_url'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['gender'] = gender;
    data['age'] = age;
    data['language'] = language;
    data['bio'] = bio;
    data['occupation'] = occupation;
    data['experience'] = experience;
    data['specialization'] = specialization;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['address'] = address;
    data['image'] = image;
    data['twitter_url'] = twitterUrl;
    data['facebook_url'] = facebookUrl;
    data['instagram_url'] = instagramUrl;
    data['youtube_url'] = youtubeUrl;
    data['website_url'] = websiteUrl;
    return data;
  }
}
