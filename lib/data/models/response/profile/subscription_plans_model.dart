// To parse this JSON data, do
//
//     final subscriptionPlansModel = subscriptionPlansModelFromJson(jsonString);

import 'dart:convert';

class SubscriptionPlansModel {
  SubscriptionPlansModel({
    this.body,
    this.status,
  });

  SubscriptionPlansBody? body;
  String? status;

  factory SubscriptionPlansModel.fromRawJson(String str) =>
      SubscriptionPlansModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlansModel(
        body: SubscriptionPlansBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class SubscriptionPlansBody {
  SubscriptionPlansBody({
    this.plans,
  });

  List<SubscriptionPlan>? plans;

  factory SubscriptionPlansBody.fromRawJson(String str) =>
      SubscriptionPlansBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlansBody.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlansBody(
        plans: List<SubscriptionPlan>.from(
            json["plans"].map((x) => SubscriptionPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plans": List<dynamic>.from(plans?.map((x) => x.toJson()) ?? []),
      };
}

class SubscriptionPlan {
  SubscriptionPlan({
    this.id,
    this.name,
    this.price,
    this.courseCredit,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  int? price;
  int? courseCredit;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubscriptionPlan.fromRawJson(String str) =>
      SubscriptionPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        courseCredit: json["course_credit"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "course_credit": courseCredit,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
