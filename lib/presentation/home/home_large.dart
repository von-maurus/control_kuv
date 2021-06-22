import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';

class BottomNavBarLarge extends StatelessWidget {
  const BottomNavBarLarge({
    required this.index,
    required this.onIndexSelected,
    required this.preSaleBLoC,
    required this.user,
  });

  final int index;
  final onIndexSelected;
  final PreSaleBLoC preSaleBLoC;
  final Usuario user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: gradient1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.transparent,
              onPressed: () => onIndexSelected(0),
              icon: Icon(
                Icons.store_mall_directory,
                color: index == 0 ? KuveColors.white : Colors.black87,
              ),
              iconSize:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.04
                      : 50.0,
            ),
            IconButton(
              icon: Icon(Icons.people,
                  color: index == 1 ? KuveColors.white : Colors.black87),
              onPressed: () => onIndexSelected(1),
              iconSize:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.04
                      : 50.0,
            ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange[700],
                  radius: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.038
                      : 50.0,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    alignment: AlignmentDirectional.center,
                    icon: Icon(
                      Icons.shopping_basket,
                      color: index == 2 ? KuveColors.white : Colors.purple[500],
                    ),
                    onPressed: () => onIndexSelected(2),
                    iconSize: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.056
                        : 50.0,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: preSaleBLoC.productsCount == 0
                      ? const SizedBox.shrink()
                      : CircleAvatar(
                          radius: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 12
                              : 11,
                          backgroundColor: Colors.pinkAccent,
                          child: Text(
                            preSaleBLoC.productsCount.toString(),
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 12
                                  : 11,
                            ),
                          ),
                        ),
                )
              ],
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
                      ),
                    )
                  : CircleAvatar(
                      radius: 28.0,
                      backgroundImage: NetworkImage(
                        user.imagen!,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
