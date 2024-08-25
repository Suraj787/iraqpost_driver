import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/api/api_component.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:iraqdriver/helper/shar_pref.dart';
import 'package:iraqdriver/model/login_model.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';

import '../../../helper/route_helper.dart';
import '../../../repo/auth_repo.dart';
import '../../../utils/image.dart';
import '../../Widgets/CustomWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  AuthController controller = Get.put(AuthController(authRepo: AuthRepo()));
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // OEZPS2418f

  User userData = User();

  @override
  void initState() {
    super.initState();
    changeLng();
    getUserData();
  }

  String? language;
  changeLng() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    debugPrint("language --- $language");
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (language.toString() == 'en') {
        setState(() {
          controller.isEng = true;
          controller.isArab = false;
          final provider = Provider.of<LocaleProvider>(context, listen: false);
          provider.setLocale(const Locale('en'));
        });
      } else {
        setState(() {
          controller.isArab = true;
          controller.isEng = false;
          final provider = Provider.of<LocaleProvider>(context, listen: false);
          provider.setLocale(const Locale('ar'));
        });
      }
    });
  }

  getUserData() async {
    String? data = await Shared_Preferences.prefGetString(
        Shared_Preferences.keyUserData, '');
    userData = User.fromJson(jsonDecode(data.toString()));
    setState(() {
      hideLoader();
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Directionality(
        textDirection:
            (authController.isEng) ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: (userData != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Image(
                            image: AssetImage(Images.appIran),
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: -1,
                                            blurRadius: 6,
                                            offset: Offset(0, 4)),
                                      ],
                                      color: Colors.white),
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(Icons.person_outlined)),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.hi}, ${userData.fullName}",
                                    style: const TextStyle(
                                        color: Color(0xFF070D17),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        height: 0.05,
                                        letterSpacing: -0.48),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    "${userData.email}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        height: 0.9,
                                        letterSpacing: -0.32,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF404C5F)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.04),

                          Text(
                            AppLocalizations.of(context)!.myAccount,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5F6979)),
                          ),
                          customBox(AppLocalizations.of(context)!.editProfile,
                              Icons.person_outline, () {
                            Get.toNamed(RouteHelper.getProfileScreen());
                          }, hTag: "profile"),
                          customBox(
                              AppLocalizations.of(context)!.changePassword,
                              Icons.lock_outline_rounded, () {
                            Get.toNamed(RouteHelper.getNewPasswordScreenn());
                          }, hTag: "password"),
                          customBox(
                              AppLocalizations.of(context)!.workInformation,
                              Icons.credit_card, () {
                            Get.toNamed(RouteHelper.getEmployeeScreen());
                          }, hTag: "employee"),

                          SizedBox(height: Get.height * 0.02),
                          Text(
                            AppLocalizations.of(context)!.support,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF5F6979)),
                          ),
                          customBox(AppLocalizations.of(context)!.contactUs,
                              Icons.mail_outline, () {
                            Get.toNamed(RouteHelper.getContactScreen());
                          }, hTag: "needhelp"),
                          // customBox("Live chat",Icons.chat_bubble_outline,(){}),
                          customBox(
                              AppLocalizations.of(context)!
                                  .trainingAndResources,
                              Icons.contact_support_outlined,
                              () {}),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            AppLocalizations.of(context)!.preferences,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF5F6979)),
                          ),
                          // customBox(AppLocalizations.of(context)!.language,Icons.language,(){}),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xff5F6979),
                                    width: 1.3)),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Icon(Icons.language,
                                        color: Theme.of(context).primaryColor)),
                                Expanded(
                                  flex: 9,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      AppLocalizations.of(context)!.language,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 10,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xff5F6979)),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              authController
                                                  .changeToArabic(true);
                                              authController.changeLanguage(
                                                  const Locale('ar'));
                                              final provider =
                                                  Provider.of<LocaleProvider>(
                                                      context,
                                                      listen: false);
                                              provider.setLocale(
                                                  const Locale('ar'));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 3),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: (authController.isArab)
                                                      ? const Color(0xFF234274)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Text(
                                                "عربي",
                                                style: TextStyle(
                                                  color: (authController.isArab)
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              authController
                                                  .changeToEnglish(true);
                                              authController.changeLanguage(
                                                  const Locale('en'));
                                              final provider =
                                                  Provider.of<LocaleProvider>(
                                                      context,
                                                      listen: false);
                                              provider.setLocale(
                                                  const Locale('en'));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: (authController.isEng)
                                                      ? const Color(0xFF234274)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Text(
                                                "English",
                                                style: TextStyle(
                                                  color: (authController.isEng)
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                // Expanded(
                                //   child: Container(
                                //     margin: const EdgeInsets.only(right: 25,top: 15,left: 25),
                                //     padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                                //     decoration: ShapeDecoration(
                                //       shape: RoundedRectangleBorder(
                                //         side: const BorderSide(width: 1, color: Color(0xFF9198A3)),
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //     ),
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       mainAxisAlignment: MainAxisAlignment.start,
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         InkWell(
                                //           onTap: () {
                                //             authController.changeToArabic(true);
                                //             authController.changeLanguage(const Locale('ar'));
                                //             final provider = Provider.of<LocaleProvider>(context, listen: false);
                                //             provider.setLocale(const Locale('ar'));
                                //           },
                                //           child: Container(
                                //             // width: 90,
                                //             // height: 40,
                                //             padding: const EdgeInsets.symmetric(vertical: 8),
                                //             clipBehavior: Clip.antiAlias,
                                //             decoration: ShapeDecoration(
                                //               color: (authController.isArab) ? const Color(0xFF234274) : Colors.transparent,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius: BorderRadius.circular(8)),
                                //             ),
                                //             child: Row(
                                //               mainAxisSize: MainAxisSize.min,
                                //               mainAxisAlignment: MainAxisAlignment.center,
                                //               crossAxisAlignment: CrossAxisAlignment.center,
                                //               children: [
                                //                 Text(
                                //                   'عربي',
                                //                   style: TextStyle(
                                //                     color: (authController.isArab) ? Colors.white: Colors.black,
                                //                     fontSize: 16,
                                //                     fontWeight: FontWeight.w600,
                                //                     height: 0.09,
                                //                     letterSpacing: -0.32,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         InkWell(
                                //           onTap: () {
                                //             authController.changeToEnglish(true);
                                //             authController.changeLanguage(const Locale('en'));
                                //             final provider = Provider.of<LocaleProvider>(context, listen: false);
                                //             provider.setLocale(const Locale('en'));
                                //           },
                                //           child: Container(
                                //             // width: 90,
                                //             // height: 40,
                                //             padding: const EdgeInsets.symmetric(vertical: 8),
                                //             decoration: ShapeDecoration(
                                //               color: (authController.isEng) ? const Color(0xFF234274) : Colors.transparent,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius: BorderRadius.circular(8)),
                                //             ),
                                //             alignment: Alignment.center,
                                //             child: Text(
                                //               'English',
                                //               style: TextStyle(
                                //                 color: (authController.isEng) ? Colors.white: Colors.black,
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.w600,
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Expanded(flex: 1,child: Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                          customBox(
                              AppLocalizations.of(context)!
                                  .notificationPreferences,
                              Icons.notifications_none, () {
                            Get.toNamed(RouteHelper.getNotificationPreScreen());
                          }, hTag: "notifications"),
                          customBox(AppLocalizations.of(context)!.logout,
                              Icons.logout, () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.white,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .wantToLogout,
                                        style: const TextStyle(
                                          color: Color(0xFF264980),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text('${userData.email}',
                                          style: const TextStyle(
                                            color: Color(0xFF264980),
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 32),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Shared_Preferences
                                                    .clearAllPref();
                                                Get.offAllNamed(RouteHelper
                                                    .getLoginScreen());
                                              },
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .yes,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .no,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                          SizedBox(height: Get.height * 0.02),
                        ],
                      ),
                    )
                  : showLoader(),
            ),
          ),
        ),
      );
    });
  }
}
