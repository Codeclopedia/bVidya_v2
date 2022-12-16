class LiveClassResponse {
  final String? status;
  final String? message;
  final LiveClassBody? body;

  LiveClassResponse({this.message, this.status, this.body});

  LiveClassResponse.fromJson(Map<String, dynamic> json)
      : body = LiveClassBody.fromJson(json['body']),
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

class LiveClassBody {
  final LiveClass liveClass;
  LiveClassBody({required this.liveClass});

  LiveClassBody.fromJson(Map<String, dynamic> json)
      : liveClass = LiveClass.fromJson(json['live_class']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['live_class'] = liveClass.toJson();
    return data;
  }
}

class LiveClass {
  final int id;
  final int userId;
  final String streamId;
  final String name;
  final String description;
  final String image;
  final String status;
  final String roomType;
  final String roomStatus;
  final String streamChannel;
  final String streamToken;
  final String recorderToken;
  final String startsAt;
  final String createdAt;
  final String updatedAt;

  LiveClass(
      this.id,
      this.userId,
      this.streamId,
      this.name,
      this.description,
      this.image,
      this.status,
      this.roomType,
      this.roomStatus,
      this.streamChannel,
      this.streamToken,
      this.recorderToken,
      this.startsAt,
      this.createdAt,
      this.updatedAt);

  LiveClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        streamId = json['stream_id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        status = json['status'],
        roomType = json['room_type'],
        roomStatus = json['room_status'],
        streamChannel = json['stream_channel'],
        streamToken = json['stream_token'],
        recorderToken = json['recorder_token'],
        startsAt = json['starts_at'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['stream_id'] = streamId;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['room_type'] = roomType;
    data['room_status'] = roomStatus;
    data['stream_channel'] = streamChannel;
    data['stream_token'] = streamToken;
    data['recorder_token'] = recorderToken;
    data['starts_at'] = startsAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
