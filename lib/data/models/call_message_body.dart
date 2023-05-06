import 'dart:convert';

import '/core/helpers/call_helper.dart';
import 'models.dart';

enum CallStatus { missed, ongoing, decline, declineBusy }

class CallMessegeBody {
  final String callId;
  final String fromName;
  final String toName;
  final String toImage;
  final String fromImage;
  final CallBody callBody;
  CallStatus status;
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
        callBody = CallBody.fromJson(jsonDecode(json['call_body'])),
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

  bool isMissedType() {
    return status == CallStatus.missed ||
        status == CallStatus.decline ||
        status == CallStatus.declineBusy;
  }
}

class GroupCallMessegeBody {
  final int requestId;
  final String callId;
  // final int fromId;
  final String fromFCM;
  final String fromName;
  final String fromImage;
  bool isIos = false;
// final String groupId;

  final String groupName;
  final String groupImage;
  final String memberIds;

  final Meeting meeting;
  final CallStatus status;
  final int duration;

  // final Map<String, dynamic> ext;
  final CallType callType;

  GroupCallMessegeBody({
    required this.requestId,
    required this.callId,
    required this.fromFCM,
    // required this.fromId,
    required this.fromName,
    required this.fromImage,
    required this.memberIds,
    // required this.groupId,
    required this.groupName,
    required this.groupImage,
    required this.status,
    required this.duration,
    required this.callType,
    required this.meeting,

    // required this.ext,
  });

  GroupCallMessegeBody.fromJson(Map<String, dynamic> json)
      : requestId = json['request_id'] ?? 0,
        callId = json['call_id'],
        fromName = json['from_name'],
        fromImage = json['from_image'] ?? '',
        fromFCM = json['from_fcm'],
        groupName = json['grp_name'],
        groupImage = json['grp_image'],
        memberIds = json['members_ids'],
        duration = json['duration'] ?? 0,
        isIos = json['is_ios'] ?? false,
        status = CallStatus.values[json['status'] as int],
        callType = CallType.values[json['call_type'] as int],
        meeting = Meeting.fromJson(jsonDecode(json['meeting']));
  // ext = json['ext'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['request_id'] = requestId;
    data['call_id'] = callId;
    data['from_name'] = fromName;
    data['from_image'] = fromImage;
    data['from_fcm'] = fromFCM;
    data['grp_name'] = groupName;
    data['grp_image'] = groupImage;
    data['members_ids'] = memberIds;
    data['duration'] = duration;
    data['status'] = status.index;
    data['call_type'] = callType.index;
    data['is_ios'] == isIos;
    data['meeting'] = jsonEncode(meeting.toJson());
    // data['ext'] = ext;
    return data;
  }
}
