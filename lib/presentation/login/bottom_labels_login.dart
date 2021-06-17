import 'package:flutter/material.dart';

class BottomLabels extends StatelessWidget {
  const BottomLabels(
      {required this.size,
      required this.endIndent,
      required this.indent,
      this.sizeForgotPass = 15.0,
      this.fontSizeNotAccount = 15.0,
      this.fontSizeContact = 17.0,
      this.fontSizeTerms = 17.0,
      this.adminEmail = 'dist.aripar@gmail.com'});

  final Size size;
  final double indent;
  final double endIndent;
  final double sizeForgotPass;
  final double fontSizeNotAccount;
  final double fontSizeContact;
  final double fontSizeTerms;
  final String adminEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // FlatButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Olvidé la contraseña',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: sizeForgotPass,
          //         fontWeight: FontWeight.w500),
          //   ),
          // ),
          SizedBox(
            height: size.height * 0.025,
          ),
          Divider(
            thickness: 1.2,
            color: Colors.black54,
            indent: indent,
            endIndent: endIndent,
          ),
          Text(
            '¿No tienes cuenta?',
            style: TextStyle(
                color: Colors.black54,
                fontSize: fontSizeNotAccount,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Text(
            'Contáctate con el administrador al correo:\n$adminEmail',
            style: TextStyle(fontSize: fontSizeContact),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.09,
          ),
        ],
      ),
    );
  }
}
