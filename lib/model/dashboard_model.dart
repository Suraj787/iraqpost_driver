
import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  String? message;
  DashboardData? data;

  DashboardModel({
    this.message,
    this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    message: json["message"],
    data: json["data"] == null ? null : DashboardData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class DashboardData {
  DateTime? time;
  int? taskAssigned;
  int? taskPickup;

  DashboardData({
    this.time,
    this.taskAssigned,
    this.taskPickup,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    taskAssigned: json["task_assigned"],
    taskPickup: json["task_pickup"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "task_assigned": taskAssigned,
    "task_pickup": taskPickup,
  };
}
