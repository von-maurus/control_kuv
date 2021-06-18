import 'package:flutter/material.dart';
import 'package:control_kuv/presentation/home/home_screen.dart';
import 'package:control_kuv/presentation/login/login.dart';
import 'package:control_kuv/presentation/splash/splash_bloc.dart';

class SplashSmall extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final SplashBLoC bloc;
  final String urlLogo;
  final Color backgroundColor;
  final Color circleColor;

  const SplashSmall(
      {required this.scaffoldKey,
      required this.bloc,
      required this.urlLogo,
      required this.backgroundColor,
      this.circleColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 150.0,
                  backgroundColor: circleColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      urlLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                !bloc.isTimeoutException
                    ? CircularProgressIndicator(strokeWidth: 4)
                    : ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5.0),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).backgroundColor),
                          shape: MaterialStateProperty.all(StadiumBorder()),
                        ),
                        onPressed: () => retry(context, scaffoldKey),
                        child: Text('Reintentar', textAlign: TextAlign.center),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retry(BuildContext context,
      GlobalKey<ScaffoldMessengerState> _scaffoldKey) async {
    final result = await bloc.validateSession(_scaffoldKey);
    await Future.delayed(Duration(milliseconds: 1200));
    if (result) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage.init(context),
        ),
      );
    } else {
      if (!bloc.isTimeoutException) {
        await Future.delayed(Duration(milliseconds: 2300));
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginPage.init(context),
          ),
        );
      }
    }
  }
}
