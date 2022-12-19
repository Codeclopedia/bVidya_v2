class LMSLiveClassesResponse {
  final String? status;
  final String? message;

  final LMSLiveClasses? body;

  LMSLiveClassesResponse({this.body, this.status, this.message});

  LMSLiveClassesResponse.fromJson(Map<String, dynamic> json)
      : body = LMSLiveClasses.fromJson(json['body']),
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

class LMSLiveClasses {
  final List<LMSLiveClass>? liveClasses;
  LMSLiveClasses({this.liveClasses});

  LMSLiveClasses.fromJson(Map<String, dynamic> json)
      : liveClasses = List.from(json['live_classes'])
            .map((e) => LMSLiveClass.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['live_classes'] = liveClasses?.map((e) => e.toJson()).toList();
    return data;
  }
}

class LMSLiveClass {
  final int? id;
  final int? userId;
  final String? streamId;
  final String? name;
  final String? description;
  final String? image;
  final String? status;
  final String? startsAt;

  LMSLiveClass({
    this.id,
    this.userId,
    this.name,
    this.streamId,
    this.description,
    this.image,
    this.status,
    this.startsAt,
  });

  LMSLiveClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        streamId = json['stream_id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        status = json['status'],
        startsAt = json['starts_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['user_id'] = userId;
    json['stream_id'] = streamId;
    json['name'] = name;
    json['description'] = description;
    json['image'] = image;
    json['status'] = status;
    json['starts_at'] = startsAt;
    return json;
  }
}
