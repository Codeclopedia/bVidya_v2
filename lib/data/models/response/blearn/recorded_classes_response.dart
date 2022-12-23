class RecordedClassesResponse {
  final RecordedClasses? body;
  final String? status;
  final String? message;

  RecordedClassesResponse({this.body, this.status, this.message});

  RecordedClassesResponse.fromJson(Map<String, dynamic> json)
      : body = json['body']!=null?RecordedClasses.fromJson(json['body']):null,
        message = json['message'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.toJson();
    data['status'] = status;
    return data;
  }
}

class RecordedClasses {
  final List<RecordedClass>? recordedClasses;
  final String? baseUrl;

  RecordedClasses({
    this.recordedClasses,
    this.baseUrl,
  });

  RecordedClasses.fromJson(Map<String, dynamic> json)
      : recordedClasses = List.from(json['recorded_classes'])
            .map((e) => RecordedClass.fromJson(e))
            .toList(),
        baseUrl = json['base_url'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['recorded_classes'] = recordedClasses?.map((e) => e.toJson()).toList();
    data['base_url'] = baseUrl;
    return data;
  }
}

class RecordedClass {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String url;
  final String image;

  RecordedClass({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.url,
    required this.image,
  });

  RecordedClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        name = json['name'],
        description = json['description'],
        url = json['url'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['description'] = description;
    data['url'] = url;
    data['image'] = image;
    return data;
  }
}
