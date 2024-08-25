import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helper/shar_pref.dart';

class AssignedPickupScreen extends StatefulWidget {
  const AssignedPickupScreen({super.key});

  @override
  State<AssignedPickupScreen> createState() => _AssignedPickupScreenState();
}

class _AssignedPickupScreenState extends State<AssignedPickupScreen> {
  CommonController commonController =
      Get.put(CommonController(commonRepo: Get.find()));

  @override
  void initState() {
    getArrivingShipments();
    getLanguage();
    super.initState();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  getArrivingShipments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.getAssignedPickUpListApi(context);
    });
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
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF5F6979),
            ),
            title: Text(
                "${AppLocalizations.of(context)!.assigned} ${AppLocalizations.of(context)!.pickUp}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 10,left: 10),
            //     child: CircleAvatar(radius: 20,
            //         backgroundColor: Theme.of(context).primaryColor,
            //         child: IconButton(onPressed: (){
            //           Get.toNamed(RouteHelper.getNotificationScreen());
            //         }, icon: const Icon(Icons.notifications_none,color: Colors.white,size: 25,))),
            //   )
            // ],
          ),
          body: (commonController.isLoading)
              ? showLoader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: (commonController.assignedPickupList!.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.noDataFound,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount:
                                commonController.assignedPickupList!.length,
                            itemBuilder: (context, index) {
                              String reqData =
                                  intl.DateFormat("yyyy-MM-dd hh:mm a").format(
                                      commonController
                                          .assignedPickupList![index]
                                          .requestDate!);
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: Get.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffE9EDF2)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                              commonController
                                                      .assignedPickupList![
                                                          index]
                                                      .name ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xff264980)),
                                            child: Text(
                                                commonController
                                                        .assignedPickupList![
                                                            index]
                                                        .assignedToDriver ??
                                                    '-',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(reqData ?? '-',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        "Customer : ${commonController.assignedPickupList![index].customer ?? '-'}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            decorationThickness: 1.5,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     Expanded(flex: 6,
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           Text(AppLocalizations.of(context)!.pickUp, style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               decorationThickness: 1.5,
                                    //               decoration: TextDecoration.underline,
                                    //               color: Theme.of(context).primaryColor)),
                                    //           const SizedBox(height: 3,),
                                    //           (commonController.arrivingShipmentsList![index].customCity != null && commonController.arrivingShipmentsList![index].customCity!.isNotEmpty)
                                    //               ? Text('${commonController.arrivingShipmentsList![index].customCity ?? '-'}', style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               color: Theme.of(context).primaryColor))
                                    //               : Text('-', style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               color: Theme.of(context).primaryColor)),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     Expanded(flex: 4,
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           Text(AppLocalizations.of(context)!.destination, style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               decorationThickness: 1.5,
                                    //               decoration: TextDecoration.underline,
                                    //               color: Theme.of(context).primaryColor)),
                                    //           const SizedBox(height: 3,),
                                    //           (commonController.arrivingShipmentsList![index].cityTown != null && commonController.arrivingShipmentsList![index].cityTown!.isNotEmpty)
                                    //               ? Text('${commonController.arrivingShipmentsList![index].cityTown ?? '-'}', style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               color: Theme.of(context).primaryColor))
                                    //               : Text('-', style: TextStyle(
                                    //               fontSize: 12,
                                    //               fontWeight: FontWeight.w400,
                                    //               color: Theme.of(context).primaryColor)),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
        ),
      );
    });
  }
}
