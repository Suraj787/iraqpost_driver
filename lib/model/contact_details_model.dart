// To parse this JSON data, do
//
//     final contactDetailsModel = contactDetailsModelFromJson(jsonString);

import 'dart:convert';

ContactDetailsModel contactDetailsModelFromJson(String str) => ContactDetailsModel.fromJson(json.decode(str));

String contactDetailsModelToJson(ContactDetailsModel data) => json.encode(data.toJson());

class ContactDetailsModel {
  String? message;
  ContactData? data;

  ContactDetailsModel({
    this.message,
    this.data,
  });

  factory ContactDetailsModel.fromJson(Map<String, dynamic> json) => ContactDetailsModel(
    message: json["message"],
    data: json["data"] == null ? null : ContactData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class ContactData {
  DateTime? time;
  String? phone;
  String? email;

  ContactData({
    this.time,
    this.phone,
    this.email,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    phone: json["phone"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "phone": phone,
    "email": email,
  };
}
