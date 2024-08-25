import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/constants/constant_apis.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../model/route_model.dart';
import '../../../model/task_list_model.dart';
import '../../Widgets/customBtn.dart';
import 'dart:core';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTravelScreen extends StatefulWidget {
  const TaskTravelScreen({super.key});

  @override
  State<TaskTravelScreen> createState() => _TaskTravelScreenState();
}

class _TaskTravelScreenState extends State<TaskTravelScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MapController mapController = MapController();

  String arcGisApiKey =
      "AAPKb7a1d63200d747528ece8e0746d9a46dVWnWo2g8x_d1tQYqKI7QftZhrtPIwaAM2-stsoAAfcmimmd9BHcyMHDTGAJwz1d4";
  LatLng _initialPosition = const LatLng(33.24456, 44.133345);
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  TaskList taskList = TaskList();

  @override
  void initState() {
    super.initState();
    getPermission();
    getLanguage();
    getTaskListData();
    getPackageIdData();
  }

  void getPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (await Permission.location.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.locationAlways,
          Permission.locationWhenInUse,
        ].request();
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  getPackageIdData() async {
    String? data = await Shared_Preferences.prefGetString(
        Shared_Preferences.trackData1, '');
    taskList = TaskList.fromJson(jsonDecode(data.toString()));
    setState(() {});
  }

  /// Get Task List
  getTaskListData() async {
    String? packageId = await Shared_Preferences.prefGetString(
            Shared_Preferences.packageId, 'IPSD240629017') ??
        '';
    controller.getTaskList(packageId: packageId).then((value) async {
      if (controller.routeData != null && controller.routeData!.isNotEmpty) {
        _initialPosition = LatLng(
            double.parse(controller.taskList![0].latitude!.toString()),
            double.parse(controller.taskList![0].longitude!.toString()));
        loadRoute();
      } else {
        // _loadRouteStaticData();
      }
      hideLoader();
    });
    setState(() {});
  }

  /// From API
  void loadRoute() {
    final data =
        jsonDecode(controller.routeData![0].coordinates ?? routeJsonData);
    final routeData = RouteModel.fromJson(data);
    setState(
      () {
        for (var route in routeData.routeInfo) {
          final points = _decodePolyline(route.geometry.coordinates);
          final polyline = Polyline(
            points: points,
            strokeWidth: 4.0,
            color: Colors.blue,
          );
          _polylines.add(polyline);
          _markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                  route.destination.latitude, route.destination.longitude),
              child:
                  const Icon(Icons.location_on, color: Colors.red, size: 40.0),
            ),
          );
        }
      },
    );
  }

  // void _loadRouteStaticData() {
  //   final data = jsonDecode(routeJsonData);
  //   final routeData = RouteModel.fromJson(data);
  //
  //   setState(() {
  //       for (var route in routeData.routeInfo) {
  //         final points = _decodePolyline(route.geometry.coordinates);
  //         final polyline = Polyline(
  //           points: points,
  //           strokeWidth: 4.0,
  //           color: Colors.blue,
  //         );
  //         _polylines.add(polyline);
  //         _markers.add(
  //           Marker(
  //             width: 80.0,
  //             height: 80.0,
  //             point: LatLng(route.destination.latitude, route.destination.longitude),
  //             child: Container(
  //               child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(builder: (commonController) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 4,
            shadowColor: Colors.black38,
            title: Hero(
              tag: "taskTravel",
              child: Material(
                child: Text(AppLocalizations.of(context)!.travel,
                    style: const TextStyle(
                        color: Color(0xFF070D17),
                        fontSize: 24,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF5F6979),
            ),
          ),
          body: (commonController.taskList == null &&
                  commonController.taskList!.isEmpty)
              ? showLoader()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.packageId,
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  taskList != null &&
                                          taskList.packageId != null &&
                                          taskList.packageId!.isNotEmpty
                                      ? Text(
                                          '${taskList.packageId}',
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.address,
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  taskList != null &&
                                          taskList.flatNoBuildingName != null &&
                                          taskList
                                              .flatNoBuildingName!.isNotEmpty
                                      ? Text(
                                          '${taskList.flatNoBuildingName}',
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                  taskList != null &&
                                          taskList.cityTown != null &&
                                          taskList.cityTown!.isNotEmpty
                                      ? Text(
                                          '${taskList.cityTown}',
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        )
                                      : const Text(
                                          '',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 400,
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: _initialPosition,
                              initialZoom: 10,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                                subdomains: const ['server', 'services', 'www'],
                                additionalOptions: {
                                  'apiKey': arcGisApiKey,
                                },
                              ),
                              PolylineLayer(polylines: _polylines),
                              // MarkerLayer(markers: _markers),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pickup 1 package",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            const Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: Color(0xff709FC1)),
                                Text("12:00-6:00pm")
                              ],
                            ),
                            SizedBox(height: Get.height * 0.02),
                            CustomButtons(
                              text: AppLocalizations.of(context)!.startTravel,
                              onTap: () {
                                Get.toNamed(RouteHelper.getTaskParkedScreen());
                              },
                              noFillData: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
