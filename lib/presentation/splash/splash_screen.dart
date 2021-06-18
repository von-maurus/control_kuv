import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:control_kuv/presentation/splash/splash-large.dart';
import 'package:control_kuv/presentation/splash/splash-small.dart';
import 'package:control_kuv/presentation/splash/splash_bloc.dart';
import 'package:control_kuv/presentation/common/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashBLoC>(
      create: (_) => SplashBLoC(
        apiRepositoryInterface: context.watch<ApiRepositoryInterface>(),
        localRepositoryInterface: context.watch<LocalRepositoryInterface>(),
      )..init(context, _scaffoldKey),
      builder: (context, _) {
        final bloc = context.watch<SplashBLoC>();
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 600.0) {
            print('constraints.maxWidth ${constraints.maxWidth}');
            return SplashLarge(
              backgroundColor: KuveColors.white,
              scaffoldKey: _scaffoldKey,
              bloc: bloc,
              urlLogo: 'assets/images/logo_kuve.png',
            );
          } else {
            print('constraints.maxWidth ${constraints.maxWidth}');
            return SplashSmall(
              scaffoldKey: _scaffoldKey,
              backgroundColor: KuveColors.white,
              bloc: bloc,
              urlLogo: 'assets/images/logo_kuve.png',
            );
          }
        });
      },
    );
  }
}
