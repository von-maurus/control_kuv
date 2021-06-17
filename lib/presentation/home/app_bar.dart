import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,
    {bool isTransparent = false, required String title, required Size size}) {
  return AppBar(
    backgroundColor: isTransparent ? Colors.transparent : Colors.white,
    elevation: 0,
    actions: [
      _StatusButton(),
      _RoundedProfilePicture(
        size: size,
      )
    ],
    title: !isTransparent ? Text(title) : null,
    centerTitle: true,
  );
}

class _StatusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isConnected = true;
    return Container(
      margin: EdgeInsets.only(right: 7.0),
      child: isConnected
          ? InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                print("Mostrar snackbar verde 'Conectado'");
              },
              child: Icon(
                Icons.check_circle,
                color: Colors.green[300],
              ),
            )
          : InkWell(
              onTap: () {
                print("Mostrar snackbar rojo 'Desconectado'");
              },
              child: Icon(
                Icons.offline_bolt,
                color: Colors.red,
              ),
            ),
    );
  }
}

class _RoundedProfilePicture extends StatelessWidget {
  final Size size;

  const _RoundedProfilePicture({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2, top: 2),
      child: RawMaterialButton(
        splashColor: Colors.blue,
        fillColor: Colors.transparent,
        elevation: 2,
        shape: CircleBorder(),
        onPressed: () {
          //  mostrar imagen de perfil hero para editar
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            'assets/images/james.png',
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
