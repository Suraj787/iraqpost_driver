import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../../model/barcode_scan_model.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanPackagesScreen extends StatefulWidget {
  const ScanPackagesScreen({super.key});

  @override
  State<ScanPackagesScreen> createState() => _ScanPackagesScreenState();
}

class _ScanPackagesScreenState extends State<ScanPackagesScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));
  List<String> xyz = [];
  List<BarcodeDetail>? barcodeDetails = [];
  List<BarcodeDetail>? myDuplicateList = [];

  @override
  void initState() {
    super.initState();
    getLanguage();
    getBarcodeList();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  List<BarcodeDetail>? tempList = [];
  getBarcodeList() async {
    String? data = await (Shared_Preferences.prefGetString(
        Shared_Preferences.barcodeDataList, ''));
    final List<dynamic> temp = jsonDecode(data!);
    barcodeDetails = temp.map<BarcodeDetail>((item) {
      return BarcodeDetail.fromJson(item);
    }).toList();

    // for (var item in myDuplicateList!) {
    //   if (!barcodeDetails!.contains(item)) {
    //     barcodeDetails!.add(item);
    //   }
    // }
    //
    if (barcodeDetails != null) {
      for (int i = 0; i < barcodeDetails!.length; i++) {
        xyz.add(barcodeDetails![i].name.toString());
      }
    }
    setState(() {});
    print("myDuplicateList ---- ${myDuplicateList!.length}");
    print("barcodeDetails ---- ${barcodeDetails!.length}");
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
            title: Text(AppLocalizations.of(context)!.taskToday,
                style: TextStyle(
                    color: const Color(0xFF070D17),
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
            leading: IconButton(
              onPressed: () {
                barcodeDetails = [];
                barcodeDetails!.clear();
                setState(() {});
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF5F6979),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.04),
                const Image(
                  image: AssetImage(Images.appIran),
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 12),
                Text(
                  "24 ${AppLocalizations.of(context)!.packagesPickedUp}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.thisIsTheListOfScannedPackage,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF404C5F)),
                ),
                SizedBox(height: Get.height * 0.02),
                (barcodeDetails!.length != 0 || barcodeDetails!.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: barcodeDetails!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Image.asset(Images.completedIcon,
                                          height: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                AppLocalizations.of(context)!
                                                    .packageId,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            (barcodeDetails![index].name !=
                                                        null &&
                                                    barcodeDetails![index]
                                                        .name!
                                                        .isNotEmpty)
                                                ? Text(
                                                    "${barcodeDetails![index].name ?? '-'}",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ))
                                                : Text("-",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                          ],
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                AppLocalizations.of(context)!
                                                    .barcode,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            (barcodeDetails![index]
                                                            .documentBarcode !=
                                                        null &&
                                                    barcodeDetails![index]
                                                        .documentBarcode!
                                                        .isNotEmpty)
                                                ? Text(
                                                    "${barcodeDetails![index].documentBarcode ?? '-'}",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ))
                                                : Text("-",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                          ],
                                        )),
                                  ],
                                ),
                                (barcodeDetails!.length - 1 == index)
                                    ? const SizedBox()
                                    : const Divider(color: Colors.blueGrey)
                              ],
                            );
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.noDataFound,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.095),
              ],
            ),
          ),
          bottomSheet: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: MediaQuery.of(context).size.height * 0.08,
            child: CustomButtons(
              text:
                  "${AppLocalizations.of(context)!.pickUp} ${AppLocalizations.of(context)!.finish}",
              onTap: () {
                commonController
                    .shipmentDeliveryApi(context, barcodeList: xyz)
                    .then(
                      (value) {},
                    )
                    .whenComplete(
                  () {
                    commonController.barcodeDetails = [];
                    commonController.barcodeDetails!.clear();
                  },
                );
              },
              noFillData: false,
            ),
          ),
        ),
      );
    });
  }
}
