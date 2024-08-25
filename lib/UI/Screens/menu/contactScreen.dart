// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api_component.dart';
import '../../../controller/common_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helper/shar_pref.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  CommonController commonController =
      Get.put(CommonController(commonRepo: Get.find()));
  @override
  void initState() {
    super.initState();
    getLanguage();
    getContactData();
  }

  String? language;
  getLanguage() async {
    language = await Shared_Preferences.prefGetString(
        Shared_Preferences.language, 'en');
    setState(() {});
  }

  getContactData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.getContactApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonController>(builder: (controller) {
      return Directionality(
        textDirection:
            (language == 'en') ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            title: Hero(
              tag: "needhelp",
              child: Material(
                child: Text(
                  AppLocalizations.of(context)!.needHelp,
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
          body: (controller.isLoading)
              ? showLoader()
              : (controller.contactDetails == null &&
                      controller.contactDetails.isNull)
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    String call = "tel:966100200300";
                                    if (await canLaunch(call)) {
                                      await launch(call);
                                    } else {
                                      throw 'Could not launch $call';
                                    }
                                  },
                                  child: customsBox(
                                      Icons.call_outlined,
                                      AppLocalizations.of(context)!.callUs,
                                      "966100200300")),
                              InkWell(
                                  onTap: () async {
                                    final Uri params = Uri(
                                        scheme: 'mailto',
                                        path: 'info@iraqpost.com',
                                        queryParameters: {
                                          'subject': 'Subject'
                                        });
                                    String url = params.toString();
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      debugPrint('Could not launch $url');
                                    }
                                  },
                                  child: customsBox(
                                      Icons.email_outlined,
                                      AppLocalizations.of(context)!.emailUs,
                                      "info@iraqpost.com")),
                            ]),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    String call = "tel:966100200300";
                                    if (await canLaunch(call)) {
                                      await launch(call);
                                    } else {
                                      throw 'Could not launch $call';
                                    }
                                  },
                                  child: customsBox(
                                      Icons.call_outlined,
                                      AppLocalizations.of(context)!.callUs,
                                      controller.contactDetails.phone ??
                                          "966100200300")),
                              InkWell(
                                  onTap: () async {
                                    final Uri params = Uri(
                                        scheme: 'mailto',
                                        path: 'info@iraqpost.com',
                                        queryParameters: {
                                          'subject': 'Subject'
                                        });
                                    String url = params.toString();
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      debugPrint('Could not launch $url');
                                    }
                                  },
                                  child: customsBox(
                                      Icons.email_outlined,
                                      AppLocalizations.of(context)!.emailUs,
                                      controller.contactDetails.email ??
                                          "info@iraqpost.com")),
                            ]),
                      ),
                    ),
        ),
      );
    });
  }

  Widget customsBox(IconData iconData, String texts, String text1) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(iconData, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texts,
                  style: const TextStyle(
                      color: Color(0xFF070D17),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  text1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF404C5F),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
