import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'constants/constant_apis.dart';
import 'controller/common_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/get_di.dart' as di;
import 'helper/route_helper.dart';
import 'theme/dark.dart';
import 'theme/light.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FMTCObjectBoxBackend().initialise();

  await const FMTCStore('mapStore').manage.create();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return GetBuilder<ThemeController>(builder: (themeController) {
      return ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
          builder: (context, state) {
            final provider = Provider.of<LocaleProvider>(context);
            return GetMaterialApp(
              builder: (context, child) {
                child = botToastBuilder(context, child);
                return child;
              },
              localizationsDelegates: const [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('ar'), // Spanish
              ],
              locale: provider.locale,
              navigatorObservers: [BotToastNavigatorObserver()],
              title: AppConstants.APP_NAME,
              theme: themeController.darkTheme ? dark : light,
              debugShowCheckedModeBanner: false,
              scrollBehavior: const MaterialScrollBehavior(),
              initialRoute: RouteHelper.getSplashRoute(),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.rightToLeft,
              transitionDuration: const Duration(milliseconds: 500),
            );
          });
      // return GetMaterialApp(
      //   builder: (context, child) {
      //     child = botToastBuilder(context, child);
      //     return child;
      //   },
      //   localizationsDelegates: const [
      //     AppLocalizations.delegate, // Add this line
      //     GlobalMaterialLocalizations.delegate,
      //     GlobalWidgetsLocalizations.delegate,
      //     GlobalCupertinoLocalizations.delegate
      //   ],
      //   supportedLocales: const [
      //     Locale('en'), // English
      //     Locale('ar'), // Spanish
      //   ],
      //   navigatorObservers: [BotToastNavigatorObserver()],
      //   title: AppConstants.APP_NAME,
      //   theme: themeController.darkTheme ? dark : light,
      //   debugShowCheckedModeBanner: false,
      //   scrollBehavior: const MaterialScrollBehavior(),
      //   initialRoute: RouteHelper.getSplashRoute(),
      //   getPages: RouteHelper.routes,
      //   defaultTransition: Transition.rightToLeft,
      //   transitionDuration: const Duration(milliseconds: 500),
      // );
    });
  }
}
