import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Size size;
  final Color borderColor;
  final Color buttonColor;
  final String buttonText;
  final Function()? onPressed;
  final Color buttonTextColor;
  final double height;
  final double textFontSize;

  const RoundedButton({
    required this.size,
    required this.onPressed,
    this.borderColor = const Color(0x002130f3),
    this.buttonColor = const Color(0xFF1565C0),
    this.buttonText = 'TextButton',
    this.buttonTextColor = const Color(0xFFFFFFFF),
    this.height = 55.0,
    this.textFontSize = 18.5,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(3.5),
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all(
          StadiumBorder(side: BorderSide(color: borderColor)),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(color: buttonTextColor, fontSize: textFontSize),
        )),
      ),
    );
  }
}
