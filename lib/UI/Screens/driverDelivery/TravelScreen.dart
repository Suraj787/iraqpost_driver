import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;
import '../../../api/api_component.dart';
import '../../../constants/constant_apis.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../model/route_model.dart';
import '../../../model/task_list_model.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  String? packageId;
  MapController mapController = MapController();
  String arcGisApiKey =
      "AAPKb7a1d63200d747528ece8e0746d9a46dVWnWo2g8x_d1tQYqKI7QftZhrtPIwaAM2-stsoAAfcmimmd9BHcyMHDTGAJwz1d4";
  LatLng _initialPosition = const LatLng(33.24456, 44.133345);
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  TaskList taskList = TaskList();

  Location _location = Location();
  LocationData? _currentLocation;
  bool _isTracking = true;
  int _currentIndex = 0;

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
      if (await per.Permission.location.isDenied) {
        Map<per.Permission, per.PermissionStatus> statuses = await [
          per.Permission.location,
          per.Permission.locationAlways,
          per.Permission.locationWhenInUse,
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
        Shared_Preferences.trackData, '');
    taskList = TaskList.fromJson(jsonDecode(data.toString()));
    setState(() {});
  }

  /// Get Task List
  getTaskListData() async {
    packageId = await Shared_Preferences.prefGetString(
            Shared_Preferences.packageId, 'IPSD240629017') ??
        '';
    controller.getTaskList(packageId: packageId).then((value) async {
      if (controller.routeData != null && controller.routeData!.isNotEmpty) {
        _initialPosition = LatLng(
            double.parse(controller.taskList![0].latitude!.toString()),
            double.parse(controller.taskList![0].longitude!.toString()));
        loadRoute();
      } else {
        _loadRouteStaticData();
      }
      hideLoader();
    });
    setState(() {});
  }

  /// From API
  List<LatLng> _polylinePoints = [];
  void loadRoute() {
    final data =
        jsonDecode(controller.routeData![0].coordinates ?? routeJsonData);
    final routeData = RouteModel.fromJson(data);
    setState(
      () {
        for (var route in routeData.routeInfo) {
          _polylinePoints = _decodePolyline(route.geometry.coordinates);
          final polyline = Polyline(
            points: _polylinePoints,
            strokeWidth: 4.0,
            color: Colors.blue,
          );
          _polylines.add(polyline);
          _startTracking();
          _markers.add(
            Marker(
              width: 25.0,
              height: 25.0,
              point: LatLng(
                  route.destination.latitude, route.destination.longitude),
              child:
                  const Icon(Icons.location_on, color: Colors.red, size: 25.0),
            ),
          );
        }
      },
    );
  }

  void _loadRouteStaticData() {
    final data = jsonDecode(routeJsonData);
    final routeData = RouteModel.fromJson(data);

    setState(
      () {
        for (var route in routeData.routeInfo) {
          _polylinePoints = _decodePolyline(route.geometry.coordinates);
          final polyline = Polyline(
            points: _polylinePoints,
            strokeWidth: 4.0,
            color: Colors.blue,
          );
          _polylines.add(polyline);
          _startTracking();
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

  void _startTracking() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        if (_currentIndex < _polylinePoints.length - 1) {
          _currentIndex++;
          _initialPosition = _polylinePoints[_currentIndex];
          mapController.move(_initialPosition, mapController.camera.zoom);
        }
      });
      return _currentIndex < _polylinePoints.length - 1;
    });
  }

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
    return Directionality(
      textDirection: (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black38,
          title: Text(AppLocalizations.of(context)!.travel,
              style: const TextStyle(
                  color: Color(0xFF070D17),
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF5F6979),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                                  taskList.flatNoBuildingName!.isNotEmpty
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
              // SizedBox(height: 450,
              //     child: FlutterMap(
              //       mapController: mapController,
              //       options: MapOptions(
              //         initialCenter: _initialPosition,
              //         initialZoom: 10,
              //       ),
              //       children: [
              //         TileLayer(
              //           urlTemplate:
              //           'https://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
              //           subdomains: const ['server', 'services', 'www'],
              //           additionalOptions: {
              //             'apiKey': arcGisApiKey,
              //           },
              //         ),
              //         PolylineLayer(polylines: _polyLines),
              //         MarkerLayer(markers: _markers),
              //       ],
              //     )),
              /// Demo for tracking
              SizedBox(
                  height: 400,
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: _initialPosition,
                      initialZoom: 12,
                      onPositionChanged: (position, hasGesture) {
                        // _getLocationUpdates();
                      },
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
                      // MarkerLayer(
                      //   markers: _currentLocation != null
                      //       ? [Marker(
                      //       point: LatLng(
                      //         _currentLocation!.latitude!,
                      //         _currentLocation!.longitude!,
                      //       ),
                      //       child: const Icon(
                      //         Icons.location_on,
                      //         color: Colors.blue,
                      //         size: 25.0,
                      //       ),
                      //     ),]
                      //       : [],
                      // ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _initialPosition,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deliver 1 package",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    const Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xff709FC1)),
                        Text("12:00-6:00pm")
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    CustomButtons(
                      text: AppLocalizations.of(context)!.startTravel,
                      onTap: () {
                        Get.toNamed(RouteHelper.getServiceDeliverScreen());
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
  }
}
