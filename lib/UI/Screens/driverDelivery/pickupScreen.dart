import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import '../../../../utils/image.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../model/task_list_model.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  TaskList taskList = TaskList();

  @override
  void initState() {
    getLanguage();
    getPackageIdData();
    super.initState();
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
            title: Text(AppLocalizations.of(context)!.service,
                style: TextStyle(
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
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      Images.demoScannerImage,
                      height: 300,
                      width: Get.width,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getTakePickupScreen());
                        },
                        child: Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.retakePicture,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      const Text(
                        "Deliver 1 package",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.access_time, color: Color(0xff709FC1)),
                          Text("  12:00-6:00pm")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
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
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
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
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
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
                                  taskList.cityTown != null &&
                                          taskList.cityTown!.isNotEmpty
                                      ? Text(
                                          '${taskList.cityTown} ${taskList.postalCode ?? ''}',
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
                      Text(
                        AppLocalizations.of(context)!.signatureRequired,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Container(
                        height: 80,
                        width: 600,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: HandSignature(
                          control: control,
                          color: Colors.blueGrey,
                          width: 1.0,
                          maxWidth: 5.0,
                          type: SignatureDrawType.shape,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      CustomButtons(
                        text: AppLocalizations.of(context)!.finish,
                        onTap: () {
                          commonController
                              .shipmentDeliveredApi(context,
                                  name: taskList.name ?? '')
                              .then((value) {
                            Shared_Preferences.prefSetString(
                                Shared_Preferences.trackData, '');
                            commonController.changeBottomIndex(0);
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            commonController.update();
                          });
                        },
                        noFillData: false,
                      ),
                      SizedBox(height: Get.height * 0.02),
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
