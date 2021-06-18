import 'package:flutter/material.dart';
import 'package:control_kuv/presentation/splash/splash_bloc.dart';
import 'package:control_kuv/presentation/home/home_screen.dart';
import 'package:control_kuv/presentation/login/login.dart';

class SplashLarge extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final SplashBLoC bloc;
  final String urlLogo;
  final Color backgroundColor;
  final Color circleColor;

  const SplashLarge({
    required this.scaffoldKey,
    required this.bloc,
    required this.urlLogo,
    required this.backgroundColor,
    this.circleColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.blue[800],
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.25,
                  backgroundColor: Colors.blue[900],
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Image.asset(
                      urlLogo,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                !bloc.isTimeoutException
                    ? SizedBox(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.07
                            : MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.07
                            : MediaQuery.of(context).size.width * 0.1,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue[900],
                          strokeWidth: 10,
                        ),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5.0),
                            shape: MaterialStateProperty.all(StadiumBorder()),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        onPressed: () => retry(context, scaffoldKey),
                        child: Text(
                          'Reintentar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
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
