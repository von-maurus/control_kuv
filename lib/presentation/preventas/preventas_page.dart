import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/domain/models/preventa_cart.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/home/home_bloc.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'checkout_landscape_page.dart';
import 'checkout_portrait_page.dart';

class PreSalePage extends StatelessWidget {
  final VoidCallback onShopping;

  PreSalePage({required this.onShopping});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 80.0
                    : 53,
            bottom: TabBar(
              indicatorWeight: 6.5,
              indicatorColor: KuveColors.kuveVerde,
              labelColor: KuveColors.white,
              tabs: [
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? Tab(
                        text: 'Productos',
                      )
                    : Tab(
                        text: 'Productos',
                        icon: Icon(
                          Icons.shopping_cart,
                          size: 25.0,
                        ),
                        iconMargin: EdgeInsets.all(2.0),
                      ),
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? Tab(
                        text: 'Finalizar Venta',
                      )
                    : Tab(
                        text: 'Finalizar Venta',
                        icon: Icon(
                          Icons.payments,
                          size: 25.0,
                        ),
                        iconMargin: EdgeInsets.all(2.0),
                      )
              ],
            ),
          ),
          body: bloc.totalItems == 0
              ? EmptyCart(
                  onShopping: onShopping,
                )
              : TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _ProductCartScreen(),
                    _CheckoutScreen(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProductCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  onPressed: () => _clearCart(bloc, context),
                  child: Row(
                    children: [
                      Text(
                        'Vaciar carro',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.04),
                      ),
                      Icon(
                        Icons.clear,
                        size: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.03
                            : MediaQuery.of(context).size.width * 0.055,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 2
                        : 2,
                childAspectRatio:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 2
                        : 2 / 3.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final preSaleCart = bloc.preSaleList[index];
                return _ShoppingCartProduct(
                  preSaleCart: preSaleCart,
                  onDelete: () {
                    bloc.deleteProduct(preSaleCart);
                  },
                  onIncrement: () {
                    bloc.increment(preSaleCart);
                  },
                  onDecrement: () {
                    bloc.decrement(preSaleCart);
                  },
                );
              },
              itemCount: bloc.preSaleList.length,
            ),
          ),
        ],
      ),
    );
  }

  void _clearCart(PreSaleBLoC bloc, BuildContext context) {
    if (bloc.preSaleList.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialogPage(
          oldContext: _,
          content: Text(
            'Se limpiar?? el carrito de ventas. ??Desea continuar?',
            style: TextStyle(fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                bloc.cleanSalesCart();
                Navigator.of(context).pop();
              },
              child: Text(
                'Continuar',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }
  }
}

class _CheckoutScreen extends StatelessWidget {
  final formatter =
      NumberFormat.currency(locale: 'es', decimalDigits: 0, symbol: '');

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PreSaleBLoC>();
    final homeBloc = context.watch<HomeBLoC>();

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return CheckoutLandscapeView(
              bloc: bloc,
              formatter: formatter,
              homeBloc: homeBloc,
            );
          }
          return CheckoutPortraitView(
            bloc: bloc,
            formatter: formatter,
            homeBloc: homeBloc,
          );
        },
      ),
    );
  }
}

class _ShoppingCartProduct extends StatelessWidget {
  const _ShoppingCartProduct({
    required this.preSaleCart,
    required this.onDelete,
    required this.onDecrement,
    required this.onIncrement,
  });

  final PreSaleCart preSaleCart;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es',
      decimalDigits: 0,
      symbol: 'CLP',
    );
    final product = preSaleCart.product;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Card(
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(
                              product.imagen,
                              fit: BoxFit.fitHeight,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nombre,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: KuveColors.kuveMorado,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '\$${formatter.format(preSaleCart.precioLinea)} ',
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25.0,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: onDecrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 36.0,
                                    color: KuveColors.purple,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  preSaleCart.quantity.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    color: KuveColors.kuveMorado,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: onIncrement,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: KuveColors.purple,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: KuveColors.white,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: onDelete,
                child: CircleAvatar(
                  backgroundColor: KuveColors.pink,
                  child: Icon(
                    Icons.delete_outline,
                    color: KuveColors.kuveMorado,
                    size: 25.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Card(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(
                            product.imagen,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          product.nombre,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: KuveColors.kuveMorado,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '\$${formatter.format(preSaleCart.precioLinea)} ',
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.5,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: onDecrement,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 36.0,
                                  color: KuveColors.purple,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                preSaleCart.quantity.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: KuveColors.kuveMorado,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: onIncrement,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: KuveColors.purple,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: KuveColors.white,
                                  size: 35.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              onTap: onDelete,
              child: CircleAvatar(
                backgroundColor: KuveColors.pink,
                child: Icon(
                  Icons.delete_outline,
                  color: KuveColors.kuveMorado,
                  size: 25.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  final VoidCallback onShopping;

  const EmptyCart({required this.onShopping});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sad.png',
                height: 100,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              Text(
                'No hay productos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(10),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(KuveColors.purple)),
                  onPressed: onShopping,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Ver Productos',
                        style:
                            TextStyle(color: KuveColors.white, fontSize: 16.5)),
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
