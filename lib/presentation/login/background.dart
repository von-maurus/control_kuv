import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({required this.size, required this.child});

  final Size size;
  final top_image = 'assets/images/main_top.png';

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? size.width * 0.15
                  : size.width * 0.28,
              child: Image.asset(
                top_image,
                fit: BoxFit.fill,
              ),
            ),
            child,
          ],
        ));
  }
}
