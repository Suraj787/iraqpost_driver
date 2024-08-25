import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/image.dart';

passwordSuccess(BuildContext context, Function function) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFFF8FAFF),
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Images.passSuccess,
                height: 70,
                width: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password update successfully',
                style: TextStyle(
                  color: Color(0xFF264980),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your password has been updated successfully',
                style: TextStyle(
                  color: Color(0xFF264980),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 45,
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    function();
                    // Get.offAllNamed(RouteHelper.getLoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff234274),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.34,
                      height: 0.08,
                      color: Color(0xFFF7FAFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

paymentComplete(BuildContext context, Function function) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFFF8FAFF),
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Images.passSuccess,
                height: 70,
                width: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment completed successfully',
                style: TextStyle(
                  color: Color(0xFF264980),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Payment has been successfully made',
                style: TextStyle(
                  color: Color(0xFF264980),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 45,
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    function();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff234274),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.34,
                      height: 0.08,
                      color: Color(0xFFF7FAFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
