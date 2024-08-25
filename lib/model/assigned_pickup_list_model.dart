
import 'dart:convert';

AssignedPickUpListModel assignedPickUpListModelFromJson(String str) => AssignedPickUpListModel.fromJson(json.decode(str));

String assignedPickUpListModelToJson(AssignedPickUpListModel data) => json.encode(data.toJson());

class AssignedPickUpListModel {
  String? message;
  AssignPickUpData? data;

  AssignedPickUpListModel({
    this.message,
    this.data,
  });

  factory AssignedPickUpListModel.fromJson(Map<String, dynamic> json) => AssignedPickUpListModel(
    message: json["message"],
    data: json["data"] == null ? null : AssignPickUpData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class AssignPickUpData {
  DateTime? time;
  List<AssignedPickupList>? assignedPickupList;

  AssignPickUpData({
    this.time,
    this.assignedPickupList,
  });

  factory AssignPickUpData.fromJson(Map<String, dynamic> json) => AssignPickUpData(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    assignedPickupList: json["assigned_pickup_data"] == null ? [] : List<AssignedPickupList>.from(json["assigned_pickup_data"]!.map((x) => AssignedPickupList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "assigned_pickup_data": assignedPickupList == null ? [] : List<dynamic>.from(assignedPickupList!.map((x) => x.toJson())),
  };
}

class AssignedPickupList {
  String? name;
  String? customer;
  DateTime? requestDate;
  String? assignedToDriver;
  String? assignedToVehicle;

  AssignedPickupList({
    this.name,
    this.customer,
    this.requestDate,
    this.assignedToDriver,
    this.assignedToVehicle,
  });

  factory AssignedPickupList.fromJson(Map<String, dynamic> json) => AssignedPickupList(
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
