import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import 'custom_alert_dialog.dart';

class CustomNumberPicker extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onChangeInputCantidad;
  final Function onChangeNumberSelector;
  final TextStyle labelTextStyle;
  final int minValue;
  final int maxValue;
  final int initialValue;
  final dynamic bloc;
  final BuildContext providerContext;
  final TextInputAction textInputAction;
  final TextStyle style;
  final TextStyle actionsTextStyle;

  const CustomNumberPicker({
    required this.textEditingController,
    required this.focusNode,
    required this.onChangeInputCantidad,
    required this.onChangeNumberSelector,
    required this.label,
    required this.hint,
    this.labelTextStyle = const TextStyle(fontSize: 20.5),
    this.minValue = 0,
    this.maxValue = 2,
    this.initialValue = 1,
    this.bloc,
    required this.providerContext,
    this.textInputAction = TextInputAction.done,
    this.style = const TextStyle(fontSize: 16.0),
    required this.actionsTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: TextFormField(
            textAlign: TextAlign.start,
            controller: textEditingController,
            textInputAction: textInputAction,
            style: style,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: focusNode,
            onChanged: onChangeInputCantidad,
            keyboardType: TextInputType.number,
            validator: numberValidator,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: labelTextStyle,
              hintText: hint,
              errorStyle: TextStyle(fontSize: 11.0),
              fillColor: Colors.white,
              prefixIcon: Icon(FontAwesomeIcons.boxes, size: 28.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              //fillColor: Colors.green
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _NumericTextFormatter(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.listOl),
              onPressed: () async {
                if (bloc.auxCantidad > maxValue) {
                  onChangeNumberSelector(maxValue);
                  textEditingController.text = maxValue.toString();
                }
                focusNode.unfocus();
                await CustomAlertDialog.showCustomDialog(
                  legacy: true,
                  title: 'Seleccione una cantidad',
                  providerContext: providerContext,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: bloc,
                        builder: (_, __) {
                          return NumberPicker(
                            minValue: minValue,
                            value: bloc.auxCantidad,
                            // initialValue: bloc.auxCantidad,
                            // highlightSelectedValue: true,
                            maxValue: maxValue,
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: KuveColors.kuveVerdeLessOp,
                              fontSize: 20,
                            ),
                            // listViewWidth:
                            //     MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: KuveColors.kuveVerdeLessOp,
                                width: 2.5,
                              ),
                            ),
                            onChanged: (value) {
                              onChangeNumberSelector(value);
                            },
                          );
                        },
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        onChangeNumberSelector(bloc.auxCantidad);
                        textEditingController.text =
                            bloc.auxCantidad.toString();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Aceptar',
                        style: actionsTextStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancelar',
                        style: actionsTextStyle,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String? numberValidator(String? value) {
    var pattern = RegExp('[0-9]');
    print(num);
    print(minValue);
    print(maxValue);
    if (!pattern.hasMatch(value!)) {
      return 'Ingrese una cantidad';
    } else {
      var num = int.parse(value.replaceAll(',', ''));
      if (num < minValue) {
        return 'La cantidad ingresada es inferior al mínimo';
      } else if (num > maxValue) {
        return 'La cantidad ingresada es superior al máximo';
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
