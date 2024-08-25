// To parse this JSON data, do
//
//     final pendingTaskModel = pendingTaskModelFromJson(jsonString);

import 'dart:convert';

PendingTaskModel pendingTaskModelFromJson(String str) => PendingTaskModel.fromJson(json.decode(str));

String pendingTaskModelToJson(PendingTaskModel data) => json.encode(data.toJson());

class PendingTaskModel {
  String? message;
  PendingTaskData? data;

  PendingTaskModel({
    this.message,
    this.data,
  });

  factory PendingTaskModel.fromJson(Map<String, dynamic> json) => PendingTaskModel(
    message: json["message"],
    data: json["data"] == null ? null : PendingTaskData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class PendingTaskData {
  DateTime? time;
  List<PendingTaskList>? data;

  PendingTaskData({
    this.time,
    this.data,
  });

  factory PendingTaskData.fromJson(Map<String, dynamic> json) => PendingTaskData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    data: json["data"] == null ? [] : List<PendingTaskList>.from(json["data"]!.map((x) => PendingTaskList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PendingTaskList {
  String? packageId;
  int? idx;
  String? name;
  String? serviceRequest;
  String? longitude;
  String? latitude;
  String? deliveryStatus;
  dynamic deliveredTime;
  dynamic distance;
  dynamic time;
  dynamic flatNoBuildingName;
  dynamic cityTown;
  String? postalCode;

  PendingTaskList({
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

  factory PendingTaskList.fromJson(Map<String, dynamic> json) => PendingTaskList(
    packageId: json["package_id"],
    idx: json["idx"],
    name: json["name"],
    serviceRequest: json["service_request"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    deliveryStatus: json["delivery_status"],
    deliveredTime: json["delivered_time"],
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
    "delivered_time": deliveredTime,
    "distance": distance,
    "time": time,
    "flat_no_building_name": flatNoBuildingName,
    "city_town": cityTown,
    "postal_code": postalCode,
  };
}
