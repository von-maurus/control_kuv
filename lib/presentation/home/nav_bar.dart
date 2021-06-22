import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'home_bloc.dart';
import 'home_large.dart';
import 'home_small.dart';

class NavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexSelected;

  const NavBar({
    required this.index,
    required this.onIndexSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBLoC>(context);
    final preSaleBLoC = Provider.of<PreSaleBLoC>(context);
    final user = bloc.usuario;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('constrains.maxWidth ${constraints.maxWidth}');
        if (constraints.maxWidth >= 600.0) {
          return BottomNavBarLarge(
            index: index,
            onIndexSelected: onIndexSelected,
            preSaleBLoC: preSaleBLoC,
            user: user,
          );
        } else {
          return BottomNavBarSmall(
            index: index,
            onIndexSelected: onIndexSelected,
            preSaleBLoC: preSaleBLoC,
            user: user,
          );
        }
      },
    );
  }
}
