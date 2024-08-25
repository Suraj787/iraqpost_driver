import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFiled extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController textController;
  final Widget? preIcon;
  final Widget? sufIcon;
  final bool? errorW;
  final bool? starRemove;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  const CustomTextFiled(
      {super.key,
      required this.title,
      required this.hint,
      required this.textController,
      this.preIcon,
      this.sufIcon,
      this.starRemove,
      this.onChanged,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText,
      this.errorW,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: errorW == true ? 0 : 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFF0B1627),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0.10,
                    letterSpacing: -0.28),
              ),
              starRemove == true
                  ? const SizedBox()
                  : const Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        height: 0.09,
                        letterSpacing: -0.32,
                      ),
                    ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: errorW == true ? 6 : 10),
            child: TextFormField(
              obscureText: obscureText ?? false,
              validator: validator,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              controller: textController,
              style: const TextStyle(
                  color: Color(0xFF234274),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.32),
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: preIcon,
                suffixIcon: sufIcon,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: errorW == true
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: errorW == true ? Colors.red : Colors.grey,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: errorW == true ? Colors.red : Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: errorW == true ? Colors.red : Colors.grey,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
