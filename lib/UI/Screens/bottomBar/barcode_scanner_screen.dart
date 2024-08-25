import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../utils/image.dart';
import '../../../helper/route_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helper/shar_pref.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final CommonController controller =
      Get.put(CommonController(commonRepo: Get.find()));

  MobileScannerController barcodeController = MobileScannerController();
  String code = '';

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  String? language;
  getLanguage() async {
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
            title: Text(AppLocalizations.of(context)!.scanPackage,
                style: TextStyle(
                    color: Color(0xFF070D17),
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
            leading: IconButton(
              onPressed: () {
                commonController.changeBottomIndex(0);
              },
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF5F6979),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.06),
                    const Image(
                      image: AssetImage(Images.appIran),
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(AppLocalizations.of(context)!.scanPackageFromHub,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF404C5F))),
                    SizedBox(height: Get.height * 0.01),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MobileScanner(
                            allowDuplicates: false,
                            controller: barcodeController,
                            onDetect: (barcode, args) {
                              setState(() {
                                code = barcode.rawValue!;
                                commonController.traceShipmentApi(
                                    code.toString(), context);
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Image.asset(
                              Images.scannerIcon,
                              height: Get.height,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
              (code == '' ||
                      (controller.barcodeDetails == null &&
                          controller.barcodeDetails!.isEmpty))
                  ? const SizedBox()
                  : Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.black45,
                      alignment: Alignment.center,
                      child: Container(
                        width: Get.width * 0.8,
                        height: Get.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Images.passSuccess,
                                  height: Get.width * 0.25,
                                  width: Get.width * 0.25),
                              SizedBox(height: Get.height * 0.02),
                              Text(
                                AppLocalizations.of(context)!.allPackageScanned,
                                style: TextStyle(
                                  color: Color(0xFF264980),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                  AppLocalizations.of(context)!
                                      .youHaveScannedTodayPackage,
                                  style: TextStyle(
                                    color: Color(0xFF264980),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center),
                              SizedBox(height: Get.height * 0.03),
                              SizedBox(
                                height: 45,
                                width: Get.width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      code = "";
                                    });
                                    Get.toNamed(
                                        RouteHelper.getScanPackagesScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff234274),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.continueTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.34,
                                      height: 0.08,
                                      color: Color(0xFFF7FAFF),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.03),
                              SizedBox(
                                height: 45,
                                width: Get.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    code = "";
                                    setState(() {});
                                    // commonController.changeBottomIndex(1);
                                    // Get.back();
                                    // Get.offAllNamed(RouteHelper.getBottomBarScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff234274),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.add,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.34,
                                      height: 0.08,
                                      color: Color(0xFFF7FAFF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
