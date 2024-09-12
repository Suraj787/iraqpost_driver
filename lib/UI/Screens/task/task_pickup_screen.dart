// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:iraqdriver/helper/shar_pref.dart';
import 'package:iraqdriver/model/directions_model.dart';
import 'package:iraqdriver/utils/image.dart';
import 'package:iraqdriver/utils/string.dart';
import 'package:iraqdriver/utils/useful_methods.dart';
import 'package:latlong2/latlong.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'dart:math' as math;

import 'package:location/location.dart';

class TaskParkedScreen extends StatefulWidget {
  const TaskParkedScreen({super.key});

  @override
  State<TaskParkedScreen> createState() => _TaskParkedScreenState();
}

class _TaskParkedScreenState extends State<TaskParkedScreen>
    with SingleTickerProviderStateMixin {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  MapController mapController = MapController();
  AnimationController? animationController;
  FlutterTts flutterTts = FlutterTts();
  String? text;
  String? nextText;
  String distanceToTurning = '';
  String nameOfLocation = '';

  double heading = 0.0;

  double? totalDriveTime;

  bool _locationIsMoved = false;

  int? estimatedTravelTime;

  Widget? icon;
  Widget? icon2;

  int countDownClock = 0;

  double speedInKph = 0;
  String timeToReachDestination = '';
  String distanceToDestination = '';

  Map<String, dynamic> instructionDictionary = {};

  List<LatLng> polylinePoints = [];

  List<LatLng> staticPolylinePoints = [];

  List instructionsData = [];

  LatLng? _previousPosition;

  List<String> navigationText = [];

  List<LatLng> updatedPolyline = [];

  String arcGisApiKey =
      "AAPKb7a1d63200d747528ece8e0746d9a46dVWnWo2g8x_d1tQYqKI7QftZhrtPIwaAM2-stsoAAfcmimmd9BHcyMHDTGAJwz1d4";

  bool hasDeviated = false;

  int count = 0;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    getLanguage();
    _getLocationUpdates();

    if (_locationIsMoved == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(controller.initialPosition.value, 16.0);

        _updateMapOrientation();
      });
    }

    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        heading = event.heading ?? 0;
      });
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _updateMapOrientation() async {
    setState(() {
      mapController.rotate(heading);
    });
  }

  DateTime currentTime = DateTime.now();

  getDirections({
    required LocationData locationData,
    required LatLng destinationLocation,
  }) async {
    await controller.getDirectionsApiNav(
      context,
      sourceLocation: LatLng(locationData.latitude!, locationData.longitude!),
      destinationLocation: controller.destinationPosition!,
    );

    controller.distanceFromLocale.value =
        controller.directionsModel.routeInfo!.first.distance!;

    updatedPolyline = [];

    controller.polylineLatLngs = decodePolyline(
        controller.directionsModel.routeInfo!.first.geometry!.coordinates!);

    _updateTurnByTurnNavigation(locationData);
  }

  /// Gets the users location and updates the map
  // StreamSubscription<Position>? positionStreamSubscription;
  // void _getLocationUpdates() async {
  //   positionStreamSubscription = Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 1,
  //     ),
  //   ).listen((Position position) async {
  //     if (LatLng(position.latitude, position.longitude) ==
  //         controller.destinationPosition) {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text('You have reached your destination'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Get.back();
  //                   },
  //                   child: const Text('Ok'),
  //                 )
  //               ],
  //             );
  //           });
  //       Get.back();
  //     }
  //     _hasDeviatedFromRoute(position);

  //     if (!isStarted) {
  //       getDirections(
  //         destinationLocation: controller.destinationPosition!,
  //         position: position,
  //       );

  //       setState(() {
  //         staticPolylinePoints = controller.polylineLatLngs;
  //       });

  //       final distance = Geolocator.distanceBetween(
  //         position.latitude,
  //         position.longitude,
  //         controller.destinationPosition!.latitude,
  //         controller.destinationPosition!.longitude,
  //       );

  //       debugPrint('$distance');

  //       double speed = position.speed;
  //       double speedAccuracy = position.speedAccuracy;

  //       speedInKph = speedAccuracy < 4 ? speed * 3.6 : 0;

  //       log('Speed: $speedInKph km/h');

  //       distanceToDestination = '${(distance / 1000).toStringAsFixed(1)} km';

  //       log('$distanceToDestination to destination');

  //       setState(() {
  //         isStarted = true;
  //       });
  //     } else if (isStarted && hasDeviated) {
  //       getDirections(
  //           destinationLocation: controller.destinationPosition!,
  //           position: position);

  //       double speed = position.speed;
  //       double speedAccuracy = position.speedAccuracy;

  //       speedInKph = speedAccuracy < 4 ? speed * 3.6 : 0;

  //       setState(() {
  //         staticPolylinePoints = controller.polylineLatLngs;
  //         hasDeviated = false;
  //       });

  //       log('Speed: $speedInKph km/h');
  //     } else if (isStarted) {
  //       updateMap(position);

  //       double speed = position.speed;
  //       double speedAccuracy = position.speedAccuracy;

  //       speedInKph = speedAccuracy < 4 ? speed * 3.6 : 0;

  //       log('Speed: $speedInKph km/h');
  //     }
  //   });
  // }

  void _getLocationUpdates() {
    controller.currentLocation.value.onLocationChanged
        .listen((LocationData locationData) {
      controller.currentPosition.value =
          LatLng(locationData.latitude!, locationData.longitude!);

      if (controller.currentPosition.value == controller.destinationPosition) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('You have reached your destination'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            });
        Get.back();
      }

      _hasDeviatedFromRoute(locationData);

      if (!isStarted) {
        getDirections(
          destinationLocation: controller.destinationPosition!,
          locationData: locationData,
        );

        double speed = locationData.speed!;
        double speedAccuracy = locationData.speedAccuracy!;

        speedInKph = speedAccuracy < 4 ? 0 : speed * 3.6;

        log('Speed: $speedInKph km/h');
      } else if (isStarted && hasDeviated) {
        getDirections(
            destinationLocation: controller.destinationPosition!,
            locationData: locationData);

        double speed = locationData.speed!;
        double speedAccuracy = locationData.speedAccuracy!;

        speedInKph = speedAccuracy < 4 ? 0 : speed * 3.6;

        setState(() {
          staticPolylinePoints = controller.polylineLatLngs;
          hasDeviated = false;
        });

        log('Speed: $speedInKph km/h');
      } else if (isStarted) {
        updateMap(locationData);

        double speed = locationData.speed!;
        double speedAccuracy = locationData.speedAccuracy!;

        speedInKph = speedAccuracy < 4 ? speed * 3.6 : 0;

        log('Speed: $speedInKph km/h');
      }
    });
  }

  void updateMap(LocationData locationData) async {
    updatePolyline(locationData);
    _updateTurnByTurnNavigation(locationData);
  }

  void updatePolyline(LocationData currentPosition) {
    LatLng userLocation =
        LatLng(currentPosition.latitude!, currentPosition.longitude!);

    // Find the closest point on the route
    LatLng closestPoint =
        findClosestPointOnRoute(userLocation, controller.polylineLatLngs);

    // Trim the original polyline
    updatedPolyline =
        trimPolylineFromPoint(controller.polylineLatLngs, closestPoint);

    setState(() {});
  }

  String? language;
  getLanguage() async {
    if (mounted) {
      language = await Shared_Preferences.prefGetString(
          Shared_Preferences.language, 'en');
      setState(() {});
    }
  }

  void _updateTurnByTurnNavigation(LocationData locationData) {
    // List of steps from the directions API
    List<Steps> steps = controller.directionsModel.routeInfo!.first.steps!;

    log('$steps');

    // Initial text and icon setup
    text = steps.first.instruction;
    icon = getIconImage(text ?? '');

    // Decode the polyline from the geometry field
    List<LatLng> routePolyline = decodePolyline(
        controller.directionsModel.routeInfo!.first.geometry!.coordinates!);

    // Calculate the total distance to the destination
    double totalDistance = calculateTotalDistance(routePolyline);
    print(
        "Total distance to destination: ${totalDistance.toStringAsFixed(2)} kilometers");

    // Calculate the remaining distance from the current position
    double distanceRemaining = calculateDistanceRemaining(
        routePolyline, LatLng(locationData.latitude!, locationData.longitude!));
    print(
        "Distance remaining: ${distanceRemaining.toStringAsFixed(2)} kilometers");

    // Update the navigation instruction based on the remaining distance
    for (var step in steps) {
      double stepRemainingDistance =
          double.parse(step.remainingDistance!.split(' ').first);

      if (distanceRemaining <= stepRemainingDistance) {
        text = step.instruction;
        icon = getIconImage(text ?? '');

        // Parse the instruction and speak it using TTS
        dom.Document document = html_parser.parse(text ?? '');
        flutterTts.speak(document.body!.text);
        break;
      }
    }
  }

  double calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      double segmentDistance = Geolocator.distanceBetween(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );

      totalDistance += segmentDistance;
    }

    return totalDistance / 1000; // Convert distance to kilometers
  }

  double calculateDistanceRemaining(
      List<LatLng> points, LatLng currentPosition) {
    double smallestDifference = double.infinity;
    int indexOfClosestPoint = -1;

    // Find the closest point on the route to the current position
    for (int i = 0; i < points.length - 1; i++) {
      double differenceBetweenPoints = Geolocator.distanceBetween(
        points[i].latitude,
        points[i].longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (differenceBetweenPoints < smallestDifference) {
        smallestDifference = differenceBetweenPoints;
        indexOfClosestPoint = i;
      }
    }

    // Log the closest point information
    log('Point with smallest difference: ${points[indexOfClosestPoint]} at index $indexOfClosestPoint');

    // Create a new list of points from the closest point to the end
    List<LatLng> remainingPoints = points.sublist(indexOfClosestPoint);

    // Calculate the remaining distance along the polyline
    double distanceRemaining = calculateTotalDistance(remainingPoints);

    return distanceRemaining;
  }

  void _hasDeviatedFromRoute(LocationData locationData) {
    // Find the closest point on the route
    LatLng closestPoint = findClosestPointOnRoute(
        LatLng(locationData.latitude!, locationData.longitude!),
        controller.polylineLatLngs);

    // Calculate the distance between the user's current position and the closest point on the route
    double distanceToRoute = Geolocator.distanceBetween(
          locationData.latitude!,
          locationData.longitude!,
          closestPoint.latitude,
          closestPoint.longitude,
        ) /
        1000;

    // If the user is more than 10 meters away from the route, they have deviated
    if (distanceToRoute > 0.01) {
      hasDeviated = true;
    } else {
      hasDeviated = false;
    }
  }

  Set<Marker> animationMarkers = {};

  Widget? getIconImage(String instruction) {
    instruction = instruction.toLowerCase();
    if (instruction.contains('north') || instruction.contains('south')) {
      return Image.asset(
        Images.departStraight,
        color: Colors.white,
      );
    } else if (instruction.contains('right') || instruction.contains('east')) {
      return const Icon(
        Icons.turn_right,
        size: 36,
        color: Colors.white,
      );
    } else if (instruction.contains('sharp left')) {
      return Image.asset(
        Images.sharpLeft,
        color: Colors.white,
      );
    } else if (instruction.contains('left') || instruction.contains('west')) {
      return const Icon(
        Icons.turn_left,
        size: 36,
        color: Colors.white,
      );
    } else if (instruction.contains('sharp right')) {
      return Image.asset(
        Images.sharpRight,
        color: Colors.white,
      );
    } else if (instruction.contains('straight') ||
        instruction.contains(
          'continue forward',
        )) {
      return Image.asset(
        Images.continueStraight,
        color: Colors.white,
      );
    } else if (instruction.contains('u-turn') ||
        instruction.contains('make a u-turn')) {
      return Image.asset(
        Images.uTurnLeft,
        color: Colors.white,
      );
    } else if (instruction.contains('destination')) {
      return const Icon(
        Icons.location_on,
        size: 36,
        color: Colors.white,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: controller.initialPosition.value,
                            initialZoom: 12.0,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.all,
                            ),
                            onPositionChanged: (position, hasGesture) {
                              if (hasGesture) {
                                setState(() {
                                  _locationIsMoved = true;
                                });
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: AppStrings.baseMap,
                              subdomains: const ['server', 'services', 'www'],
                              additionalOptions: {
                                'apiKey': arcGisApiKey,
                              },
                              tileProvider:
                                  const FMTCStore('mapStore').getTileProvider(),
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: staticPolylinePoints,
                                  strokeWidth: 8.0,
                                  color: const Color(0xFFB6CAEB),
                                ),
                                Polyline(
                                  points: updatedPolyline.isEmpty
                                      ? controller.polylineLatLngs
                                      : updatedPolyline,
                                  strokeWidth: 8.0,
                                  color: const Color(0xff234274),
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: controller.initialPosition.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black38,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  height: 15,
                                  width: 15,
                                ),
                                Marker(
                                  point: controller.destinationPosition!,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                                Marker(
                                  point: controller.currentPosition.value,
                                  child: Transform.rotate(
                                    angle: (heading * (math.pi / 180)),
                                    child: const Icon(
                                      Icons.navigation,
                                      size: 30,
                                      color: Color(0xff234274),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                top: 28,
                right: 8,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xff234274),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        icon ?? const SizedBox(),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              html.Html(
                                data: text ?? '',
                                style: {
                                  'body': html.Style(
                                    color: Colors.white,
                                    fontSize: html.FontSize.large,
                                  ),
                                  "b": html.Style(
                                    fontSize: html.FontSize.xxLarge,
                                    color: Colors.white,
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!_locationIsMoved) ...{
              Positioned(
                bottom: 130,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 1,
                    color: Colors.transparent,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              speedInKph.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'km/h',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            } else ...{
              Positioned(
                bottom: 130,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _locationIsMoved = false;
                      });
                      mapController.move(
                          controller.currentPosition.value, 18.0);
                      _updateMapOrientation();
                    },
                    child: Material(
                      shape: const CircleBorder(),
                      elevation: 1,
                      color: Colors.transparent,
                      child: Container(
                        height: 60,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.navigation_outlined),
                              Text(
                                'Re-centre',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            },
            DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.15,
              minChildSize: 0.15,
              maxChildSize: 0.20,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF2A3439),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: 5,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B444B),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${(controller.directionsModel.routeInfo!.first.estimatedTravelTime! / 60).round()}',
                                    style: const TextStyle(
                                      color: Color(0xff234274),
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    ' min',
                                    style: TextStyle(
                                      color: Color(0xff234274),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    controller.distanceFromLocale.value,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    height: 2,
                                    width: 2,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff2A3439),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    getStopTime((controller
                                                .directionsModel
                                                .routeInfo!
                                                .first
                                                .estimatedTravelTime! /
                                            60)
                                        .round()
                                        .toDouble()),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _fitBounds();
                            setState(() {
                              _locationIsMoved = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: const Icon(
                                Icons.fork_left,
                                color: Color(0xFF2A3439),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _fitBounds() {
    if (controller.destinationPosition != null) {
      LatLngBounds bounds = LatLngBounds.fromPoints(
          [controller.initialPosition.value, controller.destinationPosition!]);
      mapController.fitCamera(
        CameraFit.bounds(bounds: bounds),
      );
    }
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:get/get.dart';
// import 'package:iraqdriver/controller/common_controller.dart';
// import 'package:iraqdriver/helper/route_helper.dart';
// import 'package:iraqdriver/helper/shar_pref.dart';
// import 'package:iraqdriver/utils/useful_methods.dart';

// class TaskParkedScreen extends StatefulWidget {
//   const TaskParkedScreen({super.key});

//   @override
//   State<TaskParkedScreen> createState() => _TaskParkedScreenState();
// }

// class _TaskParkedScreenState extends State<TaskParkedScreen> {
//   MapBoxNavigationViewController? _controller;
//   final CommonController controller =
//       Get.put(CommonController(commonRepo: Get.find()));
//   String? _instruction;
//   final bool _isMultipleStop = false;
//   double? _distanceRemaining, _durationRemaining;
//   bool _routeBuilt = false;
//   bool _isNavigating = false;
//   bool _arrived = false;
//   late MapBoxOptions _navigationOption;
//   Map<String, dynamic> userPosition = {};

//   var wayPoints = <WayPoint>[];

//   String? language;
//   getLanguage() async {
//     if (mounted) {
//       language = await Shared_Preferences.prefGetString(
//           Shared_Preferences.language, 'en');
//       setState(() {});
//     }
//   }

//   Future<void> initialize() async {
//     if (!mounted) return;
//     _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
//     _navigationOption.mode = MapBoxNavigationMode.drivingWithTraffic;
//     _navigationOption.initialLatitude = currentUserPosition!.latitude;
//     _navigationOption.initialLongitude = currentUserPosition!.longitude;
//     _navigationOption.language = language;
//     _navigationOption.simulateRoute = false;
//     _navigationOption.isOptimized = true;

//     MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
//   }

//   @override
//   void initState() {
//     initialize();

//     final start = WayPoint(
//       name: "Start Location",
//       latitude: currentUserPosition!.latitude,
//       longitude: currentUserPosition!.longitude,
//     );
//     final destination = WayPoint(
//         name: "Destination Location",
//         latitude: controller.destinationPosition!.latitude,
//         longitude: controller.destinationPosition!.longitude);

//     wayPoints.add(start);
//     wayPoints.add(destination);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 1,
//             child: Container(
//               color: Colors.grey[100],
//               child: MapBoxNavigationView(
//                 options: _navigationOption,
//                 onRouteEvent: _onRouteEvent,
//                 onCreated: (MapBoxNavigationViewController controller) async {
//                   _controller = controller;
//                   controller.initialize();

//                   // Start navigation after initialization
//                   await MapBoxNavigation.instance.startNavigation(
//                     wayPoints: wayPoints,
//                     options: _navigationOption,
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _onRouteEvent(e) async {
//     _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
//     _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         _arrived = progressEvent.arrived!;
//         if (progressEvent.currentStepInstruction != null) {
//           _instruction = progressEvent.currentStepInstruction;
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         _routeBuilt = true;
//         break;
//       case MapBoxEvent.route_build_failed:
//         _routeBuilt = false;
//         break;
//       case MapBoxEvent.navigation_running:
//         _isNavigating = true;
//         break;
//       case MapBoxEvent.on_arrival:
//         _arrived = true;
//         if (!_isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller?.finishNavigation();
//         }
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         _routeBuilt = false;
//         _isNavigating = false;
//         Get.toNamed(RouteHelper.getTaskParkedScreen());
//         break;
//       default:
//         break;
//     }
//     // Refresh UI
//     setState(() {});
//   }
// }
