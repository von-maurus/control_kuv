import 'package:control_kuv/presentation/common/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/domain/models/preventa_cart.dart';
import 'package:control_kuv/presentation/home/home_bloc.dart';
import 'package:control_kuv/presentation/home/home_screen.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';

class CheckoutPortraitView extends StatelessWidget {
  const CheckoutPortraitView({
    required this.bloc,
    required this.formatter,
    required this.homeBloc,
  });

  final PreSaleBLoC bloc;
  final NumberFormat formatter;
  final HomeBLoC homeBloc;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductosBLoC>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(11.5),
          child: Card(
            color: KuveColors.kuveMorado,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            margin: EdgeInsets.zero,
            elevation: 18,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Cliente',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        bloc.client.nombre.isEmpty
                            ? 'No Seleccionado'
                            : bloc.client.nombre + '\n' + bloc.client.rut,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'M??todo de Pago',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        splashColor: KuveColors.kuveVerde,
                        iconSize: 25.0,
                        onPressed: () async {
                          print('Cliente: ${bloc.client.id}');
                          if (bloc.client.id != null && bloc.client.id != 0) {
                            return buildEditDialog(context, bloc);
                          }
                        },
                      ),
                      Text(
                        bloc.payType == 0
                            ? 'No Seleccionado'
                            : bloc.payType == 1
                                ? 'Efectivo'
                                : 'Cr??dito\n${bloc.diasCuota == 0 ? '' : bloc.numDias} d??as a pagar',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${formatter.format(bloc.totalPrice)}',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final preSaleCart = bloc.preSaleList[index];
                    return buildCheckoutDetail(preSaleCart);
                  },
                  separatorBuilder: (context, index) => Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                    thickness: 1.5,
                    height: 0,
                  ),
                  itemCount: bloc.preSaleList.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(StadiumBorder()),
                    ),
                    onPressed: () async {
                      return await _confirmSale(context, productBloc);
                    },
                    child: Text(
                      'Confirmar Pre-venta',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  ListTile buildCheckoutDetail(PreSaleCart preSaleCart) {
    return ListTile(
      title: Text(
        preSaleCart.product.nombre + ' x' + preSaleCart.quantity.toString(),
        maxLines: 1,
        style: TextStyle(fontSize: 16.5, color: KuveColors.kuveMorado),
      ),
      trailing: Text(
        '\$' + formatter.format(preSaleCart.precioLinea),
        style: TextStyle(fontSize: 18.5, color: KuveColors.kuveMorado),
      ),
    );
  }

  Future<void> _confirmSale(
      BuildContext context, ProductosBLoC productBloc) async {
    if (bloc.client.id != null && bloc.client.id != 0) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialogPage(
          oldContext: _,
          title: Center(
              child: Text(
            'Aviso',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          )),
          content: Text(
            'Se crear?? una Pre-Venta.\n??Desea continuar?...',
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                return await _onCheckOut(context, productBloc);
              },
              child: Text(
                'Aceptar',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
            child: Text(
          'Alerta',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        )),
        content: Text(
          'Debe seleccionar un cliente',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                homeBloc.updateIndexSelected(1);
              },
              child: Text(
                'Aceptar',
                style: TextStyle(fontSize: 18.0),
              ))
        ],
      ),
    );
  }

  Future<void> _onCheckOut(
      BuildContext context, ProductosBLoC productBloc) async {
    Navigator.of(context).pop();
    //Esperar respuesta
    final response = await bloc.checkOut();
    //Mostrar AlertDialog con respuesta
    return buildResponseDialog(context, response, productBloc);
  }

  Future<void> buildResponseDialog(
      BuildContext context, dynamic response, ProductosBLoC productBloc) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text('Pre-Venta'),
        ),
        //TODO: Mejorar la repuesta de stock insuficiente, retornando la lista de productos rechazados (ListViewBuilder)
        content: bloc.isStockError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$response',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              )
            : Container(
                child: Text(
                  '$response',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async => _exitCheckOut(context),
            child: Text(
              'Aceptar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          SizedBox(
            width: 85.0,
          ),
        ],
      ),
    );
  }

  void _exitCheckOut(BuildContext context) {
    if (bloc.isAnyError || bloc.isStockError) {
      //Permanecer en la vista
      Navigator.of(context).pop();
    } else {
      //Vaciar carrito de compras, redirigir a pantalla Productos y recargar lista de productos
      bloc.cleanSalesCart();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage.init(context),
        ),
        (route) => false,
      );
    }
  }

  Future buildEditDialog(BuildContext context, PreSaleBLoC bloc) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialogPage(
        title: Text('Seleccione'),
        oldContext: _,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        size: 35.0,
                        color: Colors.blue[900],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Efectivo',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: 1,
                    groupValue: bloc.payType,
                    onChanged: (value) {
                      setState(() =>
                          bloc.changePayType(int.parse(value.toString()), 1));
                    },
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.credit_card_rounded,
                        size: 35.0,
                        color: Colors.blue[900],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Cr??dito',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  leading: Radio(
                    value: 2,
                    groupValue: bloc.payType,
                    onChanged: (value) {
                      setState(() =>
                          bloc.changePayType(int.parse(value.toString()), 1));
                    },
                  ),
                ),
                bloc.payType == 1
                    ? SizedBox.shrink()
                    : SizedBox(
                        child: Container(
                          color: Colors.white24,
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '7 d??as',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 1,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType,
                                        int.parse(value.toString())));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '15 d??as',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 2,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType,
                                        int.parse(value.toString())));
                                  },
                                ),
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      '30 d??as',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Radio(
                                  value: 3,
                                  groupValue: bloc.diasCuota,
                                  onChanged: (value) {
                                    setState(() => bloc.changePayType(
                                        bloc.payType,
                                        int.parse(value.toString())));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
