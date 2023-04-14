class BaseResponseWatchTime {
  final String? status;
  final String? message;
  final bool? stop;

  BaseResponseWatchTime({this.message, this.status, this.stop});

  BaseResponseWatchTime.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        stop = json['stop'] == 0 ? false : true;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['stop'] = stop;
    return data;
  }
}
