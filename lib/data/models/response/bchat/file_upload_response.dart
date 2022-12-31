class FileUploadResponse {
  final String? status;
  final String? message;
  final ImageBody? body;

  FileUploadResponse({this.message, this.status, this.body});

  FileUploadResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        body = json['body'] != null ? ImageBody.fromJson(json['body']) : null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['body'] = body?.toJson();
    return data;
  }
}

class ImageBody {
  final String source;
  ImageBody(this.source);

  ImageBody.fromJson(Map<String, dynamic> json) : source = json['source'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['source'] = source;
    return map;
  }
}
