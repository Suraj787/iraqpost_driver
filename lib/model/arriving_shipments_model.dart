// To parse this JSON data, do
//
//     final assignedShipmentListModel = assignedShipmentListModelFromJson(jsonString);

import 'dart:convert';

ArrivingShipmentListModel assignedShipmentListModelFromJson(String str) => ArrivingShipmentListModel.fromJson(json.decode(str));

String assignedShipmentListModelToJson(ArrivingShipmentListModel data) => json.encode(data.toJson());

class ArrivingShipmentListModel {
  String? message;
  ArrivingShipmentData? data;

  ArrivingShipmentListModel({
    this.message,
    this.data,
  });

  factory ArrivingShipmentListModel.fromJson(Map<String, dynamic> json) => ArrivingShipmentListModel(
    message: json["message"],
    data: json["data"] == null ? null : ArrivingShipmentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class ArrivingShipmentData {
  DateTime? time;
  List<AssignedShipmentList>? assignedShipmentData;

  ArrivingShipmentData({
    this.time,
    this.assignedShipmentData,
  });

  factory ArrivingShipmentData.fromJson(Map<String, dynamic> json) => ArrivingShipmentData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    assignedShipmentData: json["assigned_shipment_data"] == null ? [] : List<AssignedShipmentList>.from(json["assigned_shipment_data"]!.map((x) => AssignedShipmentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "assigned_shipment_data": assignedShipmentData == null ? [] : List<dynamic>.from(assignedShipmentData!.map((x) => x.toJson())),
  };
}

class AssignedShipmentList {
  String? name;
  String? customer;
  DateTime? requestDate;
  String? assignedToDriver;
  dynamic assignedToVehicle;

  AssignedShipmentList({
    this.name,
    this.customer,
    this.requestDate,
    this.assignedToDriver,
    this.assignedToVehicle,
  });

  factory AssignedShipmentList.fromJson(Map<String, dynamic> json) => AssignedShipmentList(
    name: json["name"],
    customer: json["customer"],
    requestDate: json["request_date"] == null ? null : DateTime.parse(json["request_date"]),
    assignedToDriver: json["assigned_to_driver"],
    assignedToVehicle: json["assigned_to_vehicle"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "customer": customer,
    "request_date": requestDate?.toIso8601String(),
    "assigned_to_driver": assignedToDriver,
    "assigned_to_vehicle": assignedToVehicle,
  };
}
