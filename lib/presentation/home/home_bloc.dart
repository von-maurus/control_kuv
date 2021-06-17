import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';
import 'package:flutter/material.dart';

class HomeBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  HomeBLoC(
      {required this.localRepositoryInterface,
      required this.apiRepositoryInterface});

  Usuario usuario = Usuario(nombre: '', username: '', correo: '', tipo: 1, estado: 1);
  int indexSelected = 0;

  void loadUser() async {
    usuario = (await localRepositoryInterface.getUser())!;
    notifyListeners();
  }

  void updateIndexSelected(int index) {
    indexSelected = index;
    notifyListeners();
  }
}
