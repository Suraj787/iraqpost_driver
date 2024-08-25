// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? message;
  String? homePage;
  String? fullName;
  User? user;
  String? token;

  LoginModel({
    this.message,
    this.homePage,
    this.fullName,
    this.user,
    this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["message"],
    homePage: json["home_page"],
    fullName: json["full_name"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "home_page": homePage,
    "full_name": fullName,
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? birthDate;
  String? mobileNo;
  String? username;
  String? fullName;
  String? email;
  String? employee;
  String? driver;

  User({
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.mobileNo,
    this.username,
    this.fullName,
    this.email,
    this.employee,
    this.driver,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["first_name"],
    lastName: json["last_name"],
    gender: json["gender"],
    birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
    mobileNo: json["mobile_no"],
    username: json["username"],
    fullName: json["full_name"],
    email: json["email"],
    employee: json["employee"],
    driver: json["driver"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "gender": gender,
    "birth_date": "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
    "mobile_no": mobileNo,
    "username": username,
    "full_name": fullName,
    "email": email,
    "employee": employee,
    "driver": driver,
  };
}
