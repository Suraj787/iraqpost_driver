import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iraqdriver/model/contact_details_model.dart';
import 'package:iraqdriver/model/directions_model.dart';
import 'package:iraqdriver/model/task_list_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../UI/Screens/bottomBar/barcode_scanner_screen.dart';
import '../UI/Screens/bottomBar/home_screen.dart';
import '../UI/Screens/bottomBar/itinera_screen.dart';
import '../UI/Screens/bottomBar/menu_screen.dart';
import '../api/api_component.dart';
import '../helper/route_helper.dart';
import '../helper/shar_pref.dart';
import '../model/arriving_shipments_model.dart';
import '../model/assigned_pickup_list_model.dart';
import '../model/barcode_scan_model.dart';
import '../model/completed_task_model.dart';
import '../model/dashboard_model.dart';
import '../model/pending_task_model.dart';
import '../model/shipment_delivery_model.dart';
import '../repo/tracking_repo.dart';
import '../repo/common_repo.dart';
import '../utils/image.dart';

class CommonController extends GetxController implements GetxService {
  final CommonRepo commonRepo;

  CommonController({
    required this.commonRepo,
  });

  int selectedIndexB = 0;
  List<Widget> bodyViewB = <Widget>[
    const HomeScreen(),
    const BarcodeScannerScreen(),
    const ItineraryScreen(),
    const MenuScreen(),
  ];

  late TabController tabControllerB;
  final List<String> labelsB = ['Home', 'Scan', 'Task', 'Profile'];
  final List<Widget> iconsB = [
    Image.asset(Images.btHomeIcon, height: 25, width: 25, fit: BoxFit.cover),
    Image.asset(Images.btScanIcon, height: 25, width: 25, fit: BoxFit.cover),
    Image.asset(Images.btTaskIcon, height: 25, width: 25, fit: BoxFit.cover),
    Image.asset(Images.btUserIcon, height: 25, width: 25, fit: BoxFit.cover),
  ];

  changeBottomIndex(int x) {
    selectedIndexB = x;
    update();
  }

  final Rx<Location> location = Location().obs;
  RxBool isTracking = false.obs;

  List<LatLng> polylineLatLngs = <LatLng>[].obs;

  RxBool isLoadingSheet = false.obs;

  RxBool isLocated = false.obs;
  Rx<LatLng> initialPosition = const LatLng(33.24456, 44.133345).obs;
  Rx<LatLng> currentPosition = const LatLng(33.24456, 44.133345).obs;

  LatLng? destinationPosition;

  RxBool isDirections = false.obs;

  RxString timeToReach = ''.obs;
  RxString distanceFromLocale = ''.obs;

  TextEditingController trackController = TextEditingController();

