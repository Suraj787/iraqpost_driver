import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final bool? noFillData;
  const CustomButtons(
      {super.key,
      required this.text,
      required this.onTap,
      this.noFillData = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: noFillData == true
                ? const Color(0xffE9EDF2)
                : const Color(0xff234274),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: TextStyle(
            color: noFillData == true ? const Color(0xff234274) : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
