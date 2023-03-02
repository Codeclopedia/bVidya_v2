// To parse this JSON data, do
//
//     final creditDetailModel = creditDetailModelFromJson(jsonString);

import 'dart:convert';

class CreditDetailModel {
  CreditDetailModel({
    this.body,
    this.status,
  });

  CreditDetailBody? body;
  String? status;

  factory CreditDetailModel.fromRawJson(String str) =>
      CreditDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditDetailModel.fromJson(Map<String, dynamic> json) =>
      CreditDetailModel(
        body: CreditDetailBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class CreditDetailBody {
  CreditDetailBody({
    this.avilableCourseCredits,
    this.subscriptionPurchaseHistory,
    this.creditUsesHistory,
  });

  int? avilableCourseCredits;
  List<SubscriptionPurchaseHistory>? subscriptionPurchaseHistory;
  List<CreditUsesHistory>? creditUsesHistory;

  factory CreditDetailBody.fromRawJson(String str) =>
      CreditDetailBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditDetailBody.fromJson(Map<String, dynamic> json) =>
      CreditDetailBody(
        avilableCourseCredits: json["avilable_course_credits"],
        subscriptionPurchaseHistory: List<SubscriptionPurchaseHistory>.from(
            json["subscription_purchase_history"]
                .map((x) => SubscriptionPurchaseHistory.fromJson(x))),
        creditUsesHistory: List<CreditUsesHistory>.from(
            json["credit_uses_history"]
                .map((x) => CreditUsesHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "avilable_course_credits": avilableCourseCredits,
        "subscription_purchase_history": List<dynamic>.from(
            subscriptionPurchaseHistory?.map((x) => x.toJson()) ?? []),
        "credit_uses_history":
            List<dynamic>.from(creditUsesHistory?.map((x) => x.toJson()) ?? []),
      };
}

class CreditUsesHistory {
  CreditUsesHistory({
    this.courseId,
    this.courseName,
    this.creditUsed,
    this.createdAt,
  });

  int? courseId;
  String? courseName;
  int? creditUsed;
  DateTime? createdAt;

  factory CreditUsesHistory.fromRawJson(String str) =>
      CreditUsesHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditUsesHistory.fromJson(Map<String, dynamic> json) =>
      CreditUsesHistory(
        courseId: json["course_id"],
        courseName: json["course_name"],
        creditUsed: json["credit_used"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_name": courseName,
        "credit_used": creditUsed,
        "created_at": createdAt?.toIso8601String(),
      };
}

class SubscriptionPurchaseHistory {
  SubscriptionPurchaseHistory({
    this.id,
    this.receiptId,
    this.userId,
    this.planId,
    this.serverOrderId,
    this.paymentGatewayId,
    this.paymentGatewayOrderId,
    this.paymentGatewaySignature,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.price,
    this.courseCredit,
  });

  int? id;
  int? receiptId;
  int? userId;
  int? planId;
  String? serverOrderId;
  String? paymentGatewayId;
  String? paymentGatewayOrderId;
  String? paymentGatewaySignature;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  int? price;
  int? courseCredit;

  factory SubscriptionPurchaseHistory.fromRawJson(String str) =>
      SubscriptionPurchaseHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPurchaseHistory.fromJson(Map<String, dynamic> json) =>
      SubscriptionPurchaseHistory(
        id: json["id"],
        receiptId: json["receipt_id"],
        userId: json["user_id"],
        planId: json["plan_id"],
        serverOrderId: json["server_order_id"],
        paymentGatewayId: json["payment_gateway_id"],
        paymentGatewayOrderId: json["payment_gateway_order_id"],
        paymentGatewaySignature: json["payment_gateway_signature"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        price: json["price"],
        courseCredit: json["course_credit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "receipt_id": receiptId,
        "user_id": userId,
        "plan_id": planId,
        "server_order_id": serverOrderId,
        "payment_gateway_id": paymentGatewayId,
        "payment_gateway_order_id": paymentGatewayOrderId,
        "payment_gateway_signature": paymentGatewaySignature,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "price": price,
        "course_credit": courseCredit,
      };
}
