import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogPage extends StatelessWidget {
  final BuildContext oldContext;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const AlertDialogPage({
    required this.oldContext,
    required this.content,
    required this.actions,
    this.title = const Center(child: Text('Aviso')),
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    } else {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        title: title,
        content: content,
        actions: actions,
      );
    }
  }
}
