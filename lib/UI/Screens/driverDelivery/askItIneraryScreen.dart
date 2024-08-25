import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/image.dart';
import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskItineraryScreen extends StatefulWidget {
  const TaskItineraryScreen({super.key});

  @override
  State<TaskItineraryScreen> createState() => _TaskItineraryScreenState();
}

class _TaskItineraryScreenState extends State<TaskItineraryScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  String packageName = '';
  int? sIndex;

  @override
  void initState() {
    super.initState();
    getLanguage();
    getTaskListData();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  /// Get Task List
  getTaskListData() async {
    String? packageId = await Shared_Preferences.prefGetString(
            Shared_Preferences.packageId, '') ??
        '';
    controller.getTaskList(packageId: packageId ?? '').then(
      (value) {
        hideLoader();
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(builder: (commonController) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: Colors.black38,
            title: Text(AppLocalizations.of(context)!.task,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).secondaryHeaderColor),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      /// bottom index 2 screen
                      Text(AppLocalizations.of(context)!.searchForSpecificTask,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 4),
                      Text(
                          AppLocalizations.of(context)!
                              .scanBarcodeOfPackageWithPhone,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          Get.back();
                          // commonController.changeBottomIndex(1);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .scanTheBarcode,
                                    border: InputBorder.none,
                                    filled: true,
                                    focusColor: const Color(0xffF8FAFF)),
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 48,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF8FAFF),
                                  borderRadius: BorderRadius.circular(4)),
                              alignment: Alignment.center,
                              child: Image.asset(Images.btScanIcon,
                                  height: 25, width: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Text(
                  AppLocalizations.of(context)!.taskItinerary,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  AppLocalizations.of(context)!.thisIsTheListOfPackages,
                  style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                SizedBox(height: Get.height * 0.02),
                (commonController.taskList == null &&
                        commonController.taskList!.isEmpty)
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noDataFound,
                          style: const TextStyle(fontSize: 15),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: commonController.taskList!.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 85,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Image.asset(
                                              Images.locationIcon,
                                              height: 30,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: ColoredBox(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: Text(
                                                    "${commonController.taskList![index].idx}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1,
                                                        fontSize: 16)),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5,
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          sIndex = index;
                                        });
                                        packageName = commonController
                                            .taskList![index].name
                                            .toString();
                                        commonController
                                            .taskList![index].isSelected = true;
                                        Shared_Preferences.prefSetString(
                                            Shared_Preferences.trackData,
                                            jsonEncode(commonController
                                                    .taskList![index])
                                                .toString());
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Picked up at hub 2:25 pm',
                                              style: TextStyle(
                                                  // color: (commonController.taskList![index].isSelected == true) ? Colors.green : Theme.of(context).primaryColor,
                                                  color: (sIndex == index)
                                                      ? Colors.green
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0.4,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              commonController
                                                  .taskList![index].name!,
                                              style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              commonController.taskList![index]
                                                  .serviceRequest!,
                                              style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(height: Get.height * 0.08),
              ],
            ),
          ),
          bottomSheet: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: MediaQuery.of(context).size.height * 0.085,
            child: Hero(
              tag: "taskTravel",
              child: Material(
                child: CustomButtons(
                  text: AppLocalizations.of(context)!.continueTitle,
                  onTap: () async {
                    if (packageName == '' && packageName.isEmpty) {
                      showToast("Please select package");
                    } else {
                      commonController
                          .shipmentOutOfDeliveryApi(context, name: packageName)
                          .then((value) {
                        packageName = '';
                        // Get.toNamed(RouteHelper.getServiceDeliverScreen());
                        Get.toNamed(RouteHelper.getTravelScreen());
                        commonController.update();
                      });
                    }
                    // Get.toNamed(RouteHelper.getServiceDeliverScreen());
                    // Get.toNamed(RouteHelper.getTakePickupScreen());
                    // Get.toNamed(RouteHelper.getTravelScreen());
                  },
                  noFillData: false,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
