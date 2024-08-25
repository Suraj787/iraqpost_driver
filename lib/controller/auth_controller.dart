import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/helper/route_helper.dart';
import 'package:iraqdriver/helper/shar_pref.dart';

import '../api/api_component.dart';
import '../model/login_model.dart';
import '../repo/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();

  bool isLoginEmpty = true;
  checkLoginEmail() {
    isLoginEmpty = emailLoginController.text.isEmpty ||
        passwordLoginController.text.isEmpty;
    update();
  }

  bool isLoginPassHide = true;
  changeLoginPass() {
    isLoginPassHide = !isLoginPassHide;
    update();
  }

  final forgotEmailControl = TextEditingController();
  bool isForgotEmpty = true;
  checkForgotEmail() {
    isForgotEmpty = forgotEmailControl.text.isEmpty;
    update();
  }

  bool isRemember = false;
  rememberCheck(bool value) {
    isRemember = value;
    update();
  }

  bool allOTPFilled = false;
  setAllOTPFilled(bool filled) {
    allOTPFilled = filled;
    update();
  }

  //***************************************** Language *****************************************
  bool isEng = true;
  bool isArab = false;
  changeToEnglish(bool value) {
    isEng = value;
    isArab = false;
    update();
  }

  changeToArabic(bool value) {
    isArab = value;
    isEng = false;
    update();
  }

  String? language = "English";
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;
  void changeLanguage(Locale localeLang) {
    if (localeLang == const Locale('en')) {
      _appLocale = localeLang;
      update();
      Shared_Preferences.prefSetString(Shared_Preferences.language, 'en');
    } else {
      _appLocale = localeLang;
      update();
      Shared_Preferences.prefSetString(Shared_Preferences.language, 'ar');
    }
    update();
  }
  //***************************************** Language *****************************************

  int secondsRemaining = 120;
  late Timer timerOTP;
  void startTimer() {
    secondsRemaining = 120;
    timerOTP = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
      update();
    });
  }

  void restartTimer() {
    secondsRemaining = 120;
    update();
    timerOTP.cancel();
    startTimer();
  }

  User loginUserData = User();
  Future<void> loginApi(
      String email, String password, BuildContext context) async {
    showLoader();
    await AuthRepo().loginRep(email, password).then((value) async {
      if (value != null) {
        loginUserData = value.user!;
        // Shared_Preferences.prefSetString(Shared_Preferences.keyToken, value.token.toString());
        Shared_Preferences.prefSetString(
            Shared_Preferences.keyUserData, jsonEncode(value.user).toString());
        Shared_Preferences.prefSetString(Shared_Preferences.keyToken,
            utf8.decode(base64.decode(value.token.toString())));
        String? apiToken = await Shared_Preferences.prefGetString(
            Shared_Preferences.keyToken, '');
        print("Driver Token --------> $apiToken");
        showToast(value.message.toString());
        hideLoader();
        update();
        Get.offAllNamed(RouteHelper.getBottomBarScreen());
      } else {
        showToast(value!.message.toString());
      }
    }).catchError((e) {
      hideLoader();
      debugPrint('catchError ---> ${e.toString()}');
    }).whenComplete(() {
      hideLoader();
    });
  }
}
