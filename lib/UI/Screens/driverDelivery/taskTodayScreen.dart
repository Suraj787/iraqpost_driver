import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTodayScreen extends StatefulWidget {
  const TaskTodayScreen({super.key});

  @override
  State<TaskTodayScreen> createState() => _TaskTodayScreenState();
}

class _TaskTodayScreenState extends State<TaskTodayScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  String? packageId;

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  String? language;
  getLanguage() async {
    packageId = await Shared_Preferences.prefGetString(
            Shared_Preferences.packageId, 'IPSD240617001') ??
        'IPSD240617001';
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
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
            title: Text(AppLocalizations.of(context)!.startTask,
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
          body: (commonController.taskList == null &&
                  commonController.taskList!.isEmpty)
              ? showLoader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.task,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: Get.height * 0.03),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: Get.width * 0.02),
                            const Text("30th Map 2024",
                                style: TextStyle(
                                  color: Color(0xFF5F6979),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                )),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.03),
                        Text(AppLocalizations.of(context)!.transactionId,
                            style: const TextStyle(
                              color: Color(0xFF5F6979),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            )),
                        Text("$packageId",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(height: Get.height * 0.03),
                        Text(AppLocalizations.of(context)!.noOfShipments,
                            style: const TextStyle(
                              color: Color(0xFF5F6979),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            )),
                        Text("10",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(height: Get.height * 0.04),
                        // SizedBox(
                        //   height: 100,
                        //   child: Row(
                        //     children: [
                        //       Expanded(child: CustomTextFiled(title: AppLocalizations.of(context)!.route,textController: TextEditingController(),hint: AppLocalizations.of(context)!.route,starRemove: true)),
                        //       const SizedBox(width: 6),
                        //       Expanded(child: CustomTextFiled(title: AppLocalizations.of(context)!.deliveries,textController: TextEditingController(),hint: AppLocalizations.of(context)!.deliveries,starRemove: true)),
                        //       const SizedBox(width: 6),
                        //       Expanded(child: CustomTextFiled(title: AppLocalizations.of(context)!.pickUp,textController: TextEditingController(),hint: AppLocalizations.of(context)!.pickUp,starRemove: true)),
                        //       const SizedBox(width: 6),
                        //       Expanded(child: CustomTextFiled(title: AppLocalizations.of(context)!.register,textController: TextEditingController(),hint: packageId ?? "Packages",starRemove: true)),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: Get.height * 0.02),
                        CustomButtons(
                          text: AppLocalizations.of(context)!.startTask,
                          onTap: () {
                            commonController
                                .startTaskApi(context, docId: packageId)
                                .then(
                                  (value) {},
                                );
                            Get.toNamed(RouteHelper.getTaskItineraryScreen());
                          },
                          noFillData: false,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
