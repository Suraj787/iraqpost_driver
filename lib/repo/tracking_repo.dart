import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iraqdriver/model/assigned_pickup_list_model.dart';
import 'package:iraqdriver/model/contact_details_model.dart';
import 'package:iraqdriver/model/directions_model.dart';
import 'package:iraqdriver/model/task_list_model.dart';
import 'package:latlong2/latlong.dart';

import '../api/api_component.dart';
import '../api/urls.dart';
import '../helper/shar_pref.dart';
import '../model/arriving_shipments_model.dart';
import '../model/barcode_scan_model.dart';
import '../model/base_model.dart';
import '../model/completed_task_model.dart';
import '../model/dashboard_model.dart';
import '../model/pending_task_model.dart';
import '../model/shipment_delivery_model.dart';
import '../model/start_task_model.dart';

class TrackingRepo {
  Dio dio = Dio();
  // Static token --> bafcf671c158fd7:2efa258d210c027
  /// Barcode Scan package
  Future<BarcodeScanModel?> traceShipmentRepo(
      {Map<String, dynamic>? traceData}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Response response;
    var data = json.encode(traceData);
    debugPrint("11111 $apiToken");
    try {
      response = await dio.post(Urls.barcodeScanUrl,
          options: Options(headers: headers), data: data);
      if (response.statusCode == 200) {
        BarcodeScanModel barcodeScanModel =
            BarcodeScanModel.fromJson(response.data);
        return barcodeScanModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      showToast(e.response!.statusMessage.toString());
      // if (e.response!.statusCode == 422) {
      //   showToast(e.response!.statusMessage.toString());
      // }
      debugPrint('Dio Error -->  $e');
      return null;
    }
  }

  /// Get Task List
  Future<TaskListModel?> getTaskListRepo(
      {Map<String, dynamic>? taskData}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Response response;
    var data = json.encode(taskData);
    try {
      response = await dio.post(Urls.tackListUrl,
          options: Options(headers: headers), data: data);
      if (response.statusCode == 200) {
        TaskListModel taskListModel = TaskListModel.fromJson(response.data);
        log('${taskListModel.taskListData?.routeData?.first.coordinates}');
        return taskListModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      debugPrint('Dio E  $e');
      return null;
    }
  }

  /// Shipment Delivery Api
  Future<ShipmentDeliveryModel?> shipmentDeliveryRepo(
      {Map<String, dynamic>? barcodeData}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Response response;
    var data = json.encode(barcodeData);
    try {
      response = await dio.post(Urls.deliveryUrl,
          options: Options(headers: headers), data: data);
      if (response.statusCode == 200) {
        ShipmentDeliveryModel shipmentDeliveryModel =
            ShipmentDeliveryModel.fromJson(response.data);
        return shipmentDeliveryModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      debugPrint('Dio E  $e');
      return null;
    }
  }

  /// Dashboard Data Api
  Future<DashboardModel?> dashboardDataRepo() async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    debugPrint("TOKEN - $apiToken");
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response =
          await dio.get(Urls.dashboardUrl, options: Options(headers: headers));
      if (response.statusCode == 200) {
        DashboardModel dashboardModel = DashboardModel.fromJson(response.data);
        return dashboardModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Completed Task List
  Future<CompletedTaskModel?> completedTaskRepo() async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.get(Urls.completedTaskUrl,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        CompletedTaskModel completedTaskData =
            CompletedTaskModel.fromJson(response.data);
        return completedTaskData;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Pending Task List
  Future<PendingTaskModel?> pendingTaskRepo() async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.get(Urls.pendingTaskUrl,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        PendingTaskModel pendingTaskData =
            PendingTaskModel.fromJson(response.data);
        return pendingTaskData;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Start Task List
  Future<StartTaskModel?> startTaskRepo({String? docName}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    debugPrint("------ $docName");
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.get("${Urls.startTaskUrl}?docsname=$docName",
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        StartTaskModel startTaskModel = StartTaskModel.fromJson(response.data);
        return startTaskModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Shipment Out of Delivery
  Future<BaseModel?> shipmentOutOfDeliveryRepo({String? dataName}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.put(
          "${Urls.shipmentOutOfDeliveryUrl}?names=$dataName",
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        BaseModel baseModel = BaseModel.fromJson(response.data);
        return baseModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Shipment Delivered Api
  Future<BaseModel?> shipmentDeliveredRepo({String? dataName}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.put("${Urls.shipmentDeliveredUrl}?names=$dataName",
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        BaseModel baseModel = BaseModel.fromJson(response.data);
        return baseModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Assign Pick-Up List Repo
  Future<AssignedPickUpListModel?> assignedPickUpListRepo(
      {String? docName}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.get(Urls.assignedPickUpListUrl,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        AssignedPickUpListModel assignedPickUpListModel =
            AssignedPickUpListModel.fromJson(response.data);
        return assignedPickUpListModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Arriving Shipment List Repo
  Future<ArrivingShipmentListModel?> arrivingShipmentListRepo(
      {String? docName}) async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      Response response;
      response = await dio.get(Urls.arrivingShipmentListUrl,
          options: Options(headers: headers));
      if (response.statusCode == 200) {
        ArrivingShipmentListModel arrivingShipmentListModel =
            ArrivingShipmentListModel.fromJson(response.data);
        return arrivingShipmentListModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Get Contact Api
  Future<ContactDetailsModel?> getContactRepo() async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    var headers = {
      'Authorization': 'Token ${apiToken.toString()}',
    };
    Response response;
    try {
      response =
          await dio.get(Urls.getContact, options: Options(headers: headers));
      debugPrint("response ${response.statusCode}");
      if (response.statusCode == 200) {
        ContactDetailsModel contactDetailsModel =
            ContactDetailsModel.fromJson(response.data);
        return contactDetailsModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }

  /// Get Directions Api
  Future<DirectionsModel?> getDirectionsRepo({
    required LatLng sourceLocation,
    required LatLng destinationLocation,
  }) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Response response;
    try {
      response = await dio.post(
        'https://optimize-route-24.onrender.com/optimize_route',
        data: {
          "source_location": {
            "latitude": sourceLocation.latitude,
            "longitude": sourceLocation.longitude,
          },
          "destination_locations": [
            {
              "latitude": destinationLocation.latitude,
              "longitude": destinationLocation.longitude,
            },
          ],
          "api_keys": [
            "AIzaSyDrlnLOBwzh81sjUPJ56hSSWufVyej1f0E",
          ]
        },
        options: Options(headers: headers),
      );
      debugPrint("response ${response.statusCode}");
      if (response.statusCode == 200) {
        DirectionsModel directionsModel =
            DirectionsModel.fromJson(response.data);

        return directionsModel;
      } else {
        throw Exception(response.data);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        showToast(e.response!.statusMessage.toString());
      }
      return null;
    }
  }
}
