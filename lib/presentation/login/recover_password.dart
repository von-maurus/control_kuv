import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'login_bloc.dart';

class RecoverPasswordScreen extends StatelessWidget {
  RecoverPasswordScreen._();

  static Widget init(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return ChangeNotifierProvider(
      create: (_) => LoginBLoC(
          apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
          localRepositoryInterface: context.read<LocalRepositoryInterface>()),
      builder: (_, __) => RecoverPasswordScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constraints.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}