  var selectedDate = DateTime.now().obs;
  String rescheduleDate = "";

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await datePicker(context, selectedDate.value);

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      String dateTimeString = "2024-05-13 00:00:00.000";
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedDate = dateTime.toString().substring(0, 10);
      rescheduleDate = formattedDate;
      update();
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  String rescheduleTime = "";
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await timePicker(context, selectedTime);

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedTime = pickedTime;
      rescheduleTime = pickedTime.toString().substring(10, 15);
      update();
    }
  }

  TimeOfDay pickupTime = TimeOfDay.now();
  String pickupStringTime = "";
  Future<void> selectPickupTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await timePicker(context, pickupTime);

    if (pickedTime != null && pickedTime != pickupTime) {
      pickupTime = pickedTime;
      pickupStringTime = pickedTime.toString().substring(10, 15);
      update();
    }
  }

  var requestSerDate = DateTime.now().obs;
  String serviceData = "";

  Future<void> servicePickDate(BuildContext context) async {
    final DateTime? pickedDate =
        await datePicker(context, requestSerDate.value);

    if (pickedDate != null && pickedDate != requestSerDate.value) {
      requestSerDate.value = pickedDate;
      String formattedDate = DateFormat('E, dd MMM yyyy').format(pickedDate);
      serviceData = formattedDate;
      update();
    }
  }

  int selectValue = 0;
  callFunction(int value) {
    selectValue = value;
    update();
  }

  bool isNpEmail = false;
  changeNpEmail(bool value) {
    isNpEmail = value;
    update();
  }

  bool isNpSMS = false;
  changeNpSMS(bool value) {
    isNpSMS = value;
    update();
  }

  bool isNpPushN = false;
  changeNpPushN(bool value) {
    isNpPushN = value;
    update();
  }

  bool isNpWhats = false;
  changeNpWhats(bool value) {
    isNpWhats = value;
    update();
  }

  datePicker(BuildContext context, DateTime dateTime) async {
    return await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  timePicker(BuildContext context, TimeOfDay dateTime) async {
    return await showTimePicker(
      context: context,
      initialTime: dateTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// 1. Barcode Scan package
  List<BarcodeDetail>? barcodeDetails = [];
  Future<void> traceShipmentApi(
      String traceNumber, BuildContext context) async {
    isLoading = true;
    var data = {"name": traceNumber.toString()};
    showLoader();
    await TrackingRepo().traceShipmentRepo(traceData: data).then((value) async {
      if (value != null) {
        barcodeDetails!.add(value.barcodeScanData!.barcodeDetail!.first);
        Shared_Preferences.prefSetString(
            Shared_Preferences.barcodeDataList, jsonEncode(barcodeDetails));
        showToast(value.message.toString());
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 2. Get Task List
  List<TaskList>? taskList = [];
  List<RouteData>? routeData = [];
  Future<void> getTaskList({String? packageId}) async {
    var data = {"name": packageId.toString()};
    showLoader();
    await TrackingRepo().getTaskListRepo(taskData: data).then((value) async {
      if (value != null) {
        taskList = value.taskListData!.taskList;
        routeData = value.taskListData!.routeData;
        showToast(value.message.toString());
        hideLoader();
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
      debugPrint('catchError ->${e.toString()}');
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 3. Shipment Delivery Api
  ShipmentData shipmentDeliveryData = ShipmentData();
  Future<void> shipmentDeliveryApi(BuildContext context,
      {List<String>? barcodeList}) async {
    var data = {
      "pickup_location": "HB02",
      "departure_time": "${DateTime.now()}",
      "vehicle": "A12345",
      "item": barcodeList
    };
    debugPrint("barcodeList ----- ${barcodeList.toString()}");
    showLoader();
    await TrackingRepo()
        .shipmentDeliveryRepo(barcodeData: data)
        .then((value) async {
      if (value != null) {
        shipmentDeliveryData = value.data!;
        debugPrint("packageId ----- ${shipmentDeliveryData.name!.toString()}");
        Shared_Preferences.prefSetString(Shared_Preferences.packageId,
            shipmentDeliveryData.name!.toString());
        showToast(value.message.toString());
        hideLoader();
        Get.toNamed(RouteHelper.getTaskTodayScreen());
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 4. Dashboard Data Api
  bool isLoading = false;
  DashboardData? dashboardData = DashboardData();
  Future<void> getDashboardDataApi(BuildContext context) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().dashboardDataRepo().then((value) async {
      if (value != null) {
        dashboardData = value.data!;
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 5. Completed Task List
  List<CompletedTaskList>? completedTaskList = [];
  Future<void> getCompletedTaskApi(BuildContext context) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().completedTaskRepo().then((value) async {
      if (value != null) {
        completedTaskList = value.data!.data;
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 6. Pending Task List
  List<PendingTaskList>? pendingTaskList = [];
  Future<void> getPendingTaskApi(BuildContext context) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().pendingTaskRepo().then((value) async {
      if (value != null) {
        pendingTaskList = value.data!.data;
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// Start Task Route Api
  Future<void> startTaskApi(BuildContext context, {String? docId}) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().startTaskRepo(docName: docId).then((value) async {
      if (value != null) {
        // showToast(value.serverMessages.toString());
        hideLoader();
        isLoading = false;
        // Get.toNamed(RouteHelper.getTaskItineraryScreen());
        update();
      } else {
        showToast(value!.serverMessages.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 7. Shipment Out of Delivery
  Future<void> shipmentOutOfDeliveryApi(BuildContext context,
      {String? name}) async {
    debugPrint("shipment Out of Delivery -------> ${name.toString()}");
    showLoader();
    isLoading = true;
    await TrackingRepo()
        .shipmentOutOfDeliveryRepo(dataName: name)
        .then((value) async {
      if (value != null) {
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
        isLoading = false;
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 8. Shipment Delivered Api
  Future<void> shipmentDeliveredApi(BuildContext context,
      {String? name}) async {
    debugPrint("shipment Delivered -------> ${name.toString()}");
    showLoader();
    isLoading = true;
    await TrackingRepo()
        .shipmentDeliveredRepo(dataName: name)
        .then((value) async {
      if (value != null) {
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
        isLoading = false;
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 9. Assign Pick-Up List
  List<AssignedPickupList>? assignedPickupList = [];
  Future<void> getAssignedPickUpListApi(BuildContext context) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().assignedPickUpListRepo().then((value) async {
      if (value != null) {
        assignedPickupList = value.data!.assignedPickupList;
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 10. Assign Shipment List
  List<AssignedShipmentList>? arrivingShipmentsList = [];
  Future<void> getArrivingShipmentListApi(BuildContext context) async {
    showLoader();
    isLoading = true;
    await TrackingRepo().arrivingShipmentListRepo().then((value) async {
      if (value != null) {
        arrivingShipmentsList = value.data!.assignedShipmentData;
        showToast(value.message.toString());
        hideLoader();
        isLoading = false;
        update();
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 11. Get Contact Api
  ContactData contactDetails = ContactData();
  Future<void> getContactApi(BuildContext context) async {
    isLoading = true;
    update();
    showLoader();
    await TrackingRepo().getContactRepo().then((value) async {
      if (value != null) {
        contactDetails = value.data!;
        isLoading = false;
        showToast(value.message.toString());
        update();
      } else {
        isLoading = false;
        hideLoader();
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      isLoading = false;
      hideLoader();
      debugPrint('catchError -->${e.toString()}');
    }).whenComplete(() {
      hideLoader();
    });
  }

  /// 11. Get Directions Api
  DirectionsModel directionsModel = DirectionsModel();
  Future<void> getDirectionsApi(BuildContext context,
      {required LatLng sourceLocation,
      required LatLng destinationLocation}) async {
    isLoading = true;
    update();
    showLoader();
    await TrackingRepo()
        .getDirectionsRepo(
            sourceLocation: sourceLocation,
            destinationLocation: destinationLocation)
        .then((value) async {
      if (value != null) {
        directionsModel = value;
        log('${directionsModel.routeInfo!.first.estimatedTravelTime}');
        isLoading = false;
        showToast('data fetched successfully');
        update();
      } else {
        isLoading = false;
        hideLoader();
        showToast('data is empty');
      }
    }).catchError((e) {
      isLoading = false;
      hideLoader();
      debugPrint('catchError -->${e.toString()}');
    }).whenComplete(() {
      hideLoader();
    });
  }

  Future<void> getDirectionsApiNav(BuildContext context,
      {required LatLng sourceLocation,
      required LatLng destinationLocation}) async {
    await TrackingRepo()
        .getDirectionsRepo(
            sourceLocation: sourceLocation,
            destinationLocation: destinationLocation)
        .then((value) async {
      if (value != null) {
        directionsModel = value;
        log('${directionsModel.routeInfo!.first.estimatedTravelTime}');
      } else {}
    }).catchError((e) {
      debugPrint('catchError -->${e.toString()}');
    }).whenComplete(() {});
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

class L10n {
  static final List<Locale> all = [
    const Locale('en'),
    const Locale('ar'),
  ];
}
