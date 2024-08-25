import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helper/shar_pref.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(Shared_Preferences.language,'en');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black38,
          title: Text(AppLocalizations.of(context)!.notifications,style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF404C5F))),
          leading:  IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF5F6979),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xff709FC1))
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFF070D17),),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.youDontHaveNotificationYet,style: const TextStyle(
                          color: Color(0xFF070D17),
                          fontWeight: FontWeight.w700,),
                      ),
                      Text(AppLocalizations.of(context)!.whenYouHaveNotificationMsg,style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF404C5F)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
