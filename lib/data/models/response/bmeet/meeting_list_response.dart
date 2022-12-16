import 'schedule_response.dart';

class MeetingListResponse {
  final String? status;
  final String? message;
  final Meetings? body;

  MeetingListResponse({this.message, this.status, this.body});

  MeetingListResponse.fromJson(Map<String, dynamic> json)
      : body = Meetings.fromJson(json['body']),
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

class Meetings {
  final List<ScheduledMeeting>? meetings;
  Meetings({
    this.meetings,
  });

  Meetings.fromJson(Map<String, dynamic> json)
      : meetings = List.from(json['meetings'])
            .map((e) => ScheduledMeeting.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['meetings'] = meetings?.map((e) => e.toJson()).toList();
    return data;
  }
}
