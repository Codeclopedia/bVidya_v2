import 'dart:convert';

import '/data/models/response/bchat/p2p_call_response.dart';
import '/core/helpers/call_helper.dart';

enum CallStatus { missed, ongoing, end }

class CallMessegeBody {
  final String callId;
  final String fromName;
  final String toName;
  final String toImage;
  final String fromImage;
  final CallBody callBody;
  final CallStatus status;
  final int duration;

  final Map<String, dynamic> ext;
  final CallType callType;

  CallMessegeBody({
    required this.callId,
    required this.fromName,
    required this.toName,
    required this.fromImage,
    required this.toImage,
    required this.status,
    required this.duration,
    required this.callType,
    required this.callBody,
    required this.ext,
  });

  CallMessegeBody.fromJson(Map<String, dynamic> json)
      : callId = json['call_id'],
        fromName = json['from_name'],
        toName = json['to_name'],
        toImage = json['image'],
        fromImage = json['from_image'],
        duration = json['duration'] ?? 0,
        status = CallStatus.values[json['status'] as int],
        callType = CallType.values[json['call_type'] as int],
        callBody =CallBody.fromJson(jsonDecode(json['call_body'])),
        ext = json['ext'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['call_id'] = callId;
    data['from_name'] = fromName;
    data['to_name'] = toName;
    data['image'] = toImage;
    data['from_image'] = fromImage;
    data['duration'] = duration;
    data['status'] = status.index;
    data['call_type'] = callType.index;
    data['call_body'] = jsonEncode(callBody.toJson());
    data['ext'] = ext;
    return data;
  }
}
