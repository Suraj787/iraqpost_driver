import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqdriver/controller/auth_controller.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:iraqdriver/helper/shar_pref.dart';
import 'package:iraqdriver/repo/tracking_repo.dart';
import 'package:provider/provider.dart';

import '../../helper/route_helper.dart';
import '../../repo/auth_repo.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AuthController controller = Get.put(AuthController(authRepo: AuthRepo()));
  @override
  void initState() {
    super.initState();
    changeLng();
    Timer(const Duration(seconds: 2), () {
      setNav();
    });
  }

  setNav() async {
    String? apiToken =
        await Shared_Preferences.prefGetString(Shared_Preferences.keyToken, '');
    if (apiToken!.isEmpty) {
      Get.offNamed(RouteHelper.getLoginScreen());
    } else {
      Get.offAllNamed(RouteHelper.getBottomBarScreen());
    }
  }

  String? language;
  changeLng() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('assets/IraqHome2.png'),
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30,
            ), // Add some space between the image and text
            Text(
              "POWERED BY AL BANAN",
              style: TextStyle(
                color: Color(0xFFFFB500),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 0.09,
                letterSpacing: -0.32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
