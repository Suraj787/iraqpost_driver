import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customBox(String text,IconData iconsData, GestureTapCallback callback, {String? hTag}){
  BuildContext context = Get.context as BuildContext;

  return InkWell(
    onTap: callback,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: const Color(0xff5F6979),
              width: 1.3
          )
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1,child: Icon(iconsData, color: Theme.of(context).primaryColor)),
          Expanded(flex: 8, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: hTag != null ? Hero(
              tag: hTag,
              child: Material(
                child: Text(text,style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor),
                ),
              ),
            ) : Text(text,style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor),
            ),
          ),),
          Expanded(flex: 1,child: Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).primaryColor)),
        ],
      ),
    ),
  );
  
}
