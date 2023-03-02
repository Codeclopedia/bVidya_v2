// To parse this JSON data, do
//
//     final paymentCompleteModel = paymentCompleteModelFromJson(jsonString);

import 'dart:convert';

import 'payment_detail_model.dart';
import 'subscription_plans_model.dart';

class PaymentSuccessModel {
  PaymentSuccessModel({
    this.body,
    this.status,
  });

  PaymentSuccessBody? body;
  String? status;

  factory PaymentSuccessModel.fromRawJson(String str) =>
      PaymentSuccessModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentSuccessModel.fromJson(Map<String, dynamic> json) =>
      PaymentSuccessModel(
        body: PaymentSuccessBody.fromJson(json["body"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "body": body?.toJson(),
        "status": status,
      };
}

class PaymentSuccessBody {
  PaymentSuccessBody({
    this.plan,
    this.payment,
    this.totalCredit,
    this.user,
  });

  SubscriptionPlan? plan;
  PaymentSuccessDetails? payment;
  TotalCredit? totalCredit;
  PaymentFromUser? user;

  factory PaymentSuccessBody.fromRawJson(String str) =>
      PaymentSuccessBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentSuccessBody.fromJson(Map<String, dynamic> json) =>
      PaymentSuccessBody(
        plan: SubscriptionPlan.fromJson(json["plan"]),
        payment: PaymentSuccessDetails.fromJson(json["payment"]),
        totalCredit: TotalCredit.fromJson(json["total_credit"]),
        user: PaymentFromUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "plan": plan?.toJson(),
        "payment": payment?.toJson(),
        "total_credit": totalCredit?.toJson(),
        "user": user?.toJson(),
      };
}

class PaymentSuccessDetails {
  PaymentSuccessDetails({
    this.receiptId,
    this.userId,
    this.planId,
    this.serverOrderId,
    this.paymentGatewayOrderId,
    this.paymentGatewayId,
    this.paymentGatewaySignature,
    this.status,
  });

  int? receiptId;
  int? userId;
  int? planId;
  String? serverOrderId;
  String? paymentGatewayOrderId;
  String? paymentGatewayId;
  String? paymentGatewaySignature;
  String? status;

  factory PaymentSuccessDetails.fromRawJson(String str) =>
      PaymentSuccessDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentSuccessDetails.fromJson(Map<String, dynamic> json) =>
      PaymentSuccessDetails(
        receiptId: json["receipt_id"],
        userId: json["user_id"],
        planId: json["plan_id"],
        serverOrderId: json["server_order_id"],
        paymentGatewayOrderId: json["payment_gateway_order_id"],
        paymentGatewayId: json["payment_gateway_id"],
        paymentGatewaySignature: json["payment_gateway_signature"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "receipt_id": receiptId,
        "user_id": userId,
        "plan_id": planId,
        "server_order_id": serverOrderId,
        "payment_gateway_order_id": paymentGatewayOrderId,
        "payment_gateway_id": paymentGatewayId,
        "payment_gateway_signature": paymentGatewaySignature,
        "status": status,
      };
}

class TotalCredit {
  TotalCredit({
    this.userId,
    this.credit,
  });

  int? userId;
  int? credit;

  factory TotalCredit.fromRawJson(String str) =>
      TotalCredit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalCredit.fromJson(Map<String, dynamic> json) => TotalCredit(
        userId: json["user_id"],
        credit: json["credit"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "credit": credit,
      };
}
