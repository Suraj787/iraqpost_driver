// To parse this JSON data, do
//
//     final completedTaskModel = completedTaskModelFromJson(jsonString);

import 'dart:convert';

CompletedTaskModel completedTaskModelFromJson(String str) => CompletedTaskModel.fromJson(json.decode(str));

String completedTaskModelToJson(CompletedTaskModel data) => json.encode(data.toJson());

class CompletedTaskModel {
  String? message;
  CompletedTaskData? data;

  CompletedTaskModel({
    this.message,
    this.data,
  });

  factory CompletedTaskModel.fromJson(Map<String, dynamic> json) => CompletedTaskModel(
    message: json["message"],
    data: json["data"] == null ? null : CompletedTaskData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class CompletedTaskData {
  DateTime? time;
  List<CompletedTaskList>? data;

  CompletedTaskData({
    this.time,
    this.data,
  });

  factory CompletedTaskData.fromJson(Map<String, dynamic> json) => CompletedTaskData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    data: json["data"] == null ? [] : List<CompletedTaskList>.from(json["data"]!.map((x) => CompletedTaskList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CompletedTaskList {
  String? packageId;
  int? idx;
  String? name;
  String? serviceRequest;
  String? longitude;
  String? latitude;
  String? deliveryStatus;
  DateTime? deliveredTime;
  dynamic distance;
  dynamic time;
  dynamic flatNoBuildingName;
  dynamic cityTown;
  dynamic postalCode;

  CompletedTaskList({
    this.packageId,
    this.idx,
    this.name,
    this.serviceRequest,
    this.longitude,
    this.latitude,
    this.deliveryStatus,
    this.deliveredTime,
    this.distance,
    this.time,
    this.flatNoBuildingName,
    this.cityTown,
    this.postalCode,
  });

  factory CompletedTaskList.fromJson(Map<String, dynamic> json) => CompletedTaskList(
    packageId: json["package_id"],
    idx: json["idx"],
    name: json["name"],
    serviceRequest: json["service_request"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    deliveryStatus: json["delivery_status"],
    deliveredTime: json["delivered_time"] == null ? null : DateTime.parse(json["delivered_time"]),
    distance: json["distance"],
    time: json["time"],
    flatNoBuildingName: json["flat_no_building_name"],
    cityTown: json["city_town"],
    postalCode: json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "idx": idx,
    "name": name,
    "service_request": serviceRequest,
    "longitude": longitude,
    "latitude": latitude,
    "delivery_status": deliveryStatus,
    "delivered_time": deliveredTime?.toIso8601String(),
    "distance": distance,
    "time": time,
    "flat_no_building_name": flatNoBuildingName,
    "city_town": cityTown,
    "postal_code": postalCode,
  };
}
