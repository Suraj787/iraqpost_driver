import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';
import '../../Widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
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
            tag: "password",
            child: Material(
              child: Text(
                AppLocalizations.of(context)!.password,
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.createNewPassword,
                      style: TextStyle(
                          color: const Color(0xFF070D17),
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      AppLocalizations.of(context)!.passwordMustBeDifferent,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF404C5F),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    CustomTextFiled(
                        title: AppLocalizations.of(context)!.oldPassword,
                        hint: AppLocalizations.of(context)!.existingPassword,
                        textController: TextEditingController()),
                    CustomTextFiled(
                        title: AppLocalizations.of(context)!.newPassword,
                        hint: AppLocalizations.of(context)!.createNewPassword,
                        textController: TextEditingController()),
                    CustomTextFiled(
                        title: AppLocalizations.of(context)!.confirmPassword,
                        hint: AppLocalizations.of(context)!
                            .enterYourConfirmPassword,
                        textController: TextEditingController()),
                    SizedBox(height: Get.height * 0.04),
                    CustomButtons(
                      text: AppLocalizations.of(context)!.resetPassword,
                      onTap: () {},
                    ),
                    SizedBox(height: Get.height * 0.01),
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
