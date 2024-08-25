import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/account_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/common_controller.dart';
import '../controller/theme_controller.dart';
import '../repo/accountRepo.dart';
import '../repo/auth_repo.dart';
import '../repo/common_repo.dart';

init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(() => CommonController(commonRepo: Get.find()), fenix: true);
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()),
      fenix: true); //sharedPreferences: Get.find()
  Get.lazyPut(() => AuthController(authRepo: Get.find()),
      fenix: true); //sharedPreferences: Get.find()
  Get.lazyPut(() => AccountController(accountRepo: Get.find()),
      fenix: true); //sharedPreferences: Get.find()

  Get.lazyPut(() => CommonRepo(sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut(() => AuthRepo(), fenix: true);
  Get.lazyPut(() => AccountRepo(sharedPreferences: Get.find()), fenix: true);
}
