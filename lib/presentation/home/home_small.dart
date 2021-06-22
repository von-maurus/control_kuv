import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';

class BottomNavBarSmall extends StatelessWidget {
  BottomNavBarSmall({
    required this.index,
    required this.onIndexSelected,
    required this.preSaleBLoC,
    required this.user,
  });

  final int index;
  final onIndexSelected;
  final PreSaleBLoC preSaleBLoC;
  final Usuario user;
  final _splashRadius = 25.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: gradient1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashColor: Colors.transparent,
                  splashRadius: _splashRadius,
                  icon: Icon(
                    Icons.store_mall_directory,
                    color: index == 0 ? KuveColors.white : Colors.black87,
                  ),
                  onPressed: () => onIndexSelected(0),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: _splashRadius,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.people,
                      color: index == 1 ? KuveColors.white : Colors.black87),
                  onPressed: () => onIndexSelected(1),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange[700],
                      radius: 25.0,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.shopping_basket,
                          size: 32.0,
                          color: index == 2
                              ? KuveColors.white
                              : Colors.purple[500],
                        ),
                        onPressed: () => onIndexSelected(2),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: preSaleBLoC.productsCount == 0
                          ? const SizedBox.shrink()
                          : CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.pinkAccent,
                              child: Text(
                                preSaleBLoC.productsCount.toString(),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 35,
              ),
              InkWell(
                onTap: () => onIndexSelected(3),
                child: user.imagen!.isEmpty
                    ? ClipOval(
                        child: SvgPicture.asset(
                          'assets/icons/profile-user.svg',
                          height: 45,
                          width: 45,
                          color: Colors.orange,
                        ),
                      )
                    : CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(
                          user.imagen!,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
