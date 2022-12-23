import '../../models.dart';

class LMSSearchResponse{

  final SearchResults? body;
  final String? status;
  final String? message;

  LMSSearchResponse({
    this.body,
    this.message,
    this.status,
  });

  LMSSearchResponse.fromJson(Map<String, dynamic> json)
      : body = json['body']!=null?SearchResults.fromJson(json['body']):null,
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

class SearchResults {
  final List<Course>? courses;
  final List<Instructor>? instructors;

  SearchResults({
    this.courses,
    this.instructors
  });

  SearchResults.fromJson(Map<String, dynamic> json)
      : courses =
            List.from(json['courses']).map((e) => Course.fromJson(e)).toList(),
            instructors =
            List.from(json['instructors']).map((e) => Instructor.fromJson(e)).toList()
            ;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['courses'] = courses?.map((e) => e.toJson()).toList();
    data['instructors'] = instructors?.map((e) => e.toJson()).toList();
    return data;
  }
}
