// ignore_for_file: sort_child_properties_last

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

commonAlertNotification(String title, {String? message}) {
  BotToast.showSimpleNotification(
      title: title,
      subTitle: message,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF1B345B),
      titleStyle: const TextStyle(color: Colors.white),
      closeIcon: const Icon(Icons.close_rounded, color: Colors.white),
  );
}

commonAlertNotificationOnlyTitle(String title) {
  BotToast.showSimpleNotification(
      title: title, backgroundColor: Colors.red.shade500);
}
showLoader() {
  BotToast.showLoading();
}

hideLoader() {
  BotToast.closeAllLoading();
}


void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1B345B),
      textColor: Colors.white,
      fontSize: 12.0);
}
void showLoadingIndicator(BuildContext context, [String? text]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: StatefulBuilder(
          builder: (context, setateSetter) {
            return Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                color: Colors.black87,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: SizedBox(
                              child: CircularProgressIndicator(strokeWidth: 3),
                              width: 32,
                              height: 32)),
                      const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Please wait …',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          )),
                      Text(
                        text.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      )
                    ]));
          },
        ),
      );
    },
  );
}

void hideOpenDialog(BuildContext context) {
  Navigator.of(context).pop();
}

