class FollowInstructorResponse {
  FollowInstructorResponse({this.body, this.status, this.message});

  final List<FollowedInstructor>? body;
  final String? status;
  final String? message;

  factory FollowInstructorResponse.fromJson(Map<String, dynamic> json) =>
      FollowInstructorResponse(
        body: json["body"] != null
            ? List<FollowedInstructor>.from(
                json["body"].map((x) => FollowedInstructor.fromJson(x)))
            : null,
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "body": body == null
            ? null
            : List<FollowedInstructor>.from(body!.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class FollowedInstructor {
  FollowedInstructor({
    this.instructorId,
    this.instructorName,
    this.image,
    this.experience,
    this.specialization,
  });

  final int? instructorId;
  final String? instructorName;
  final String? image;
  final String? experience;
  final String? specialization;

  factory FollowedInstructor.fromJson(Map<String, dynamic> json) =>
      FollowedInstructor(
        instructorId: json["instructor_id"],
        instructorName: json["instructor_name"],
        image: json["image"],
        experience: json["experience"],
        specialization: json["specialization"],
      );

  Map<String, dynamic> toJson() => {
        "instructor_id": instructorId,
        "instructor_name": instructorName,
        "image": image,
        "experience": experience,
        "specialization": specialization,
      };
}
