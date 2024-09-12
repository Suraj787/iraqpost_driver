import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:internet_popup/up.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../helper/shar_pref.dart';
import '../../../utils/image.dart';
import '../../Widgets/customBtn.dart';
import '../../Widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     InternetPopup().initialize(context: context);
    //   }
    // });
    getLanguage();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    var authController = Get.find<AuthController>();
    authController.emailLoginController.text = "";
    authController.passwordLoginController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Form(
                  key: formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: const AssetImage(Images.iraqHome2),
                        width: Get.width,
                        height: 190,
                      ),
                      const SizedBox(height: 26),
                      Text(
                        AppLocalizations.of(context)!.login,
                        style: const TextStyle(
                            color: Color(0xFF070D17),
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        AppLocalizations.of(context)!.welcomeToIraqPost,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF404C5F),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.04),
                      CustomTextFiled(
                          textController: authController.emailLoginController,
                          hint: AppLocalizations.of(context)!.enterYourEmail,
                          title: AppLocalizations.of(context)!.email,
                          preIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .enterYourEmail;
                            }
                            if (!RegExp(
                                    r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                                .hasMatch(value)) {
                              return 'Please enter a valid Email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            authController.checkLoginEmail();
                          }),
                      CustomTextFiled(
                        textController: authController.passwordLoginController,
                        hint: AppLocalizations.of(context)!.enterYourPassword,
                        title: AppLocalizations.of(context)!.password,
                        sufIcon: IconButton(
                            onPressed: () {
                              authController.changeLoginPass();
                            },
                            icon: Icon(authController.isLoginPassHide
                                ? Icons.visibility_off_outlined
                                : Icons.visibility)),
                        obscureText: authController.isLoginPassHide,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enterYourPassword;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          authController.checkLoginEmail();
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: Checkbox(
                              value: authController.isRemember,
                              onChanged: (value) {
                                authController.rememberCheck(value!);
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.rememberMe,
                            style: const TextStyle(
                              color: Color(0xff070D17),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                  RouteHelper.getForgotPasswordScreen());
                            },
                            child: Hero(
                              tag: 'fPass',
                              child: Material(
                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff0B1627),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.2),
                      CustomButtons(
                        text: AppLocalizations.of(context)!.login,
                        onTap: () {
                          if (formKey2.currentState!.validate()) {
                            authController.loginApi(
                                authController.emailLoginController.text
                                    .trim()
                                    .toString(),
                                authController.passwordLoginController.text
                                    .trim()
                                    .toString(),
                                context);
                            formKey2.currentState!.validate();
                          }
                        },
                        noFillData: authController.isLoginEmpty,
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
