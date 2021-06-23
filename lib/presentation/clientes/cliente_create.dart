import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/presentation/clientes/clientes_bloc.dart';
import 'package:control_kuv/presentation/clientes/create_custom_form.dart';

class ClientCreate extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registre a su cliente'),
        leading: IconButton(
          icon: Platform.isAndroid
              ? Icon(
                  Icons.arrow_back,
                  size: 30.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Colors.white,
                ),
          onPressed: () async {
            clientsBloc.clearFields();
            FocusScope.of(context).unfocus();
            await Future.delayed(Duration(milliseconds: 100));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: CustomForm(
        scaffoldKey: _scaffoldKey,
        size: size,
        clientsBLoC: clientsBloc,
        maskFormatter: clientsBloc.maskFormatter,
      ),
    );
  }
}
