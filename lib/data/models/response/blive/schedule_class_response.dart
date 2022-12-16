class ScheduleClassResponse {
  final String? status;
  final String? message;
  final ScheduleClass? body;

  ScheduleClassResponse({this.message, this.status, this.body});

  ScheduleClassResponse.fromJson(Map<String, dynamic> json)
      : body = ScheduleClass.fromJson(json['body']),
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

class ScheduleClass {
  ScheduleClass.fromJson(dynamic json)
      : _userId = json['user_id'],
        _name = json['name'],
        _description = json['description'],
        _image = json['image'],
        _status = json['status'],
        _startsAt = json['starts_at'],
        _updatedAt = json['updated_at'],
        _createdAt = json['created_at'],
        _id = json['id'];

  final int _userId;
  final String _name;
  final String _description;
  final String _image;
  final String _status;
  final String _startsAt;
  final String _updatedAt;
  final String _createdAt;
  final int _id;

  ScheduleClass(this._userId, this._name, this._description, this._image, this._status,
      this._startsAt, this._updatedAt, this._createdAt, this._id);

  int get userId => _userId;
  String get name => _name;
  String get description => _description;
  String get image => _image;
  String get status => _status;
  String get startsAt => _startsAt;
  String get updatedAt => _updatedAt;
  String get createdAt => _createdAt;
  int get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['description'] = _description;
    map['image'] = _image;
    map['status'] = _status;
    map['starts_at'] = _startsAt;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
