import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomNumberInput extends StatelessWidget {
  const CustomNumberInput({
    required this.textEditingController,
    required this.textInputAction,
    required this.style,
    required this.focusNode,
    required this.onChangeInputCantidad,
    required this.minValue,
    required this.maxValue,
    required this.label,
    required this.hint,
    required this.labelTextStyle,
    required this.bloc,
  });

  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final TextStyle style;
  final FocusNode focusNode;
  final Function(String)? onChangeInputCantidad;
  final int minValue;
  final int maxValue;
  final String label;
  final String hint;
  final TextStyle labelTextStyle;
  final dynamic bloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.start,
      controller: textEditingController,
      textInputAction: textInputAction,
      style: style,
      enableSuggestions: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      onChanged: onChangeInputCantidad,
      keyboardType: TextInputType.number,
      validator: numberValidator,
      maxLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _NumericTextFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelTextStyle,
        hintText: hint,
        errorStyle: TextStyle(fontSize: 10.0),
        fillColor: Colors.white,
        prefixIcon: Icon(FontAwesomeIcons.boxes, size: 28.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  String? numberValidator(String? value) {
    var pattern = RegExp('[0-9]');
    print('Valor Ingresado: $value');
    if (!pattern.hasMatch(value!)) {
      return 'Ingrese una cantidad';
    } else {
      var num = int.parse(value.replaceAll(',', ''));
      if (num < minValue || num > maxValue) {
        return 'La cantidad ingresada no es válida, intentelo nuevamente';
      }
    }
    return null;
  }
}

class _NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat('#,###');
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
