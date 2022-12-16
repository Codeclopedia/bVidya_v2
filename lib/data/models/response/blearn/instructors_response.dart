class IntructionsResponse {
  final Instructors? body;
  final String? status;
  final String? message;

  IntructionsResponse({
    this.body,
    this.message,
    this.status,
  });

  IntructionsResponse.fromJson(Map<String, dynamic> json)
      : body = Instructors.fromJson(json['body']),
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

class Instructors {
  final List<Instructor>? categories;
  Instructors({
    this.categories,
  });

  Instructors.fromJson(Map<String, dynamic> json)
      : categories = List.from(json['instructors'])
            .map((e) => Instructor.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['instructors'] = categories?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Instructor {
  int? id;
  String? name;
  String? image;
  String? occupation;
  String? experience;
  String? specialization;

  Instructor({
    this.id,
    this.name,
    this.image,
    this.occupation,
    this.experience,
    this.specialization,
  });

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    occupation = json['occupation'];
    experience = json['experience'];
    specialization = json['specialization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['image'] = image;
    json['occupation'] = occupation;
    json['experience'] = experience;
    json['specialization'] = specialization;
    return json;
  }
}
