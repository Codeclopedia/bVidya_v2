import '../profile/instructor_profile_response.dart';

import 'courses_response.dart';

class InstructorCoursesResponse {
  final List<InstructorCourse>? body;
  final String? status;
  final String? message;

  InstructorCoursesResponse({
    this.body,
    this.message,
    this.status,
  });

  InstructorCoursesResponse.fromJson(Map<String, dynamic> json)
      : body = json['body'] != null
            ? List.from(json['body'])
                .map((e) => InstructorCourse.fromJson(e))
                .toList()
            : null,
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body?.map((e) => e.toJson()).toList();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
