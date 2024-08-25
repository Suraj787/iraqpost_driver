import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
          title: Hero(
            tag: "employee",
            child: Material(
              child: Text(
                AppLocalizations.of(context)!.employee,
                style: TextStyle(
                  color: const Color(0xFF070D17),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          shadowColor: Colors.black38,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF5F6979),
          ),
        ),
        body: GetBuilder<AuthController>(builder: (authController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)!.workInformation,
                  style: TextStyle(
                      color: const Color(0xFF234274),
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: Get.height * 0.02),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xff709FC1)),
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_copy_outlined),
                        Text(
                          "  ${AppLocalizations.of(context)!.employeeId} : ",
                          style: TextStyle(
                              color: const Color(0xFF234274),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "123456789",
                          style: TextStyle(
                              color: const Color(0xFF234274),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    iconText(Icons.person_outline, "Ahmed Hussain"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Image.asset(Images.driverCardIcon, height: 18),
                          Text(
                            "  ${AppLocalizations.of(context)!.driversLicense} : ",
                            style: TextStyle(
                                color: const Color(0xFF234274),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "123456",
                            style: TextStyle(
                                color: const Color(0xFF234274),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    iconText(Icons.email_outlined, "Ahmed@gmail.com"),
                    iconText(Icons.call_outlined, "465756733"),
                  ],
                ),
              ),
              Spacer(),
              CustomButtons(
                text: AppLocalizations.of(context)!.ok,
                onTap: () {},
                noFillData: false,
              ),
              SizedBox(height: Get.height * 0.01),
            ]),
          );
        }),
      ),
    );
  }

  Widget iconText(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(iconData),
          Text(
            "  $text",
            style: TextStyle(
                color: const Color(0xFF234274),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
