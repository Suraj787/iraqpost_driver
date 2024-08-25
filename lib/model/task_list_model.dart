// // To parse this JSON data, do
// //
// //     final taskListModel = taskListModelFromJson(jsonString);
//
// import 'dart:convert';
//
// TaskListModel taskListModelFromJson(String str) => TaskListModel.fromJson(json.decode(str));
//
// String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());
//
// class TaskListModel {
//   String? message;
//   TaskListData? taskListData;
//
//   TaskListModel({
//     this.message,
//     this.taskListData,
//   });
//
//   factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
//     message: json["message"],
//     taskListData: json["data"] == null ? null : TaskListData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "data": taskListData?.toJson(),
//   };
// }
//
// class TaskListData {
//   DateTime? time;
//   List<TaskList>? taskList;
//
//   TaskListData({
//     this.time,
//     this.taskList,
//   });
//
//   factory TaskListData.fromJson(Map<String, dynamic> json) => TaskListData(
//     time: json["time"] == null ? null : DateTime.parse(json["time"]),
//     taskList: json["data"] == null ? [] : List<TaskList>.from(json["data"]!.map((x) => TaskList.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "time": time?.toIso8601String(),
//     "data": taskList == null ? [] : List<dynamic>.from(taskList!.map((x) => x.toJson())),
//   };
// }
//
// class TaskList {
//   int? idx;
//   String? name;
//   String? serviceRequest;
//   String? longitude;
//   String? latitude;
//   String? deliveryStatus;
//   dynamic deliveredTime;
//   String? distance;
//   dynamic time;
//
//   TaskList({
//     this.idx,
//     this.name,
//     this.serviceRequest,
//     this.longitude,
//     this.latitude,
//     this.deliveryStatus,
//     this.deliveredTime,
//     this.distance,
//     this.time,
//   });
//
//   factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
//     idx: json["idx"],
//     name: json["name"],
//     serviceRequest: json["service_request"],
//     longitude: json["longitude"],
//     latitude: json["latitude"],
//     deliveryStatus: json["delivery_status"],
//     deliveredTime: json["delivered_time"],
//     distance: json["distance"],
//     time: json["time"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "idx": idx,
//     "name": name,
//     "service_request": serviceRequest,
//     "longitude": longitude,
//     "latitude": latitude,
//     "delivery_status": deliveryStatus,
//     "delivered_time": deliveredTime,
//     "distance": distance,
//     "time": time,
//   };
// }
// To parse this JSON data, do
//
//     final taskListModel = taskListModelFromJson(jsonString);

import 'dart:convert';

TaskListModel taskListModelFromJson(String str) =>
    TaskListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());

class TaskListModel {
  String? message;
  TaskListData? taskListData;

  TaskListModel({
    this.message,
    this.taskListData,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
        message: json["message"],
        taskListData:
            json["data"] == null ? null : TaskListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": taskListData?.toJson(),
      };
}

class TaskListData {
  DateTime? time;
  List<TaskList>? taskList;
  List<RouteData>? routeData;

  TaskListData({
    this.time,
    this.taskList,
    this.routeData,
  });

  factory TaskListData.fromJson(Map<String, dynamic> json) => TaskListData(
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        taskList: json["data"] == null
            ? []
            : List<TaskList>.from(
                json["data"]!.map((x) => TaskList.fromJson(x))),
        routeData: json["route_data"] == null
            ? []
            : List<RouteData>.from(
                json["route_data"]!.map((x) => RouteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "time": time?.toIso8601String(),
        "data": taskList == null
            ? []
            : List<dynamic>.from(taskList!.map((x) => x.toJson())),
        "route_data": routeData == null
            ? []
            : List<dynamic>.from(routeData!.map((x) => x.toJson())),
      };
}

class TaskList {
  String? packageId;
  int? idx;
  String? name;
  String? serviceRequest;
  String? longitude;
  String? latitude;
  String? deliveryStatus;
  String? deliveredTime;
  String? distance;
  String? time;
  String? flatNoBuildingName;
  String? cityTown;
  String? postalCode;
  bool? isSelected;

  TaskList({
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
    this.isSelected = false,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
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
        isSelected: json["isSelected"],
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
        "isSelected": isSelected,
      };
}

class RouteData {
  String? coordinates;

  RouteData({
    this.coordinates,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) => RouteData(
        coordinates: json["route_data"],
      );

  Map<String, dynamic> toJson() => {
        "route_data": coordinates,
      };
}
