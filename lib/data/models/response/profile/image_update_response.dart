class ImageUpdateResponse {
  final String? status;
  final String? message;
  final String? image;

  ImageUpdateResponse({this.message, this.status, this.image});

  ImageUpdateResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['body'] = image;
    return data;
  }
}
