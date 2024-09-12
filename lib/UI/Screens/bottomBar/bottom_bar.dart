import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:internet_popup/internet_popup.dart';
import 'package:iraqdriver/controller/common_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/shar_pref.dart';
import '../../../repo/auth_repo.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with SingleTickerProviderStateMixin {
  AuthController controller = Get.put(AuthController(authRepo: AuthRepo()));
  @override
  void initState() {
    super.initState();
    changeLng();
    Get.find<CommonController>().tabControllerB =
        TabController(vsync: this, length: 4);
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

  @override
  Widget build(BuildContext context) {
    List<String> labelsB = [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.scan,
      AppLocalizations.of(context)!.task,
      AppLocalizations.of(context)!.profile
    ];
    return GetBuilder<CommonController>(builder: (commonController) {
      return WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Directionality(
          textDirection:
              (controller.isEng) ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: commonController.bodyViewB
                  .elementAt(commonController.selectedIndexB),
            ),
            bottomNavigationBar: Container(
              height: 80,
              width: Get.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, spreadRadius: 1, blurRadius: 4),
                  ],
                  color: Colors.white),
              child: TabBar(
                  onTap: (x) {
                    commonController.changeBottomIndex(x);
                  },
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueGrey,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide.none,
                  ),
                  tabs: [
                    for (int i = 0; i < commonController.iconsB.length; i++)
                      _tabItem(
                        commonController.iconsB[i],
                        labelsB[i],
                        isSelected: i == commonController.selectedIndexB,
                      ),
                  ],
                  controller: commonController.tabControllerB),
            ),
          ),
        ),
      );
    });
  }

  Object _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.areYouSure),
          content: Text(AppLocalizations.of(context)!.doYouWantToExitApp),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.no,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.yes,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _tabItem(Widget child, String label, {bool isSelected = false}) {
    return AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffD6E6F2),
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color:
                        isSelected ? const Color(0xff264980) : Colors.black)),
          ],
        ));
  }
}
