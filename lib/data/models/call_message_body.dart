
import '/core/helpers/call_helper.dart';

enum CallStatus { missed, ongoing, end }

class CallMessegeBody {
  final String callId;
  final String fromName;
  final String toName;
  
  // final String fromFCM;
  // final String toFCM;
  final String? image;
  final CallStatus status;
  final int duration;
  // final CallBody callBody;
  final Map<String, dynamic> ext;
  final CallType callType;
  // final CallDirectionType callDirectionType;

  CallMessegeBody({
    required this.callId,
    required this.fromName,
    required this.toName,
    // required this.fromFCM,
    // required this.toFCM,
     
    required this.status,
    required this.duration,
    // required this.callDirectionType,
    required this.callType,
    // required this.callBody,
    required this.ext,
    required this.image,
  });

  // CallMessegeBody.fromCustom(ChatCustomMessageBody body):

  CallMessegeBody.fromJson(Map<String, dynamic> json)
      : callId = json['call_id'],
        fromName = json['from_name'],
        toName = json['to_name'],
        // fromFCM = json['from_fcm'],
        // toFCM = json['to_fcm'],
        image = json['image'],
        // callBody = CallBody.fromJson(jsonDecode(json['call_body'])),
        duration = json['duration'] ?? 0,
        status = CallStatus.values[json['status'] as int],
        callType = CallType.values[json['call_type'] as int],
        // callDirectionType =
        //     CallDirectionType.values[json['call_direction'] as int],
        ext = json['ext'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['call_id'] = callId;
    data['from_name'] = fromName;
    data['to_name'] = toName;
    // data['from_fcm'] = fromFCM;
    // data['to_fcm'] = toFCM;
    data['image'] = image;
    // data['call_body'] = jsonEncode(callBody.toJson());
    data['duration'] = duration;
    data['status'] = status.index;
    data['call_type'] = callType.index;
    // data['call_direction'] = callDirectionType.index;
    data['ext'] = ext;
    return data;
  }
}
