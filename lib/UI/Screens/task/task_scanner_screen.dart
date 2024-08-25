import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import '../../../../utils/image.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../model/task_list_model.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskScannerScreen extends StatefulWidget {
  const TaskScannerScreen({super.key});

  @override
  State<TaskScannerScreen> createState() => _TaskScannerScreenState();
}

class _TaskScannerScreenState extends State<TaskScannerScreen> {
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  TaskList taskList = TaskList();

  @override
  void initState() {
    super.initState();
    getLanguage();
    getPackageIdData();
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black38,
          title: Text(AppLocalizations.of(context)!.service,
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
              InkWell(
                onTap: () {},
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      Images.demoScannerImage,
                      height: 300,
                      width: Get.width,
                    )),
              ),
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
                    Text(
                      AppLocalizations.of(context)!.signatureRequired,
                      style: const TextStyle(
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
                    SizedBox(height: Get.height * 0.03),
                    CustomButtons(
                      text: AppLocalizations.of(context)!.continueTitle,
                      onTap: () {
                        Get.toNamed(RouteHelper.getTaskBarcodeScanScreen());
                      },
                      noFillData: false,
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.unableToDeliverPackage,
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700),
                      ),
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
  }
}
