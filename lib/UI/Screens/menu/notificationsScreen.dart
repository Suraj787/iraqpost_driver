import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/common_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../Widgets/customSwithBtn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPreScreen extends StatefulWidget {
  const NotificationPreScreen({super.key});

  @override
  _NotificationPreScreenState createState() => _NotificationPreScreenState();
}

class _NotificationPreScreenState extends State<NotificationPreScreen> {
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
            tag: "notifications",
            child: Material(
              child: Text(
                AppLocalizations.of(context)!.notifications,
                style: TextStyle(
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
        body: GetBuilder<CommonController>(builder: (commonController) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notificationPreferences,
                      style: TextStyle(
                          color: Color(0xFF070D17),
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .chooseMethodToNotifyOurService,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF404C5F),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    selectBox(
                        AppLocalizations.of(context)!.email,
                        AppLocalizations.of(context)!.viaEmail,
                        commonController.isNpEmail,
                        commonController.changeNpEmail),
                    selectBox(
                        AppLocalizations.of(context)!.sms,
                        AppLocalizations.of(context)!.viaSms,
                        commonController.isNpSMS,
                        commonController.changeNpSMS),
                    selectBox(
                        AppLocalizations.of(context)!.pushNotification,
                        AppLocalizations.of(context)!.viaApp,
                        commonController.isNpPushN,
                        commonController.changeNpPushN),
                    selectBox(
                        AppLocalizations.of(context)!.whatsApp,
                        AppLocalizations.of(context)!.viaWhatsApp,
                        commonController.isNpWhats,
                        commonController.changeNpWhats),
                  ]),
            ),
          );
        }),
      ),
    );
  }

  Widget selectBox(
      String title, String sunTile, bool select, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          color: Colors.white),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF070D17),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  sunTile,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF404C5F),
                  ),
                ),
              ],
            ),
          ),
          CustomSwitch(
            value: select,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
