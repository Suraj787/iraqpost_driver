import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:internet_popup/internet_popup.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:iraqdriver/helper/shar_pref.dart';
import 'package:iraqdriver/model/login_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart' as per;

import '../../../api/api_component.dart';
import '../../../helper/route_helper.dart';
import '../../../utils/image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  User userData = User();

  @override
  void initState() {
    super.initState();
    getLanguage();
    getPermission();
    getUserData();
    getDashboardApiData();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  getUserData() async {
    String? data = await Shared_Preferences.prefGetString(
        Shared_Preferences.keyUserData, '');
    userData = User.fromJson(jsonDecode(data.toString()));
    setState(() {
      hideLoader();
    });
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

  /// Get Dashboard Api Data
  getDashboardApiData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.getDashboardDataApi(context).then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(builder: (commonController) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          body: (controller.isLoading)
              ? showLoader()
              : (controller.dashboardData == null)
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noDataFound,
                        style: const TextStyle(fontSize: 15),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff264980),
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(40))),
                            height: 350,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 70),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Image(
                                          image: AssetImage(Images.appIran),
                                          width: 40,
                                          height: 40,
                                          color: Colors.white,
                                        ),
                                        CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.white38,
                                            child: IconButton(
                                                onPressed: () {
                                                  Get.toNamed(RouteHelper
                                                      .getNotificationScreen());
                                                },
                                                icon: const Icon(
                                                  Icons.notifications_none,
                                                  color: Colors.white,
                                                  size: 25,
                                                )))
                                      ],
                                    ),
                                    const SizedBox(height: 26),
                                    Text(
                                      '${AppLocalizations.of(context)!.hi} ${userData.firstName ?? ''},',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.welcome,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .secondaryHeaderColor),
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .scanPackageFromHub,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              )),
                                          const SizedBox(height: 4),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .scanBarcodeOfPackageWithPhone,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54)),
                                          const SizedBox(height: 6),
                                          InkWell(
                                            onTap: () {
                                              commonController
                                                  .changeBottomIndex(1);
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.all(13),
                                                  color:
                                                      const Color(0xffF8FAFF),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${AppLocalizations.of(context)!.scanTheBarcode}    ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14),
                                                      ),
                                                      Image.asset(
                                                        Images.serachBarIcons,
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                                Container(
                                                  width: 50,
                                                  height: 48,
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffF8FAFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                      Images.btScanIcon,
                                                      height: 25,
                                                      width: 30,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    Text(
                                      AppLocalizations.of(context)!.taskToday,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Row(
                                      children: [
                                        (commonController.dashboardData == null)
                                            ? Expanded(
                                                child: myShip(Images.delivryBox,
                                                    "${AppLocalizations.of(context)!.arriving}\n${AppLocalizations.of(context)!.shipments}",
                                                    zero: "0"))
                                            : Expanded(
                                                child: InkWell(
                                                    onTap: () {
                                                      Get.toNamed(RouteHelper
                                                          .getArrivingShipmentScreenScreen());
                                                    },
                                                    child: myShip(
                                                        Images.delivryBox,
                                                        "${AppLocalizations.of(context)!.arriving}\n${AppLocalizations.of(context)!.shipments}",
                                                        zero:
                                                            "${commonController.dashboardData!.taskAssigned ?? '0'}"))),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(RouteHelper
                                                      .getAssignedPickUpScreenScreen());
                                                },
                                                child: myShip(Images.delivryBox,
                                                    "${AppLocalizations.of(context)!.assigned}\n${AppLocalizations.of(context)!.pickUp}",
                                                    zero:
                                                        "${commonController.dashboardData!.taskPickup ?? '0'}"))),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.03),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .quickActions,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    GridView(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: 90,
                                      ),
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Get.toNamed(RouteHelper
                                                  .getCompletedScreen());
                                            },
                                            child: Hero(
                                                tag: "completed",
                                                child: Material(
                                                    child: myShip(
                                                        Images.completedBox,
                                                        "${AppLocalizations.of(context)!.completed}\n${AppLocalizations.of(context)!.shipments}")))),
                                        InkWell(
                                            onTap: () {
                                              Get.toNamed(RouteHelper
                                                  .getPendingScreen());
                                            },
                                            child: Hero(
                                                tag: "pending",
                                                child: Material(
                                                    child: myShip(
                                                        Images.pendiingBox,
                                                        "${AppLocalizations.of(context)!.pending}\n${AppLocalizations.of(context)!.shipments}")))),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(RouteHelper
                                                .getInputLocationScreen());
                                          },
                                          child: myShip(
                                              Images.lacationIcon,
                                              AppLocalizations.of(context)!
                                                  .quickNavigation),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Get.toNamed(RouteHelper
                                                  .getContactScreen());
                                            },
                                            child: myShip(Images.helpIcon,
                                                "${AppLocalizations.of(context)!.needHelp}\n${AppLocalizations.of(context)!.contactUs}")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
        ),
      );
    });
  }

  Widget myShip(String images, String text, {String? zero}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).secondaryHeaderColor),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset(images, height: 45, width: 60)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (zero != null)
                  Text(zero,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      )),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
