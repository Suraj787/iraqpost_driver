// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iraqdriver/api/api_component.dart';
import 'package:iraqdriver/constants/constant_apis.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:iraqdriver/helper/route_helper.dart';
import 'package:iraqdriver/helper/shar_pref.dart';
import 'package:iraqdriver/model/route_model.dart';
import 'package:iraqdriver/model/task_list_model.dart';
import 'package:iraqdriver/utils/string.dart';
import 'package:iraqdriver/utils/useful_methods.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class TaskInputLocationScreen extends StatefulWidget {
  const TaskInputLocationScreen({super.key});

  @override
  State<TaskInputLocationScreen> createState() =>
      _TaskInputLocationScreenState();
}

class _TaskInputLocationScreenState extends State<TaskInputLocationScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MapController mapController = MapController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<LatLng> _polylinePoints = [];

  bool onStartTapped = false;

  TaskList taskList = TaskList();

  String arcGisApiKey =
      "AAPKb7a1d63200d747528ece8e0746d9a46dVWnWo2g8x_d1tQYqKI7QftZhrtPIwaAM2-stsoAAfcmimmd9BHcyMHDTGAJwz1d4";

  final List<Marker> _markers = [];
  final List<Polyline> _polylines = <Polyline>[];

  @override
  void initState() {
    super.initState();
    getLanguage();
    controller.isTracking.value = true;
    _getLocationOnce();
    // getPackageIdData();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  String? language;
  getLanguage() async {
    if (mounted) {
      language = await Shared_Preferences.prefGetString(
          Shared_Preferences.language, 'en');
      setState(() {});
    }
  }

  /// From API
  // void loadRoute() {
  //   final data =
  //       jsonDecode(controller.routeData![0].coordinates ?? routeJsonData);
  //   final routeData = RouteModel.fromJson(data);

  //   controller.destinationPosition = const LatLng(9.05785000, 7.49508000);
  //   setState(
  //     () {
  //       for (var route in routeData.routeInfo) {
  //         _markers.clear();
  //         _markers.add(
  //           Marker(
  //             width: 15.0,
  //             height: 15.0,
  //             point: controller.destinationPosition!,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: const Color(0xFF234274),
  //                 border: Border.all(
  //                   color: Colors.black12,
  //                   width: 2,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );

  //         fetchRouteDetails(controller.initialPosition.value,
  //             controller.destinationPosition!);
  //       }
  //     },
  //   );
  // }

  /// Get Task List
  // getTaskListData() async {
  //   String? packageId = await Shared_Preferences.prefGetString(
  //           Shared_Preferences.packageId, 'IPSD240629017') ??
  //       '';

  //   controller.getTaskList(packageId: packageId).then((value) async {
  //     _getLocationUpdates();

  //     if (controller.routeData != null && controller.routeData!.isNotEmpty) {
  //       // controller.initialPosition.value = LatLng(
  //       //     double.parse(controller.taskList![0].latitude!.toString()),
  //       //     double.parse(controller.taskList![0].longitude!.toString()));
  //       loadRoute();
  //     }
  //     hideLoader();
  //   });
  //   setState(() {});
  // }

  // getPackageIdData() async {
  //   String? data = await Shared_Preferences.prefGetString(
  //       Shared_Preferences.trackData1, '');
  //   taskList = TaskList.fromJson(jsonDecode(data.toString()));
  //   setState(() {});
  // }
  getDirections(StateSetter setState) async {
    setState(() {
      controller.isDirections.value = onStartTapped ? false : true;
      controller.isLoadingSheet.value = true;
    });

    await controller.getDirectionsApi(
      context,
      sourceLocation: controller.initialPosition.value,
      destinationLocation: controller.destinationPosition!,
    );

    // Proceed with UI updates after the API call
    setState(() {
      controller.isLoadingSheet.value = false;
      onStartTapped = true;
    });

    controller.timeToReach.value =
        controller.directionsModel.routeInfo!.first.formattedTravelTime!;

    controller.distanceFromLocale.value =
        controller.directionsModel.routeInfo!.first.distance!;

    controller.polylineLatLngs = decodePolyline(
        controller.directionsModel.routeInfo!.first.geometry!.coordinates!);

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          points: controller.polylineLatLngs,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      );
    });
  }

  void _getLocationOnce() async {
    if (mounted) {
      try {
        // Get the current location once
        LocationData locationData =
            await controller.location.value.getLocation();

        setState(() {
          controller.isLocated.value = true;
          controller.initialPosition.value =
              LatLng(locationData.latitude!, locationData.longitude!);

          currentUserPosition =
              LatLng(locationData.latitude!, locationData.longitude!);


          // Move the map to the current location if tracking is enabled
          if (controller.isTracking.value) {
            mapController.move(
              LatLng(locationData.latitude!, locationData.longitude!),
              mapController.camera.zoom,
            );
          }
        });
      } catch (e) {
        print("Failed to get location: $e");
      }
    }
  }

  Future<List<String>> fetchLocationSuggestions(String query) async {
    var uri = Uri.parse(
      'https://geocode-api.arcgis.com/arcgis/rest/services/World/GeocodeServer/suggest?text=$query&f=json&maxSuggestions=5&token=$arcGisApiKey',
    );

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> suggestions = data['suggestions'];
      return suggestions
          .map((suggestion) => suggestion['text'].toString())
          .toList();
    } else {
      return [];
    }
  }

  Future<String> getLocationName(LatLng location) async {
    var uri = Uri.parse(
      'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?location=${location.longitude},${location.latitude}&f=json&token=$arcGisApiKey',
    );

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['address']['LongLabel'];
    } else {
      throw Exception('Failed to reverse geocode location');
    }
  }

  String getImageryUrl(LatLng location) {
    return 'https://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/15/${location.latitude}/${location.longitude}';
  }

  void fetchRouteDetails(LatLng origin, LatLng destination) async {
    setState(() {
      controller.isLoadingSheet.value = true;
    });
    try {
      String locationName = await getLocationName(destination);
      String imageryUrl = getImageryUrl(destination);
      debugPrint('Destination Name: $locationName');
      debugPrint('Imagery URL: $imageryUrl');

      if (controller.destinationPosition != null) {
        _fitBounds();
        _showBottomSheet(locationName: locationName, imageryUrl: imageryUrl);
      }

      setState(() {
        controller.isLoadingSheet.value = false;
      });
    } catch (e) {
      setState(() {
        controller.isLoadingSheet.value = false;
      });
      debugPrint('Error fetching route details: $e');
    }
  }

  void _showBottomSheet(
      {required String locationName, required String imageryUrl}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: controller.isLoadingSheet.value
                      ? buildSkeletonLoader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                height: 7,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBD9D9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              !controller.isDirections.value
                                  ? 'Destination: $locationName'
                                  : '${controller.timeToReach.value} (${controller.distanceFromLocale.value})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Visibility(
                                  visible: !controller.isDirections.value,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getDirections(setState);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff234274)),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.directions,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        //Here
                                        Text(
                                          'Directions',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    if (_polylines.isEmpty) {
                                      setState(() {
                                        onStartTapped = true;
                                      });

                                      await getDirections(setState);

                                      Get.toNamed(
                                          RouteHelper.getTaskParkedScreen());

                                      // Optionally show a message or error to the user
                                    } else {
                                      // If _polylines is not empty, navigate directly
                                      Get.toNamed(
                                          RouteHelper.getTaskParkedScreen());
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.navigation,
                                          color: Color(0xff234274),
                                        ),
                                        Text(
                                          'Start',
                                          style: TextStyle(
                                            color: Color(0xff234274),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    _shareLocation(locationName,
                                        controller.destinationPosition!);
                                  },
                                  icon: const Icon(Icons.share),
                                )
                              ],
                            ),
                            const Text(
                              'View Destination Image below',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            Image.network(imageryUrl, fit: BoxFit.cover),
                          ],
                        ),
                ),
              );
            },
          );
        });
      },
    ).whenComplete(() {
      setState(() {
        controller.destinationPosition = null;
        _markers.clear();
        _polylines.clear();
        controller.isLoadingSheet.value = false;
        controller.isDirections.value = false;
      });
    });
  }

  void _shareLocation(String locationName, LatLng destination) {
    final String shareText =
        'Check out this location: $locationName\nLatitude: ${destination.latitude}, Longitude: ${destination.longitude}\nhttps://www.google.com/maps/search/?api=1&query=${destination.latitude},${destination.longitude}';

    Share.share(shareText);
  }

  void searchLocation(String queryText) async {
    String query = queryText.trim();

    if (query.isNotEmpty) {
      final coordinateRegex = RegExp(r'^-?\d+(\.\d+)?,-?\d+(\.\d+)?$');
      if (coordinateRegex.hasMatch(query)) {
        List<String> coords = query.split(',');
        double lat = double.parse(coords[0]);
        double lon = double.parse(coords[1]);

        setState(() {
          controller.destinationPosition = LatLng(lat, lon);
          _markers.clear();
          _markers.add(
            Marker(
              width: 15.0,
              height: 15.0,
              point: controller.destinationPosition!,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF234274),
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                ),
              ),
            ),
          );
          _fitBounds();
          fetchRouteDetails(controller.initialPosition.value,
              controller.destinationPosition!);
        });
      } else {
        // If it's a place name, perform the API search
        var uri = Uri.parse(
            'https://geocode-api.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?SingleLine=$query&f=json&outFields=*&token=$arcGisApiKey');
        var response = await http.get(uri);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            var candidates = data['candidates'];
            if (candidates is List && candidates.isNotEmpty) {
              var location = candidates[0]['location'];
              if (location is Map<String, dynamic>) {
                double lat = location['y'];
                double lon = location['x'];

                setState(() {
                  controller.destinationPosition = LatLng(lat, lon);
                  _markers.clear();
                  _markers.add(
                    Marker(
                      width: 15.0,
                      height: 15.0,
                      point: controller.destinationPosition!,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF234274),
                          border: Border.all(
                            color: Colors.black12,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                  _fitBounds();
                  fetchRouteDetails(controller.initialPosition.value,
                      controller.destinationPosition!);
                });
              } else {
                debugPrint('Location data is not in expected format');
              }
            } else {
              debugPrint('No candidates found for the location');
            }
          } else {
            debugPrint('Response data is not in expected format');
          }
        } else {
          debugPrint('Failed to fetch location data');
        }
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    log('$mounted');
    if (mounted && controller.isLocated.value) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            width: 15.0,
            height: 15.0,
            point: latLng,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF234274),
                border: Border.all(
                  color: Colors.black12,
                  width: 2,
                ),
              ),
            ),
          ),
        );
        controller.destinationPosition = latLng;
        fetchRouteDetails(
            controller.initialPosition.value, controller.destinationPosition!);
      });
    } else {
      showToast(
          'pin your current location before proceeding to select a destination');
    }
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
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return await fetchLocationSuggestions(
                        textEditingValue.text);
                  },
                  onSelected: (String selection) {
                    searchController.text = selection;
                    searchLocation(selection);
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      searchFocusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: searchFocusNode,
                      onSubmitted: (value) {
                        if (controller.isLocated.value) {
                          searchLocation(fieldTextEditingController.text);
                        } else {
                          showToast(
                            'Pin your current location on the map to search',
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchLocation,
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (controller.isLocated.value) {
                              searchLocation(fieldTextEditingController.text);
                            } else {
                              showToast(
                                'Pin your current location on the map to search',
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
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
          body: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: controller.initialPosition.value,
              initialZoom: 10,
              onTap: _onMapTap,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: AppStrings.baseMap,
                additionalOptions: {
                  'apiKey': arcGisApiKey,
                },
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
                  ..._markers,
                ],
              ),
              PolylineLayer(
                polylines: _polylines,
              ),
            ],
          ),
          floatingActionButton: controller.destinationPosition == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          controller.isTracking.value = true;
                        });
                        _getLocationOnce();
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xff234274),
                      heroTag: "locationButton",
                      child: const Icon(Icons.my_location_rounded),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () {
                        if (controller.destinationPosition == null) {
                          showToast(
                              'Tap the map or search to select a destination');
                          searchFocusNode.requestFocus();
                        }
                        fetchRouteDetails(controller.initialPosition.value,
                            controller.destinationPosition!);
                      },
                      backgroundColor: const Color(0xff234274),
                      heroTag: "directionsButton",
                      child: const Icon(Icons.directions),
                    ),
                  ],
                )
              : null,
        ),
      );
    });
  }

  void _onPositionChanged(MapCamera position, bool hasGesture) {
    if (hasGesture) {
      setState(() {
        controller.isTracking.value = false;
      });
    }
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
