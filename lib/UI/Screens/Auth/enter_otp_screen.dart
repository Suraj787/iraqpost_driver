import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import '../../Widgets/dilog_box.dart';
import '../../Widgets/otpWidget.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  @override
  void initState() {
    super.initState();
    var authoController = Get.find<AuthController>();
    authoController.startTimer();
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
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: Colors.black38,
            title: Hero(
              tag: "otpPass",
              child: Material(
                child: Text(
                  AppLocalizations.of(context)!.otp,
                  style: const TextStyle(
                    color: Color(0xFF070D17),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
          body: SingleChildScrollView(
            child: Padding(
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
                    AppLocalizations.of(context)!.enterOtpCode,
                    style: const TextStyle(
                        color: Color(0xFF070D17),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 0.05,
                        letterSpacing: -0.48),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "${AppLocalizations.of(context)!.otpCodeSentTo} ${authController.forgotEmailControl.text}",
                    style: const TextStyle(
                        fontSize: 16,
                        height: 0.9,
                        letterSpacing: -0.32,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF404C5F)),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: OTPBox(authController.setAllOTPFilled)),
                      Expanded(child: OTPBox(authController.setAllOTPFilled)),
                      Expanded(child: OTPBox(authController.setAllOTPFilled)),
                      Expanded(child: OTPBox(authController.setAllOTPFilled)),
                      Expanded(child: OTPBox(authController.setAllOTPFilled)),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Container(
                    width: 353,
                    height: 90,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE9EDF2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '00:${(authController.secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(authController.secondsRemaining % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Color(0xFF5F6979),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0.10,
                            letterSpacing: -0.28,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        InkWell(
                          onTap: () {
                            authController.restartTimer();
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .resendTheVerificationEmail,
                            style: const TextStyle(
                              color: Color(0xFF264980),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.2),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        authController.restartTimer();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.continueToEmailApp,
                        style: const TextStyle(
                          color: Color(0xFF264980),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  CustomButtons(
                    onTap: authController.allOTPFilled
                        ? () {
                            passwordSuccess(context, () {
                              Get.offAllNamed(RouteHelper.getLoginScreen());
                            });
                          }
                        : () {},
                    text: AppLocalizations.of(context)!.verify,
                    noFillData: !authController.allOTPFilled,
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
