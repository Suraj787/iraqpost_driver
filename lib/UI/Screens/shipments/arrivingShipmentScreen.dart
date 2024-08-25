import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helper/shar_pref.dart';

class ArrivingShipmentScreen extends StatefulWidget {
  const ArrivingShipmentScreen({super.key});

  @override
  State<ArrivingShipmentScreen> createState() => _ArrivingShipmentScreenState();
}

class _ArrivingShipmentScreenState extends State<ArrivingShipmentScreen> {
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
      commonController.getArrivingShipmentListApi(context);
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
                "${AppLocalizations.of(context)!.arriving} ${AppLocalizations.of(context)!.shipments}",
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
                    child: (commonController.arrivingShipmentsList!.isEmpty)
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
                                commonController.arrivingShipmentsList!.length,
                            itemBuilder: (context, index) {
                              String reqData =
                                  intl.DateFormat("yyyy-MM-dd hh:mm a").format(
                                      commonController
                                          .arrivingShipmentsList![index]
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
                                                      .arrivingShipmentsList![
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
                                                        .arrivingShipmentsList![
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
                                        "Customer : ${commonController.arrivingShipmentsList![index].customer ?? '-'}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            decorationThickness: 1.5,
                                            color: Theme.of(context)
                                                .primaryColor)),
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
