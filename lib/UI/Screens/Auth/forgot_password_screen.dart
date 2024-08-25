import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import '../../Widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    return GetBuilder<AuthController>(builder: (authController) {
      bool isCheckEmail =
          authController.forgotEmailControl.text == "abcd@gmail.com";
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: Colors.black38,
            title: Hero(
              tag: "fPass",
              child: Material(
                child: Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: const TextStyle(
                    color: Color(0xFF070D17),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
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
                const Image(
                  image: AssetImage(Images.appIran),
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 26),
                Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: const TextStyle(
                      color: Color(0xFF070D17),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 0.05,
                      letterSpacing: -0.48),
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocalizations.of(context)!.selectPreferredMethod,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 0.9,
                      letterSpacing: -0.32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF404C5F)),
                ),
                SizedBox(height: Get.height * 0.04),
                CustomTextFiled(
                  title: AppLocalizations.of(context)!.email,
                  hint: AppLocalizations.of(context)!.enterYourEmail,
                  textController: authController.forgotEmailControl,
                  preIcon: const Icon(Icons.email_outlined),
                  errorW: isCheckEmail,
                  onChanged: (value) {
                    authController.checkForgotEmail();
                  },
                ),
                isCheckEmail
                    ? Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          Text(
                              "  ${AppLocalizations.of(context)!.emailNotFound}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      )
                    : const SizedBox(),
                const Spacer(),
                Hero(
                  tag: "otpPass",
                  child: Material(
                    child: CustomButtons(
                      text: AppLocalizations.of(context)!.resetPassword,
                      onTap: () {
                        Get.toNamed(RouteHelper.getEnterOtpScreen());
                      },
                      noFillData: authController.isForgotEmpty,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }
}
