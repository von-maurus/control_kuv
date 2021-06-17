import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class CustomAlertDialog {
  static Future<dynamic> showCustomDialog({
    required String title,
    required Widget content,
    required BuildContext providerContext,
    required List<Widget> actions,
    bool dismissable = false,
    bool legacy = false,
    double elevation = 10.0,
    double fontSize = 18.0,
    double blur = 3.0,
    double borderRadius = 18.0,
  }) async {
    if (legacy) {
      return showDialog(
        context: providerContext,
        builder: (BuildContext _) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            elevation: elevation,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: KuveColors.darkGrey,
            ),
            content: content,
            actions: actions,
          );
        },
      );
    }
    return await NAlertDialog(
      blur: blur,
      dismissable: dismissable,
      dialogStyle: DialogStyle(
        titleDivider: true,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      content: content,
      actions: actions,
    ).show(providerContext);
  }
}
