import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/domain/models/cliente.dart';
import 'package:control_kuv/presentation/clientes/clientes_bloc.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/common/kuve_button.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'client_search_delegate.dart';
import 'cliente_create.dart';

class ClientesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clientsBloc = context.watch<ClientesBLoC>();
    final preSaleBloc = context.watch<PreSaleBLoC>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(context),
        appBar: buildAppBar(context, clientsBloc, preSaleBloc),
        body: clientsBloc.clientList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async => clientsBloc.loadClients(),
                color: Colors.white,
                backgroundColor: Colors.blue[900],
                child: OrientationBuilder(
                  builder: (_, orientation) {
                    if (orientation == Orientation.landscape) {
                      return GridView.builder(
                        itemCount: clientsBloc.clientList.length,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size.width >= 750 ? 4 : 3,
                          childAspectRatio: size.width >= 750
                              ? 0.92 / MediaQuery.textScaleFactorOf(context)
                              : 0.75 / MediaQuery.textScaleFactorOf(context),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final client = clientsBloc.clientList[index];
                          return buildList(
                            context,
                            index,
                            client,
                            clientsBloc.cardHeight,
                            () async => _showMyDialog(
                                context, client, clientsBloc, preSaleBloc),
                          );
                        },
                      );
                    } else if (size.width >= 600.0) {
                      return GridView.builder(
                        itemCount: clientsBloc.clientList.length,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio:
                              0.7 / MediaQuery.textScaleFactorOf(context),
                        ),
                        itemBuilder: (context, index) {
                          final client = clientsBloc.clientList[index];
                          return buildList(
                            context,
                            index,
                            client,
                            clientsBloc.cardHeight,
                            () async => _showMyDialog(
                                context, client, clientsBloc, preSaleBloc),
                          );
                        },
                      );
                    }
                    return GridView.builder(
                      itemCount: clientsBloc.clientList.length,
                      physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio:
                            1.5 / MediaQuery.textScaleFactorOf(context),
                        crossAxisSpacing: 11,
                        mainAxisSpacing: 11,
                      ),
                      itemBuilder: (context, index) {
                        final client = clientsBloc.clientList[index];
                        return buildList(
                          context,
                          index,
                          client,
                          clientsBloc.cardHeight,
                          () async => _showMyDialog(
                              context, client, clientsBloc, preSaleBloc),
                        );
                      },
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black45,
                ),
              ),
      ),
    );
  }

  AppBar buildAppBar(
      BuildContext context, ClientesBLoC clientsBloc, PreSaleBLoC preSaleBloc) {
    return AppBar(
      elevation: 6.0,
      title: Text('Clientes'),
      toolbarHeight: 45.0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            size: 30,
          ),
          color: Colors.white,
          onPressed: () async {
            await toSearch(context, clientsBloc, preSaleBloc);
          },
          splashColor: Colors.transparent,
        )
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'btnCreateClient',
      elevation: 25,
      onPressed: () async {
        final client = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ClientCreate()));
        if (client != null) {
          print('Cliente Creado $client');
        }
      },
      child: Icon(
        Icons.add,
        size: 38,
      ),
    );
  }

  Future _showMyDialog(BuildContext context, Cliente client,
      ClientesBLoC clientsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Text(
          '\n??Confirma agregar al cliente\n\"${client.nombre}\" \nen la Pre-Venta?',
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async => _onAddClient(preSaleBLoC, client, context),
            child: Text(
              'Agregar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onAddClient(
      PreSaleBLoC preSaleBLoC, client, BuildContext context) async {
    var response = await preSaleBLoC.addClient(client);
    print(response);
    if (!response) {
      Navigator.of(context).pop();
      await showReplaceClientDialog(context, preSaleBLoC, client);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> showReplaceClientDialog(
      BuildContext context, PreSaleBLoC preSaleBLoC, Cliente client) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text(
            'Advertencia',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          'Ya existe un cliente en la \nPre-Venta.\n??Desea reemplazarlo?',
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              preSaleBLoC.updateClient(client);
              Navigator.of(context).pop();
            },
            child: Text(
              'Reemplazar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 17.0),
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(BuildContext context, int index, Cliente client,
      double cardHeight, VoidCallback onTap) {
    if (client.tipopago == 1) {
      cardHeight = 150;
    }
    return Card(
      margin: EdgeInsets.only(
          right: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.01
              : MediaQuery.of(context).size.width * 0.0001,
          left: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.01
              : MediaQuery.of(context).size.width * 0.0001,
          top: 25),
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: KuveColors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  client.nombre,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: KuveColors.blue,
                  ),
                ),
                Text(
                  client.tipoChanged,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: KuveColors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        client.direccion.trim().isNotEmpty
                            ? client.direccion
                            : 'Sin informaci??n',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.5,
                          letterSpacing: .3,
                          color: KuveColors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    client.tipopago == 1
                        ? Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.black,
                            size: 25,
                          )
                        : Icon(
                            Icons.payment,
                            color: Colors.black,
                            size: 25,
                          ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      client.tipopago == 1 ? 'Efectivo' : 'Cr??dito',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: KuveColors.blue,
                          fontSize: 14.5,
                          letterSpacing: .3),
                    ),
                  ],
                ),
                client.tipopago == 1
                    ? Container()
                    : client.tipopago == 2
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                color: Colors.black,
                                size: 25,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  '${client.numDias} D??as a pagar',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    letterSpacing: .3,
                                    color: KuveColors.blue,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: KuveButton(
                    fontSize: 16.0,
                    text: 'A??adir',
                    onTap: onTap,
                    padding: EdgeInsets.symmetric(
                      vertical: 13.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future toSearch(BuildContext context, ClientesBLoC clientsBloc,
      PreSaleBLoC preSaleBloc) async {
    final cliente = await showSearch(
        context: context,
        delegate: ClientSearchDelegate('Nombre - RUT - Email',
            TextStyle(fontSize: 16.0, color: KuveColors.white),
            clientesBLoC: clientsBloc, preSaleBLoC: preSaleBloc));
    if (cliente!.id != 0) {
      //TODO: Guardar historial de busqueda en SharedPreferences localmente
      if (!clientsBloc.historial.any((element) => element.id == cliente.id)) {
        if (clientsBloc.historial.length >= 10) {
          clientsBloc.historial.removeLast();
          clientsBloc.historial.insert(0, cliente);
        } else {
          clientsBloc.historial.insert(0, cliente);
        }
      }
    }
  }
}
