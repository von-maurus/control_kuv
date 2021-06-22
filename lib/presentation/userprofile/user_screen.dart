import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:control_kuv/presentation/userprofile/user_bloc.dart';
import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/home/home_bloc.dart';
import 'package:control_kuv/presentation/splash/splash_screen.dart';

class UserScreen extends StatelessWidget {
  UserScreen._();

  final placeholderImage = 'assets/icons/profile-user.svg';

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileBLoC(
        apiRepositoryInterface: context.read<ApiRepositoryInterface>(),
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
      )..loadTheme(),
      builder: (_, __) => UserScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: 'btnLogout',
        backgroundColor: Colors.red[600],
        elevation: 10,
        onPressed: () => _showMyDialog(context),
        child: Icon(Icons.logout),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        toolbarHeight: 41.0,
        backgroundColor: Colors.blue[900],
        title: Text(
          'Perfil',
          style: TextStyle(letterSpacing: 1.0, fontSize: 25.0),
        ),
      ),
      body: FutureBuilder<Object>(
        future: _loadUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          ///TODO: Checar tipo de usuario e info retornada
          //SOLVED: Solucion parcial ya que no es eficiente debido a las transformaciones)
          var user = Usuario.fromJson(json.decode(json.encode(snapshot.data)));
          return ListView(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: user.imagen!.isEmpty
                                ? ClipOval(
                                    child: SvgPicture.asset(
                                      placeholderImage,
                                      height: 85,
                                      width: 85,
                                      // color: Colors.blue[900],
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 65.0,
                                    backgroundImage: NetworkImage(user.imagen!),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        user.nombre,
                        style: TextStyle(
                            //color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      user.tipo == 1
                          ? Text(
                              'Administrador',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              'Vendedor',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                      _UserInfo(
                        user: user,
                      )
                    ],
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final profileBloc = Provider.of<ProfileBLoC>(context, listen: false);
    await profileBloc.logOut();
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SplashScreen(),
      ),
      (route) => false,
    );
  }

  // void onThemeUpdated(BuildContext context, bool isDark) {
  //   final profileBloc = Provider.of<ProfileBLoC>(context, listen: false);
  //   profileBloc.updateTheme(isDark);
  //   final mainBloc = context.read<MainBLoC>();
  //   mainBloc.loadTheme();
  // }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        title: Text('Aviso'),
        oldContext: _,
        content: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            '¿Desea cerrar sesión?',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async {
              await logout(context);
            },
            child: Text('Si'),
          ),
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          )
        ],
      ),
    );
  }

  Future<Usuario> _loadUser(BuildContext context) async {
    final homeBloc = Provider.of<HomeBLoC>(context);
    print('User Info: ${homeBloc.usuario}');
    return homeBloc.usuario;
  }
}

class _UserInfo extends StatelessWidget {
  final Usuario user;

  const _UserInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            color: Colors.white54,
            shadowColor: Colors.black,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Información Personal',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Usuario'),
                        subtitle: Text(user.username),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Correo'),
                        subtitle: Text(user.correo),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Teléfono'),
                        subtitle: Text('+' + user.fono!),
                      ),
                      ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text('Comisión'),
                        subtitle: Text(user.comision.toString() + '%'),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
