import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/shar_pref.dart';
import '../../Widgets/customBtn.dart';

class LoginErrorScreen extends StatefulWidget {
  const LoginErrorScreen({super.key});

  @override
  State<LoginErrorScreen> createState() => _LoginErrorScreenState();
}

class _LoginErrorScreenState extends State<LoginErrorScreen> {
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
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height / 2.5),
              const Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.redAccent,
              ),
              SizedBox(height: Get.height * 0.05),
              const Text(
                'Login is not successful!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButtons(
                    text: "Okay",
                    onTap: () {
                      Get.back();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
