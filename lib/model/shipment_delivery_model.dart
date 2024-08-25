// To parse this JSON data, do
//
//     final shipmentDeliveryModel = shipmentDeliveryModelFromJson(jsonString);

import 'dart:convert';

ShipmentDeliveryModel shipmentDeliveryModelFromJson(String str) => ShipmentDeliveryModel.fromJson(json.decode(str));

String shipmentDeliveryModelToJson(ShipmentDeliveryModel data) => json.encode(data.toJson());

class ShipmentDeliveryModel {
  String? message;
  ShipmentData? data;
  String? serverMessages;

  ShipmentDeliveryModel({
    this.message,
    this.data,
    this.serverMessages,
  });

  factory ShipmentDeliveryModel.fromJson(Map<String, dynamic> json) => ShipmentDeliveryModel(
    message: json["message"],
    data: json["data"] == null ? null : ShipmentData.fromJson(json["data"]),
    serverMessages: json["_server_messages"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "_server_messages": serverMessages,
  };
}

class ShipmentData {
  String? name;

  ShipmentData({
    this.name,
  });

  factory ShipmentData.fromJson(Map<String, dynamic> json) => ShipmentData(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
