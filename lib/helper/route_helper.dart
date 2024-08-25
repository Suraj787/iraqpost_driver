import 'package:get/get.dart';
import 'package:iraqdriver/UI/Screens/shipments/arrivingShipmentScreen.dart';
import 'package:iraqdriver/UI/Screens/shipments/assignedPickupScreen.dart';
import 'package:iraqdriver/UI/Screens/task/task_input_location.dart';

import '../UI/Screens/Auth/enter_otp_screen.dart';
import '../UI/Screens/Auth/forgot_password_screen.dart';
import '../UI/Screens/Auth/login_error_screen.dart';
import '../UI/Screens/Auth/login_screen.dart';
import '../UI/Screens/bottomBar/bottom_bar.dart';
import '../UI/Screens/NotificationScreen.dart';
import '../UI/Screens/driverDelivery/TravelScreen.dart';
import '../UI/Screens/driverDelivery/askItIneraryScreen.dart';
import '../UI/Screens/driverDelivery/leavingScreen.dart';
import '../UI/Screens/driverDelivery/pickupScreen.dart';
import '../UI/Screens/driverDelivery/scanPackageScreen.dart';
import '../UI/Screens/driverDelivery/serviceDeliverScreen.dart';
import '../UI/Screens/driverDelivery/takePictureScanScreen.dart';
import '../UI/Screens/home/completedScreen.dart';
import '../UI/Screens/home/pendingScreen.dart';
import '../UI/Screens/menu/ProfileScreen.dart';
import '../UI/Screens/menu/contactScreen.dart';
import '../UI/Screens/menu/employeeScreen.dart';
import '../UI/Screens/menu/newPasswordScreen.dart';
import '../UI/Screens/menu/notificationsScreen.dart';
import '../UI/Screens/splash.dart';
import '../UI/Screens/driverDelivery/taskTodayScreen.dart';
import '../UI/Screens/task/task_barcode_scan_screen.dart';
import '../UI/Screens/task/task_finish_screen.dart';
import '../UI/Screens/task/task_pickup_screen.dart';
import '../UI/Screens/task/task_travel_screen.dart';
import '../UI/Screens/task/task_scanner_screen.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String bottomBarScreen = '/bottomBarScreen';
  static const String loginScreen = '/loginScreen';
  static const String loginErrorScreen = '/loginErrorScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String profileScreen = '/profileScreen';
  static const String newPasswordScreen = '/newPasswordScreen';
  static const String enterOtpScreen = '/enterOtpScreen';
  static const String notificationPreScreen = '/notificationPreScreen';
  static const String contactScreen = '/contactScreen';
  static const String completedScreen = '/completedScreen';
  static const String pendingScreen = '/pendingScreen';
  static const String scanPackagesScreen = '/scanPackagesScreen';
  static const String taskTodayScreen = '/taskTodayScreen';
  static const String taskItineraryScreen = '/taskItineraryScreen';
  static const String travelScreen = '/travelScreen';
  static const String serviceDeliverScreen = '/serviceDeliverScreen';
  static const String leavingScreen = '/leavingScreen';
  static const String pickupScreen = '/pickupScreen';
  static const String takePickupScreen = '/takePickupScreen';
  static const String employeeScreen = '/employeeScreen';
  static const String taskTravelScreen = '/taskTravelScreen';
  static const String taskParkedScreen = '/taskParkedScreen';
  static const String taskScannerScreen = '/taskScannerScreen';
  static const String taskBarcodeScanScreen = '/taskBarcodeScanScreen';
  static const String taskFinishScreen = '/taskFinishScreen';
  static const String assignedPickUpScreen = '/assignedPickUpScreen';
  static const String arrivingShipmentScreen = '/arrivingShipmentScreen';
  static const String inputLocationScreen = '/inputLocationScreen';

  static String getSplashRoute() => splash;
  static String getBottomBarScreen() => bottomBarScreen;
  static String getLoginScreen() => loginScreen;
  static String getLoginErrorScreen() => loginErrorScreen;
  static String getForgotPasswordScreen() => forgotPasswordScreen;
  static String getNotificationScreen() => notificationScreen;
  static String getProfileScreen() => profileScreen;
  static String getNewPasswordScreenn() => newPasswordScreen;
  static String getEnterOtpScreen() => enterOtpScreen;
  static String getNotificationPreScreen() => notificationPreScreen;
  static String getContactScreen() => contactScreen;
  static String getCompletedScreen() => completedScreen;
  static String getPendingScreen() => pendingScreen;
  static String getScanPackagesScreen() => scanPackagesScreen;
  static String getTaskTodayScreen() => taskTodayScreen;
  static String getTaskItineraryScreen() => taskItineraryScreen;
  static String getTravelScreen() => travelScreen;
  static String getServiceDeliverScreen() => serviceDeliverScreen;
  static String getLeavingScreen() => leavingScreen;
  static String getPickupScreen() => pickupScreen;
  static String getTakePickupScreen() => takePickupScreen;
  static String getEmployeeScreen() => employeeScreen;
  static String getTaskTravelScreen() => taskTravelScreen;
  static String getTaskParkedScreen() => taskParkedScreen;
  static String getTaskScannerScreen() => taskScannerScreen;
  static String getTaskBarcodeScanScreen() => taskBarcodeScanScreen;
  static String getTaskFinishScreen() => taskFinishScreen;
  static String getAssignedPickUpScreenScreen() => assignedPickUpScreen;
  static String getArrivingShipmentScreenScreen() => arrivingShipmentScreen;
  static String getInputLocationScreen() => inputLocationScreen;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const Splash()),
    GetPage(name: bottomBarScreen, page: () => const BottomBarScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: loginErrorScreen, page: () => const LoginErrorScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: newPasswordScreen, page: () => const NewPasswordScreen()),
    GetPage(name: enterOtpScreen, page: () => const EnterOtpScreen()),
    GetPage(
        name: notificationPreScreen, page: () => const NotificationPreScreen()),
    GetPage(name: contactScreen, page: () => const ContactScreen()),
    GetPage(name: completedScreen, page: () => const CompletedScreen()),
    GetPage(name: pendingScreen, page: () => const PendingScreen()),
    GetPage(name: scanPackagesScreen, page: () => const ScanPackagesScreen()),
    GetPage(name: taskTodayScreen, page: () => const TaskTodayScreen()),
    GetPage(name: taskItineraryScreen, page: () => const TaskItineraryScreen()),
    GetPage(name: travelScreen, page: () => const TravelScreen()),
    GetPage(
        name: serviceDeliverScreen, page: () => const ServiceDeliverScreen()),
    GetPage(name: leavingScreen, page: () => const LeavingScreen()),
    GetPage(name: pickupScreen, page: () => const PickupScreen()),
    GetPage(name: takePickupScreen, page: () => const TakePickupScreen()),
    GetPage(name: employeeScreen, page: () => const EmployeeScreen()),
    GetPage(name: taskTravelScreen, page: () => const TaskTravelScreen()),
    GetPage(name: taskParkedScreen, page: () => const TaskParkedScreen()),
    GetPage(name: taskScannerScreen, page: () => const TaskScannerScreen()),
    GetPage(
        name: taskBarcodeScanScreen, page: () => const TaskBarcodeScanScreen()),
    GetPage(name: taskFinishScreen, page: () => const TaskFinishScreen()),
    GetPage(
        name: assignedPickUpScreen, page: () => const AssignedPickupScreen()),
    GetPage(
        name: arrivingShipmentScreen,
        page: () => const ArrivingShipmentScreen()),
    GetPage(
        name: inputLocationScreen, page: () => const TaskInputLocationScreen()),
  ];
}
