import 'package:flutter/material.dart';

class OTPBox extends StatefulWidget {
  final Function(bool) onFilled;

  const OTPBox(this.onFilled);

  @override
  OTPBoxState createState() => OTPBoxState();
}

class OTPBoxState extends State<OTPBox> {
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode;
  Color _borderColor = const Color(0xFF9198A3);
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      if (_controller.text.length == 1) {
        FocusScope.of(context).nextFocus();
        _borderColor = const Color(0xFF234274);
        _textColor = const Color(0xFF234274);
      } else {
        _borderColor = const Color(0xFF9198A3);
        _textColor = Colors.black;
      }
      widget.onFilled(_controller.text.length == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: _borderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(color: _textColor),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}