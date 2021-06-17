import 'package:flutter/material.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';

class ProfileBLoC extends ChangeNotifier {
  final LocalRepositoryInterface localRepositoryInterface;
  final ApiRepositoryInterface apiRepositoryInterface;

  ProfileBLoC(
      {required this.localRepositoryInterface,
      required this.apiRepositoryInterface});

  bool isDark = false;
  final switchNotifier = ValueNotifier<bool>(false);

  void loadTheme() async {
    isDark = await localRepositoryInterface.getTheme() ?? false;
    switchNotifier.value = isDark;
    notifyListeners();
  }

  void updateTheme(bool isDarkValue) {
    localRepositoryInterface.saveTheme(isDarkValue);
    isDark = isDarkValue;
    //notifyListeners();
    switchNotifier.value = isDark;
  }

  Future<void> logOut() async {
    await localRepositoryInterface.clearData();
  }
}
