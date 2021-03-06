import 'dart:io';
import 'package:control_kuv/domain/models/cliente.dart';
import 'package:control_kuv/presentation/clientes/clientes_bloc.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientSearchDelegate extends SearchDelegate<Cliente> {
  final ClientesBLoC clientesBLoC;
  final PreSaleBLoC preSaleBLoC;

  @override
  final String searchFieldLabel;
  @override
  final TextStyle? searchFieldStyle;

  ClientSearchDelegate(this.searchFieldLabel, this.searchFieldStyle,
      {required this.clientesBLoC, required this.preSaleBLoC});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        splashColor: Colors.transparent,
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      splashColor: Colors.transparent,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(Duration(milliseconds: 100));
        close(
          context,
          Cliente(id: 0, nombre: '', rut: '', correo: '', estado: 1, tipo: 1),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
          child: Text(
        'Ingrese un cliente',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: KuveColors.kuveMorado,
        ),
      ));
    }
    return FutureBuilder(
      future: clientesBLoC.getClientByNameRunEmail(query),
      builder: (_, AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? clientesBLoC.clientsByName.isNotEmpty
                ? _showClients(clientesBLoC.clientsByName)
                : Center(
                    child: Text(
                      'No se encontr?? el cliente',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: KuveColors.kuveMorado,
                      ),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(strokeWidth: 8),
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showClients(clientesBLoC.historial);
  }

  Widget _showClients(List<Cliente> clientes) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: clientes.length,
      itemBuilder: (BuildContext context, index) {
        final cliente = clientes[index];
        return ListTile(
          onTap: () async {
            await _showMyDialog(context, cliente, clientesBLoC, preSaleBLoC);
          },
          leading: cliente.tipopago == 1
              ? Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                )
              : Icon(
                  Icons.credit_card,
                  color: Colors.blue,
                ),
          title: Text(
            cliente.nombre,
            maxLines: 1,
            style: TextStyle(fontSize: 15, color: KuveColors.kuveMorado),
          ),
          subtitle: Text(
            'RUN:' + cliente.formattedRUT,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11.5,
              letterSpacing: 1.0,
              color: KuveColors.kuveMoradoLessOp,
            ),
          ),
        );
      },
    );
  }

  Future _showMyDialog(BuildContext context, Cliente cliente,
      ClientesBLoC clientsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Text(
          '\n??Confirma agregar al cliente\n\"${cliente.nombre}\" \nen la Pre-Venta?',
          style: TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            onPressed: () async {
              var response = await preSaleBLoC.addClient(cliente);
              print(response);
              if (!response) {
                Navigator.of(context).pop();
                return showReplaceClientDialog(context, preSaleBLoC, cliente);
              } else {
                Navigator.of(context).pop();
                close(context, cliente);
              }
            },
            child: Text(
              'Agregar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              close(context, cliente);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showReplaceClientDialog(
      BuildContext context, PreSaleBLoC preSaleBLoC, Cliente client) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
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
              close(context, client);
            },
            child: Text(
              'Reemplazar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              close(context, client);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
        ],
      ),
    );
  }
}
