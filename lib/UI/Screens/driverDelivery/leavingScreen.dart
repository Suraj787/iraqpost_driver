import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/image.dart';
import '../../../controller/account_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeavingScreen extends StatefulWidget {
  const LeavingScreen({super.key});

  @override
  State<LeavingScreen> createState() => _LeavingScreenState();
}

class _LeavingScreenState extends State<LeavingScreen> {
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
    return GetBuilder<AccountController>(builder: (accountController) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.leavingPackage,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  InkWell(
                      onTap: () {
                        accountController.concernedCheck();
                      },
                      child: checkBox(context, accountController.isConcerned,
                          AppLocalizations.of(context)!.concernedPerson)),
                  SizedBox(height: 6),
                  InkWell(
                      onTap: () {
                        accountController.frontCheck();
                      },
                      child: checkBox(context, accountController.isFront,
                          AppLocalizations.of(context)!.frontDoor)),
                  SizedBox(height: Get.height * 0.04),
                  CustomButtons(
                    text: AppLocalizations.of(context)!.continueTitle,
                    onTap: () {
                      Get.toNamed(RouteHelper.getTakePickupScreen());
                    },
                    noFillData: !(accountController.isConcerned &&
                        accountController.isFront),
                  ),
                  SizedBox(height: Get.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget checkBox(BuildContext context, bool check, String texts) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: check == true
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: 1.5)),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: check == true
                ? Image.asset(
                    Images.checkIcon,
                    height: 10,
                  )
                : SizedBox(
                    height: 10,
                    width: 13,
                  ),
            // child: check == true ? Icon(Icons.check_rounded,size: 18,color: Theme.of(context).primaryColor,) : SizedBox(),
          ),
          SizedBox(
            width: 12,
          ),
          Text(texts,
              style: TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
