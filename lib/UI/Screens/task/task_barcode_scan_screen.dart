import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../utils/image.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskBarcodeScanScreen extends StatefulWidget {
  const TaskBarcodeScanScreen({super.key});

  @override
  State<TaskBarcodeScanScreen> createState() => _TaskBarcodeScanScreenState();
}

class _TaskBarcodeScanScreenState extends State<TaskBarcodeScanScreen> {
  MobileScannerController barcodeController = MobileScannerController();
  String code = "";

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.takePicture,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF404C5F)),
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                AppLocalizations.of(context)!.captureThePackage,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF404C5F)),
              ),
              SizedBox(height: Get.height * 0.02),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: barcodeController,
                      onDetect: (barcode) {
                        setState(() {
                          code = barcode.barcodes.first.rawValue!;
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
              CustomButtons(
                text: AppLocalizations.of(context)!.continueTitle,
                onTap: () {
                  setState(() {
                    code = "";
                  });
                  Get.toNamed(RouteHelper.getTaskFinishScreen());
                },
                noFillData: code == "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
