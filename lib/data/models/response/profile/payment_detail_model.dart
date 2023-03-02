// To parse this JSON data, do
//
//     final paymentDetailModel = paymentDetailModelFromJson(jsonString);

import 'dart:convert';

import 'subscription_plans_model.dart';

class PaymentDetailModel {
  PaymentDetailModel({
    this.body,
    this.status,
  });

  PaymentDetailBody? body;
  String? status;

  factory PaymentDetailModel.fromRawJson(String str) =>
      PaymentDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) =>
      PaymentDetailModel(
        body: PaymentDetailBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class PaymentDetailBody {
  PaymentDetailBody({
    this.plan,
    this.user,
    this.orderId,
    this.key,
  });

  SubscriptionPlan? plan;
  PaymentFromUser? user;
  String? orderId;
  String? key;

  factory PaymentDetailBody.fromRawJson(String str) =>
      PaymentDetailBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetailBody.fromJson(Map<String, dynamic> json) =>
      PaymentDetailBody(
        plan: SubscriptionPlan.fromJson(json["plan"]),
        user: PaymentFromUser.fromJson(json["user"]),
        orderId: json["order_id"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan?.toJson(),
        "user": user?.toJson(),
        "order_id": orderId,
        "key": key,
      };
}

class PaymentFromUser {
  PaymentFromUser({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  int? id;
  String? name;
  String? email;
  String? phone;

  factory PaymentFromUser.fromRawJson(String str) =>
      PaymentFromUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentFromUser.fromJson(Map<String, dynamic> json) =>
      PaymentFromUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}
