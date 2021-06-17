import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_kuv/domain/exceptions/auth_exception.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:control_kuv/domain/requests/login_request.dart';

enum LoginState {
  loading,
  failed,
  initial,
}

class LoginBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;
  bool isObscure = true;
  bool isValidEmail = false;
  bool isValidPassword = false;

  LoginBLoC({
    required this.localRepositoryInterface,
    required this.apiRepositoryInterface,
  });

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var loginState = LoginState.initial;

  Future<bool> login(GlobalKey<ScaffoldMessengerState> scaffoldKey) async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      if (!isValidEmail || !isValidPassword) {
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2500),
            content: Text('Campos incorrectos, vuelva a intentarlo'),
          ),
        );
        return false;
      } else {
        try {
          loginState = LoginState.loading;
          notifyListeners();
          final loginResponse = await apiRepositoryInterface.login(
            LoginRequest(email, password),
          );
          await localRepositoryInterface.saveToken(loginResponse.token);
          await localRepositoryInterface.saveUser(loginResponse.usuario);
          loginState = LoginState.initial;
          notifyListeners();
          return true;
        } on AuthException catch (_) {
          print(_);
          loginState = LoginState.initial;
          notifyListeners();
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 2500),
              content: Text('E-mail o contraseña incorrectos.'),
            ),
          );
          return false;
        } on Exception catch (e) {
          print(e);
          loginState = LoginState.initial;
          notifyListeners();
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 2500),
              content: Text('Error de conexión, intentelo nuevamente.'),
            ),
          );
          return false;
        }
      }
    } else {
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2500),
          content: Text('Los campos no pueden ser vacíos.'),
        ),
      );
      return false;
    }
  }

  void showHidePassword() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
