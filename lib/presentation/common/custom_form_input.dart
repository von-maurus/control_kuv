import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {
  final Size size;
  final Icon prefixIcon;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isObscure;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final Function(String) function;
  final AutovalidateMode autoValidateMode;
  final Widget? suffixWidget;
  final TextStyle? hintStyle;
  final double top;
  final double left;
  final double bottom;
  final double right;
  final TextStyle? textFormStyle;
  final Color backgroundColor;

  const CustomFormInput({
    required this.size,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.focusNode,
    this.textInputType = TextInputType.text,
    this.errorText,
    this.isObscure = false,
    required this.validator,
    required this.textInputAction,
    required this.function,
    required this.autoValidateMode,
    this.suffixWidget,
    this.hintStyle,
    required this.right,
    required this.bottom,
    required this.left,
    required this.top,
    this.textFormStyle,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).orientation == Orientation.landscape
              ? size.height * 0.045
              : size.height * 0.022),
      padding: EdgeInsets.only(
        top: top,
        left: left,
        bottom: bottom,
        right: right,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, 5),
            blurRadius: 6.5,
          )
        ],
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        style: textFormStyle,
        autovalidateMode: autoValidateMode,
        textInputAction: textInputAction,
        onFieldSubmitted: function,
        validator: validator,
        focusNode: focusNode,
        obscureText: isObscure,
        controller: controller,
        autocorrect: false,
        keyboardType: textInputType,
        onEditingComplete: () {
          return print(controller.value.text);
        },
        decoration: InputDecoration(
          prefixText: '\t\t',
          suffixIcon: suffixWidget,
          disabledBorder: InputBorder.none,
          errorText: errorText,
          hintText: hintText,
          hintStyle: hintStyle,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: prefixIcon,
          errorStyle: TextStyle(
            fontSize: 16.5,
            height: 0.4,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 18),
        ),
      ),
    );
  }
}
