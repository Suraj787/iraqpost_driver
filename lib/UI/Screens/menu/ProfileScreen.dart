import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:iraqdriver/model/login_model.dart';
import '../../../controller/auth_controller.dart';
import '../../../api/api_component.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import '../../Widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User userData = User();

  @override
  void initState() {
    super.initState();
    getLanguage();
    getUserData();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: Hero(
            tag: "profile",
            child: Material(
              child: Text(
                AppLocalizations.of(context)!.profile,
                style: const TextStyle(
                  color: Color(0xFF070D17),
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
          return SingleChildScrollView(
            child: (userData != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.editProfile,
                            style: const TextStyle(
                                color: Color(0xFF070D17),
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.hi}, ${userData.fullName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF404C5F),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.firstName,
                              hint: AppLocalizations.of(context)!
                                  .enterYourFirstName,
                              textController: TextEditingController()),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.lastName,
                              hint: AppLocalizations.of(context)!
                                  .enterYourLastName,
                              textController: TextEditingController()),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.email,
                              hint:
                                  AppLocalizations.of(context)!.enterYourEmail,
                              textController: TextEditingController()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.phoneNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xff0B1627),
                                  fontSize: 14,
                                  height: 0.09,
                                  letterSpacing: -0.32,
                                ),
                              ),
                              const Text(
                                ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  height: 0.09,
                                  letterSpacing: -0.32,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          InternationalPhoneNumberInput(
                            height: 50,
                            inputFormatters: const [],
                            formatter: MaskedInputFormatter('### ### ## ##'),
                            initCountry: CountryCodeModel(
                                name: "United States",
                                dial_code: "+1",
                                code: "US"),
                            betweenPadding: 23,
                            dialogConfig: DialogConfig(
                              backgroundColor: const Color(0xFF444448),
                              searchBoxBackgroundColor: const Color(0xFF56565a),
                              searchBoxIconColor: const Color(0xFFFAFAFA),
                              countryItemHeight: 55,
                              topBarColor: const Color(0xFF1B1C24),
                              selectedItemColor: const Color(0xFF56565a),
                              selectedIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Image.asset(
                                  "assets/check.png",
                                  width: 20,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              textStyle: TextStyle(
                                  color:
                                      const Color(0xFFFAFAFA).withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              searchBoxTextStyle: TextStyle(
                                  color:
                                      const Color(0xFFFAFAFA).withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              titleStyle: const TextStyle(
                                  color: Color(0xFFFAFAFA),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                              searchBoxHintStyle: TextStyle(
                                  color:
                                      const Color(0xFFFAFAFA).withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            countryConfig: CountryConfig(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: const Color(0xFF3f4046)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                noFlag: false,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            phoneConfig: PhoneConfig(
                              radius: 8,
                              hintText:
                                  AppLocalizations.of(context)!.phoneNumber,
                              borderWidth: 1,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.nationalID,
                              hint: AppLocalizations.of(context)!
                                  .enterYourNationalID,
                              textController: TextEditingController()),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.nationality,
                              hint: AppLocalizations.of(context)!
                                  .enterYourNationality,
                              textController: TextEditingController()),
                          CustomTextFiled(
                              title: AppLocalizations.of(context)!.gender,
                              hint:
                                  AppLocalizations.of(context)!.enterYourGender,
                              textController: TextEditingController()),
                          CustomTextFiled(
                            title: AppLocalizations.of(context)!.dob,
                            hint: "eg: MM/DD/YYYY",
                            textController: TextEditingController(),
                            sufIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_today_rounded)),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          CustomButtons(
                            text: AppLocalizations.of(context)!.update,
                            onTap: () {},
                          ),
                          SizedBox(height: Get.height * 0.03),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.deleteAccount,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.red,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ]),
                  )
                : showLoader(),
          );
        }),
      ),
    );
  }
}
