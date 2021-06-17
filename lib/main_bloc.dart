import 'package:flutter/material.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';

class MainBLoC extends ChangeNotifier {
  late ThemeData currentTheme;

  final LocalRepositoryInterface localRepositoryInterface;

  MainBLoC({
    required this.localRepositoryInterface,
  });

  void loadTheme() async {
    // final isDark = await localRepositoryInterface.isDarkMode() ?? false;
    updateTheme(ThemeData(
      primaryColor: Color(0xFF00838F),
      scaffoldBackgroundColor: Colors.blue,
    ));
  }

  void updateTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}
