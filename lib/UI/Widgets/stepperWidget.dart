import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StepperButton extends StatelessWidget {

  final String date;
  final String title;
  final String subTile;
  final bool check;

  const StepperButton({super.key, required this.date, required this.title, required this.subTile, required this.check});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(date, style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),textAlign: TextAlign.right,),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Container(
                height: 25,width: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: check ? Colors.green : Theme.of(context).primaryColor
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check,color: Colors.white,),
              ),
              Container(
                constraints: BoxConstraints(
                    maxHeight: 80,
                    minHeight: 50
                ),
                width: 1,
                color: Colors.black,
              )
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              )),
              SizedBox(height: Get.height*0.01),
              Text(subTile, style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              )),
              SizedBox(height: Get.height*0.02),
            ],
          ),
        )
      ],
    );
  }
}
