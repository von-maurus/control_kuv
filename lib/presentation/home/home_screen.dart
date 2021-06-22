import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:control_kuv/presentation/clientes/clientes_screen.dart';
import 'package:control_kuv/presentation/preventas/preventas_page.dart';
import 'package:control_kuv/presentation/productos/productos_screen.dart';
import 'package:control_kuv/presentation/userprofile/user_screen.dart';
import 'package:control_kuv/presentation/home/nav_bar.dart';
import 'home_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage._();

  static Widget init(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (_) => HomeBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      )..loadUser(),
      builder: (_, __) => HomePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeBLoC>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IndexedStack(
                index: bloc.indexSelected,
                children: [
                  ProductosScreen.init(context),
                  ClientesScreen(),
                  PreSalePage(
                    onShopping: () {
                      bloc.updateIndexSelected(0);
                    },
                  ),
                  UserScreen.init(context)
                ],
              ),
            ),
            NavBar(
              index: bloc.indexSelected,
              onIndexSelected: (index) {
                bloc.updateIndexSelected(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
