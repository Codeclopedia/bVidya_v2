class UpdateProfileResponse {
  final UpdatedProfile? body;
  final String? status;
  final String? message;

  UpdateProfileResponse({
    this.body,
    this.message,
    this.status,
  });

  UpdateProfileResponse.fromJson(Map<String, dynamic> json)
      : body = json['body'] != null ? UpdatedProfile.fromJson(json['body']) : null,
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

class UpdatedProfile {
  final String? name;
  final String? phone;
  final String? email;
  final String? gender;
  final dynamic age;
  final String? language;
  final String? bio;
  final String? occupation;

  final String? city;
  final String? state;
  final String? country;
  final String? address;

  UpdatedProfile(
      {this.name,
      this.phone,
      this.email,
      this.gender,
      this.age,
      this.language,
      this.bio,
      this.occupation,
      this.city,
      this.state,
      this.country,
      this.address,
      });

  UpdatedProfile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        email = json['email'],
        gender = json['gender'],
        age = json['age'],
        language = json['language'],
        bio = json['bio'],
        occupation = json['occupation'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        address = json['address'];

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
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['address'] = address;
    
    return data;
  }
}
