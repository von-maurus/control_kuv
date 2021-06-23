import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/main_bloc.dart';
import 'package:control_kuv/data/api_repository_impl.dart';
import 'package:control_kuv/data/local_repository_impl.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/clientes/clientes_bloc.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';
import 'package:control_kuv/presentation/splash/splash_screen.dart';

void main() => runApp(ControlKuv());

class ControlKuv extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: KuveColors.kuveMorado,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MultiProvider(
      providers: [
        Provider<ApiRepositoryInterface>(
          create: (c) => ApiRepositoryImpl(),
        ),
        Provider<LocalRepositoryInterface>(
          create: (_) => LocalRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return MainBLoC(
                localRepositoryInterface: _.read<LocalRepositoryInterface>())
              ..loadTheme();
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ClientesBLoC(
              apiRepositoryInterface: context.read<ApiRepositoryInterface>())
            ..loadClients(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreSaleBLoC(
            apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductosBLoC(
            apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
            localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          ),
        )
      ],
      child: Consumer<MainBLoC>(
        builder: (context, bloc, _) {
          return MaterialApp(
            title: 'Control Kuvemar',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('en'), const Locale('es')],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
